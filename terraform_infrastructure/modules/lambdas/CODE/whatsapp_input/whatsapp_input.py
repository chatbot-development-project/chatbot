import json
import boto3
from datetime import datetime

ddb = boto3.client('dynamodb', region_name='us-east-1')

def create_message(request_id, date_time, whatsapp_number, whatsapp_message):
    """
    Function to write a message to a DynamoDB table.
    """
    # Write message to DynamoDB table 'user_meta_data'
    params = {
        'TableName': 'user_metadata',
        'Item': {
            'message_id': {'S': request_id},
            'timestamp': {'S': str(date_time)},
            'whatsapp_number': {'S': whatsapp_number},
            'whatsapp_message': {'S': whatsapp_message}
        }
    }
    ddb.put_item(**params)


def lambda_handler(event, context):
    print(event)
    print(context)
    response = {}
    
    request_id = context.aws_request_id
    whatsapp_message = event['entry'][0]['changes'][0]['value']['messages'][0]['text']['body']
    whatsapp_number = event['entry'][0]['changes'][0]['value']['contacts'][0]['wa_id']   
    
    timestamp = int(event['entry'][0]['changes'][0]['value']['messages'][0]['timestamp'])
    date_time = datetime.utcfromtimestamp(timestamp)
    
    create_message(request_id, date_time, whatsapp_number, whatsapp_message)
    response['statusCode'] = 200
    
    return response
