import json
import boto3
import time
from datetime import datetime
from boto3.dynamodb.conditions import Key
from langchain.llms.bedrock import Bedrock
from langchain.chains import ConversationChain
from langchain.memory import ConversationBufferMemory
from langchain_community.chat_message_histories import DynamoDBChatMessageHistory

###################
#### variables ####
###################

ddb = boto3.resource('dynamodb')
user_metadata = ddb.Table('user_metadata')
user_session_record = ddb.Table('user_session_record')
session_table = ddb.Table('session_table')

lambda_client = boto3.client('lambda')

bedrock_client = boto3.client(
        service_name='bedrock-runtime',
        region_name='us-east-1'
    )
bedrock_model_id = "cohere.command-text-v14"
bedrock_model_parameter = {"temperature": 0.9, "p": 1, "k": 0}

llm = Bedrock(model_id=bedrock_model_id, model_kwargs=bedrock_model_parameter, client=bedrock_client)

##################
#### Utilites ####
##################

def dynamodb_memory(item):
    message_history = DynamoDBChatMessageHistory(
        table_name='session_table', 
        session_id=item
    )
    a = message_history.messages
    print('THIS IS THE MESSAGE HISTORY:', a)
    memory = ConversationBufferMemory(
        memory_key="history", 
        chat_memory=message_history, 
        return_messages=True,
        ai_prefix="A",
        human_prefix="H"
    )
    return memory
    
def agent_text(llm, prompt, memory):
    conversation_with_memory = ConversationChain( 
        llm = llm, #using the Bedrock LLM
        memory = memory, #with the dynamodb memory
        verbose = True #print out some of the internal states of the chain while running
    )
    conversation_with_memory.prompt.template ="""The following is a friendly conversation between a human and an AI. 
    The AI is talkative and provides lots of specific details from its context. 
    If the AI does not know the answer to a question, it truthfully says it does not know.
    Always reply in the original user language.

    Current conversation:
    {history}

    Human:{input}

    Assistant:"""
    return conversation_with_memory.predict(input=prompt)

def query_items(table, key, keyValue):
    response = table.query(
        KeyConditionExpression=Key(key).eq(keyValue)
    )
    return response['Items'][0]

def save_items(table, item):
    response = table.put_item(Item=item)
    print('New item has been added to table')
    return response

def update_session(table, value, session_time):
    try:
        session_response = table.update_item(
            Key={"phone_number" : value},
                UpdateExpression="set session_time=:item1",
                ExpressionAttributeValues={
                    ':item1': session_time
                },
                ReturnValues="UPDATED_NEW")
        print (session_response)
    except Exception as e:
        print (e)
    else:
        return session_response

#########################
#### lambda function ####
#########################

def lambda_handler(event, context):
    print(event)
    
    # whatsapp information
    whatsapp_number = event['Records'][0]['dynamodb']['NewImage']['whatsapp_number']['S']
    whatsapp_message = event['Records'][0]['dynamodb']['NewImage']['whatsapp_message']['S']
    message_id = event['Records'][0]['dynamodb']['NewImage']['message_id']['S']
    
    ###########################################
    ## validate session and get a session_id ##
    ###########################################
    
    # check if session record exists in user_session_record table
    try:
        # Check if we have an active session
        session_data = query_items(user_session_record, 'phone_number', whatsapp_number)
        current_time = int(time.time())
        time_difference = current_time - session_data["session_time"]
        
        # if yes
        if time_difference > 300:
            update_session(user_session_record, whatsapp_number, current_time)
            print("More than 300")
            ss_id = str(whatsapp_number) + "_" + str(current_time)
            print(ss_id)
        else:
            ss_id = str(whatsapp_number) + "_" + str(session_data["session_time"])
    
    # if no
    except:
        print("New Session Record")
        current_time = int(time.time())
        new_row = {"phone_number": whatsapp_number, "session_time":current_time}
        print('NEW ROW:', new_row)
        save_items(user_session_record, new_row)
        ss_id = str(whatsapp_number) + "_" + str(current_time)
 
    ###############################
    ## run the bedrock llm model ##
    ###############################
    
        
    # Run the llm
    try:
        print('REQUEST RECEIVED:', event)
        print('REQUEST CONTEXT:', context)
        print('PROMPT:', whatsapp_message)
        
        # get memory and run llm
        memory = dynamodb_memory(ss_id)
        bedrock_response = agent_text(llm, whatsapp_message, memory)

        # invoke the whatsapp output
        function_name = 'whatsapp_output'
        lambda_response = lambda_client.invoke(
            FunctionName = function_name,
            InvocationType = 'Event',
            Payload = json.dumps({
                'message_id': message_id,
                'whatsapp_number': whatsapp_number,
                'whatsapp_message': whatsapp_message,
                'body': bedrock_response
            })
        )
        
        # update session_table with record of conversation
        history = DynamoDBChatMessageHistory(table_name="session_table", session_id=ss_id)
        history.add_user_message(whatsapp_message)
        history.add_ai_message(bedrock_response)

        return({"body":bedrock_response})
        
    except Exception as e:
        print('FAILED!', e)
        return({"body":"I dont know"})
        
