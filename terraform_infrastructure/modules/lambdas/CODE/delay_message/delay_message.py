import json
import requests
import time
import os

def lambda_handler(event, context):
    print(event)
    
    # access_token = "EAAUOBAO39R4BO5rCz5TZAeQyLkC1gLM2XLrsaKhce5rSpA7GN7dswu9iLzfbUKWZBdtx5AdKLNU3ojZB7I15bNE9ZAGcVZAglZCbZBZCIDCaXZBfi0yKPqk4LNN99iAZCCpH2mrXqUEAESrWWBmNSEOvz71q7FKybIMm5qx9CetnlVCIcxiyHmKb4dN5vljEIMsbRz"
    # phone_number_id_env = "425479003978705"

    access_token = os.getenv('ACCESS_TOKEN')

    phone_number_id_env = os.getenv('PHONE_NUMBER_ID')

    url = f'https://graph.facebook.com/v19.0/{phone_number_id_env}/messages'
    
    headers = {'Authorization': f'Bearer {access_token}', 'Content-Type': 'application/json'}
    
    whatsapp_number = event['whatsapp_number']
    message_id = event['message_id']

    # First, send the "Processing Request" message
    processing_message_data = {
        "messaging_product": "whatsapp",
        "context": json.dumps({"message_id": message_id}),
        "to": whatsapp_number,
        "type": "text",
        "text": json.dumps({
            "preview_url": False,
            "body": "Processing request..."
        })
    }
    
    print("Sending 'Processing Request' message:")
    print(processing_message_data)
    
    
    # Send the "Processing Request" message
    processing_response = requests.post(url, headers=headers, data=processing_message_data)
    print("Response from 'Processing Request':")
    print(processing_response.json())
    
    