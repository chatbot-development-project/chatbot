# AI Chatbot Integration with WhatsApp

This project is an AI-powered chatbot integrated with WhatsApp, with the backend running on AWS. It leverages AWS Lambda, API Gateway, DynamoDB, and the AI functionality powered by AWS Bedrock. The chatbot enables real-time messaging capabilities and is designed to be scalable and efficient.

## Features

- **WhatsApp Integration**: Seamless integration with WhatsApp for real-time messaging.
- **AI Functionality**: AI-powered responses and interactions, powered by AWS Bedrock.
- **Scalable Backend**: Utilizes AWS Lambda and DynamoDB for a scalable and cost-effective backend infrastructure.
- **API Gateway**: Facilitates communication between WhatsApp and the backend Lambda functions.
- **Real-time Messaging**: Provides real-time messaging capabilities for instant communication with users.

## Architecture Overview

The architecture of the project consists of several components:

- **WhatsApp API**: Provides the interface for sending and receiving messages from WhatsApp users.
- **AWS Lambda**: Hosts the backend code for processing incoming messages, invoking AI functionality, and generating responses.
- **API Gateway**: Acts as a bridge between WhatsApp and Lambda functions, routing incoming requests and responses.
- **DynamoDB**: Stores chat history, user data, and other relevant information.
- **AWS Bedrock**: Powers the AI functionality, providing natural language processing capabilities for generating intelligent responses.

![Architecture Diagram](architecture_diagram.png)

## Technologies Used

- AWS Lambda
- AWS API Gateway
- AWS DynamoDB
- AWS Bedrock
- WhatsApp API

## Setup

To set up the project locally, follow these steps:

1. Clone the repository from GitHub.
2. Install dependencies using `npm install`.
3. Configure environment variables for AWS services.
4. Deploy Lambda functions and API Gateway endpoints using AWS CLI or Serverless Framework.
5. Set up WhatsApp API integration and configure webhook URL to point to the API Gateway endpoint.

## Usage

Once the project is set up, you can interact with the chatbot via WhatsApp:

1. Send a message to the WhatsApp number associated with the chatbot.
2. The chatbot will process the message, invoke AI functionality, and generate a response.
3. Receive the response in real-time and continue the conversation as needed.

## AWS Services Configuration

- **Lambda**: Configure Lambda functions with appropriate IAM roles and permissions. Set up environment variables for accessing other AWS services.
- **API Gateway**: Configure API Gateway endpoints with proper request and response mappings. Set up integration with Lambda functions.
- **DynamoDB**: Create DynamoDB tables for storing chat history and user data. Configure access policies and indexes as needed.
- **AWS Bedrock**: Set up AWS Bedrock environment with necessary models and configurations for natural language processing.

## Contributing

Contributions to the project are welcome! To contribute, follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them.
4. Push your changes to your fork.
5. Submit a pull request to the main repository.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
