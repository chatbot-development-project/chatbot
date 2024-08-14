import json
import os
import boto3
import requests

def lambda_handler(event, context):
    print(event)
    
    # access_token = "EAAUOBAO39R4BO5rCz5TZAeQyLkC1gLM2XLrsaKhce5rSpA7GN7dswu9iLzfbUKWZBdtx5AdKLNU3ojZB7I15bNE9ZAGcVZAglZCbZBZCIDCaXZBfi0yKPqk4LNN99iAZCCpH2mrXqUEAESrWWBmNSEOvz71q7FKybIMm5qx9CetnlVCIcxiyHmKb4dN5vljEIMsbRz"
    access_token = os.getenv('ACCESS_TOKEN')

    phone_number_id_env = os.getenv('PHONE_NUMBER_ID')

    url = f'https://graph.facebook.com/v19.0/{phone_number_id_env}/messages'

    # url = f'https://graph.facebook.com/v19.0/265131066689179/messages'
    
    headers = {'Authorization': f'Bearer {access_token}', 'Content-Type': 'application/json'}
    
    whatsapp_number = event['whatsapp_number']
    message_id = event['message_id']
    bedrock_output = event['body']['generations'][0]['text']

    data = {
        "messaging_product": "whatsapp",
        "context": json.dumps({"message_id": message_id}),
        "to": whatsapp_number,
        "type": "text",
        "text": json.dumps({
            "preview_url": False,
            "body": bedrock_output
        })
    }
    
    print (data)
    
    response = requests.post(url, headers=headers, data=data)
    response_json = response.json()
    print (response_json)
