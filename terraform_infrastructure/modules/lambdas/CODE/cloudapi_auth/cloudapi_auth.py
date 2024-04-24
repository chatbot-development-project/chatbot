import json

verify_token = 'abc123'

def lambda_handler(event, context):
    response = {}
    
    if event.get('queryStringParameters') and event['queryStringParameters'].get('hub.verify_token') == verify_token:
        response['statusCode'] = 200
        response['body'] = event['queryStringParameters']['hub.challenge']
    else:
        response['statusCode'] = 400
        
    print("response: " + json.dumps(response))

    return response
