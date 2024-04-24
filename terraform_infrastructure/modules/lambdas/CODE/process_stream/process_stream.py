import json
import boto3

lambda_client = boto3.client('lambda')

def lambda_handler(event, context):
    print(event)
    print(context)
    
    whatsapp_number = event['Records'][0]['dynamodb']['NewImage']['whatsapp_number']['N']
    whatsapp_message = event['Records'][0]['dynamodb']['NewImage']['whatsapp_message']['S']
    message_id = event['Records'][0]['dynamodb']['NewImage']['message_id']['S']
    

    bedrock = boto3.client(
        service_name='bedrock-runtime',
        region_name='us-east-1'
    )

    prompt = f"""The following is a friendly conversation between a human and an AI. 
    The AI is talkative and provides lots of specific details from its context. 
    If the AI does not know the answer to a question, it truthfully says it does not know.
    Always reply in the original user language.

    Human:{whatsapp_message}

    Assistant:"""

    # Define the body content as a dictionary
    content = {
        "prompt": prompt,
        "max_tokens": 200,
        "temperature": 0.9,
        "p": 1,
        "k": 0
    }
    # Convert the dictionary to a JSON-formatted string
    body = json.dumps(content)
    
    # Define the input data that will be passed to bedrock model
    input_data = {
        "modelId": "cohere.command-text-v14",
        "contentType": "application/json",
        "accept": "*/*",
        "body": body
    }

    # invoke the model
    response = bedrock.invoke_model(
        body=input_data['body'],
        modelId=input_data['modelId'],
        accept=input_data['accept'],
        contentType=input_data['contentType']
    )

    response_body = json.loads(response['body'].read())
    print(response_body)
    
    # invoke the whatsapp output
    function_name = 'whatsapp_output'
    lambda_response = lambda_client.invoke(
            FunctionName = function_name,
            InvocationType = 'Event',
            Payload = json.dumps({
                'message_id': message_id,
                'whatsapp_number': whatsapp_number,
                'whatsapp_message': whatsapp_message,
                'body': response_body
            })
        )
    