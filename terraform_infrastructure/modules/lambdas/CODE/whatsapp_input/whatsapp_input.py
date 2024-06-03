import json
import boto3
from datetime import datetime
from botocore.exceptions import ClientError

# Creates the document client specifying the region
# The table is in 'us-east-1'
ddb = boto3.client('dynamodb', region_name='us-east-1')

def lambda_handler(event, context):
    print(event)
    print(context)
    # Captures the requestId from the context message
    request_id = context.aws_request_id
    whatsapp_message = event['entry'][0]['changes'][0]['value']['messages'][0]['text']['body']
    whatsapp_number = event['entry'][0]['changes'][0]['value']['contacts'][0]['wa_id']
    # timestamp = event['entry'][0]['changes'][0]['value']['messages'][0]['timestamp']
    
    timestamp = int(event['entry'][0]['changes'][0]['value']['messages'][0]['timestamp'])
    # Assuming the timestamp is in Unix timestamp format (seconds since epoch)
    date_time = datetime.utcfromtimestamp(timestamp) # convert to proper time format
    
    print("Date and Time:", date_time)
    
    print("WhatsApp Number:", whatsapp_number)
    # print("Timestamp:", timestamp)


    try:
        # Call the createMessage function
        create_message(request_id, date_time, whatsapp_number, whatsapp_message)
        return {
            'statusCode': 200,
            'body': 'Successful'
        }
    except ClientError as err:
        print(f"Error: {err}")
        raise err

    
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