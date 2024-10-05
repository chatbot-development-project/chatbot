import json
import boto3
import time
import io
import os
from boto3.dynamodb.conditions import Key

# AWS service clients
lambda_client = boto3.client('lambda')
ddb = boto3.resource('dynamodb')
bedrock_client = boto3.client('bedrock-runtime', region_name='us-east-1')
s3 = boto3.client('s3')

# DynamoDB tables
user_metadata = ddb.Table('user_metadata')
user_session_record = ddb.Table('user_session_record')
session_table = ddb.Table('session_table')

# Bedrock model configuration
bedrock_model_id = "anthropic.claude-3-sonnet-20240229-v1:0"

# Utilites
def add_message_to_history(role, content, history):
    content_structure = [{"text": content}]
    history.append({"role": role, "content": content_structure})
    print('New history has been added to table')
    print(history)
    return history

def save_history(table, item):
    response = table.put_item(Item=item)
    print('History has been saved')
    return response

def query_history(table, key, keyValue):
    response = table.query(KeyConditionExpression=Key(key).eq(keyValue))
    print('History has been queried')
    print(response)
    if 'Items' in response and response['Items']:
        return response['Items'][0]
    else:
        print("No items found in the query response")
        response['Items'] = [{'content': [{'text': 'Hello Claude'}], 'role': 'user'}]
        return response['Items'][0]

# write a function "knowledge_base" to call s3, get all objects in a bucket and put them in a list
# then return the list
def knowledge_base(bucket_name):
    object_list = []
    response = s3.list_objects_v2(Bucket=bucket_name)
    print('Starting to list docs')
    
    # Check if there are contents in the response
    if 'Contents' in response:
        # Add object keys to the list
        for obj in response['Contents']:
            object_list.append(obj['Key'])
            print(object_list)
            print('objects listed')
    
    return object_list

# Read files from the objects in the list
def read_files():
    file_contents = []
    bucket_name = 'chatbot-development-testbucket-00001'
    object_list = knowledge_base(bucket_name)
    for object_key in object_list:
        print(f"Reading file: {object_key}")
        try:
            # Get the object from S3
            response = s3.get_object(Bucket=bucket_name, Key=object_key)
            file_content = response['Body'].read()
            file_contents.append((object_key, file_content))
            print(f"Successfully read: {object_key}")           
            
        except Exception as e:
            print(f"Error reading {object_key}: {str(e)}")
    print(file_contents)
    return file_contents


def generate_response(prompt, history):
    system_prompt = [{"text": "You are a helpful assistant. \
                      Give concise summaries only. \
                      Always reply in english language."}]
    print('Load the system prompt')

    documents = read_files()
    print(documents)
    print('Loaded the knowledge base')

    # Prepare conversation history for Bedrock Converse API
    print('Print out the history')
    print(history)
    #conversation = history + [{"role": "user", "content": [{"text": prompt}]}]
    conversation = history + [{
        "role": "user",
        "content": [{"text": prompt}] + [
            {
                "document": {
                    "name": f"Document_{i}",
                    "format": "txt",
                    "source": {
                        "bytes": doc[1]
                    }
                }
            } for i, doc in enumerate(documents)
        ]
    }]

    print(conversation)
    print('Prepare conversation history')

    # Send message to Bedrock Converse API
    response = bedrock_client.converse(
        modelId=bedrock_model_id,
        messages=conversation,
        system=system_prompt,
        inferenceConfig={"maxTokens": 512, "temperature": 0.5, "topP": 0.9}
    )
    print('Get the response')
    
    # Extract response from Bedrock
    response_text = response["output"]["message"]["content"][0]["text"]
    return response_text


def lambda_handler(event, context):
    print(event)
    
    whatsapp_number = event['Records'][0]['dynamodb']['NewImage']['whatsapp_number']['S']
    whatsapp_message = event['Records'][0]['dynamodb']['NewImage']['whatsapp_message']['S']
    message_id = event['Records'][0]['dynamodb']['NewImage']['message_id']['S']
    print('Load the User data')
    
    try:
        session_data = user_session_record.get_item(Key={'phone_number': whatsapp_number})['Item']
        current_time = int(time.time())
        time_difference = current_time - session_data["session_time"]
        print('Get session data')
        
        if time_difference > 300:
            user_session_record.update_item(
                Key={'phone_number': whatsapp_number},
                UpdateExpression="set session_time=:t",
                ExpressionAttributeValues={':t': current_time}
            )
            ss_id = f"{whatsapp_number}_{current_time}"
            history = []
            print('Create session record')
        else:
            ss_id = f"{whatsapp_number}_{session_data['session_time']}"
            history = query_history(session_table, 'SessionId', ss_id)['History']
            print('Get session record')
    
    except KeyError:
        current_time = int(time.time())
        user_session_record.put_item(Item={"phone_number": whatsapp_number, "session_time": current_time})
        ss_id = f"{whatsapp_number}_{current_time}"
        history = []
        print('Create new session record')
    
    try:
        # Generate response using Bedrock Converse API
        response = generate_response(whatsapp_message, history)
        print('RESPONSE', response)

        # Invoke the next Lambda function to send the response back to WhatsApp
        lambda_client.invoke(
            FunctionName='whatsapp_output',
            InvocationType='Event',
            Payload=json.dumps({
                'message_id': message_id,
                'whatsapp_number': whatsapp_number,
                'whatsapp_message': whatsapp_message,
                'body': response
            })
        )
        print('Invoke output')
        
        # Update and save conversation history
        add_message_to_history("user", whatsapp_message, history)   
        add_message_to_history("assistant", response, history)
        save_history(session_table, {"SessionId": ss_id, "History": history})
        print(history)
        print('Chat record updated')

        return {"body": response}
        
    except Exception as e:
        print('FAILED!', e)
        return {"body": "I don't know"}
