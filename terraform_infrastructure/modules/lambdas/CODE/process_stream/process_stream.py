import json
import boto3
import time
import os
from boto3.dynamodb.conditions import Key

# AWS service clients
lambda_client = boto3.client('lambda')
ddb = boto3.resource('dynamodb')
bedrock_client = boto3.client('bedrock-runtime', region_name='us-east-1')

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
    return response['Items'][0]
    #return response['Items'][0] if response['Items'] else None
  

def generate_response(prompt, history):
    system_prompt = [{"text": "You are a helpful assistant. Always reply in english language."}]
    print('Load the system prompt')
    
    # Prepare conversation history for Bedrock Converse API
    print('Print out the history')
    print(history)
    conversation = history + [{"role": "user", "content": [{"text": prompt}]}]
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
