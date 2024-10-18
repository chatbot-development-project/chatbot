import json
import boto3
import time
import io
import os
from boto3.dynamodb.conditions import Key

# AWS service clients
lambda_client = boto3.client('lambda')
ddb = boto3.resource('dynamodb')
bedrock_client = boto3.client('bedrock-agent-runtime', region_name='us-east-1')
s3 = boto3.client('s3')

# DynamoDB tables
user_metadata = ddb.Table('user_metadata')
user_session_record = ddb.Table('user_session_record')
session_table = ddb.Table('session_table')

# Bedrock model configuration
bedrock_model_arn = "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0"
knowledge_base_id = "NW1XPHSZL8"

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

def format_history(history):
    last_3_entries = history[-1:]
    formatted = ""
    for entry in last_3_entries:
        role = entry['role']
        content = entry['content'][0]['text']
        formatted += f"{role}: {content}\n"
        print(formatted)
    return formatted

def generate_response(prompt, history):
    print("starting the conversation")

    modified_prompt = f"""
    Role:
    You are a highly intelligent and efficient assistant. 
    Guidelines:
    - Keep responses short, ideally no more than 2-3 sentences.
    - Use simple and direct language to ensure easy understanding.
    - Avoid unnecessary details or complex explanations unless specifically requested by the user.
    - If a question requires more context, prompt the user for clarification before answering.
    - Always respond in English unless asked otherwise.    
    Your priority is to make sure the user feel helped and satisfied with as little text as possible.
    Question:
    {prompt}
    """


    formatted_history = format_history(history)
    input_text = f"{formatted_history}User: {modified_prompt}"    

    try:
        response = bedrock_client.retrieve_and_generate(
            input={
                "text": input_text
            },
            retrieveAndGenerateConfiguration={
                "type": "KNOWLEDGE_BASE",
                "knowledgeBaseConfiguration": {
                    "knowledgeBaseId": knowledge_base_id,
                    "modelArn": bedrock_model_arn
                }
            }
        )
        
        print("Got the conversation record")
        generated_text = response['output']['text']
        return generated_text
    except Exception as e:
        print(f"Error in retrieve_and_generate: {str(e)}")
        return "I'm sorry, I encountered an error while processing your request."


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

            lambda_client.invoke(
                FunctionName='delay_message',
                InvocationType='Event',
                Payload=json.dumps({
                    'message_id': message_id,
                    'whatsapp_number': whatsapp_number,
                    'whatsapp_message': whatsapp_message,
                    'body': 'none'
                })
            )
            print('Invoke delay')

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
        
        lambda_client.invoke(
            FunctionName='delay_message',
            InvocationType='Event',
            Payload=json.dumps({
                'message_id': message_id,
                'whatsapp_number': whatsapp_number,
                'whatsapp_message': whatsapp_message,
                'body': 'none'
            })
        )
        print('Invoke delay')        
        
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