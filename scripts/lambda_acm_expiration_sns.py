import json
import boto3
import os
import logging
from typing import Dict, List, Optional


# Initialize the logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize the SNS client
sns_client = boto3.client('sns')

def extract_acm_details(event: Dict) -> Optional[str]:
    """
    Extract necessary details from the ACM event and format them into a message.

    Args:
        event (Dict): The event data, typically containing ACM expiration details.

    Returns:
        Optional[str]: A formatted message containing account, region, resources,
        DaysToExpiry, and CommonName.
    """
    account = event.get('account')
    region = event.get('region')
    resources = event.get('resources', [])
    days_to_expiry = event.get('detail', {}).get('DaysToExpiry')
    common_name = event.get('detail', {}).get('CommonName')

    # Format the message to be sent to SNS
    message = (
        f"ACM Certificate Expiration Alert:\n\n"
        f"Account: {account}\n"
        f"Region: {region}\n"
        f"Resources: {', '.join(resources)}\n"
        f"Days to Expiry: {days_to_expiry}\n"
        f"Common Name: {common_name}\n"
    )

    return message

def lambda_handler(event, context):
    """
       AWS Lambda function that publishes a message to an SNS topic. 
       This method extracts important details from ACM expiration events and publishes to
       SNS topic.
       
       The SNS topic ARN is retrieved from the environment variable 'SNS_TOPIC_ARN'.
       If the environment variable is not set, the function will raise a ValueError. 
       
       In case of other exceptions during the message publishing process, the function will return 
        a 500 error response.
       
       Args:
        event (dict): ACM Expiration Event.
        context (LambdaContext): Contains runtime information for the Lambda function.
        

       Returns:
        dict: A response with status code and message. 
        If the SNS message is published successfully, the status code is 200. 
        If there is an error, the status code is 500.
    
        Raises:
            ValueError: If the 'SNS_TOPIC_ARN' environment variable is missing or empty.
    """
    sns_topic_arn = os.environ.get('SNS_TOPIC_ARN')
    SUBJECT = "ACM Certificate Expiration Alert"
    
    if not sns_topic_arn:
        logger.error("Environment variable 'SNS_TOPIC_ARN' is missing or empty.")
        raise ValueError("Environment variable 'SNS_TOPIC_ARN' is missing or empty")

    # Extract the formatted message from the event
    message = extract_acm_details(event)
    logger.info(f"Publishing message to SNS topic: {sns_topic_arn}")
    logger.info(f"Message to be sent: {message}")
    
    try:
        # Publish the message to the SNS topic
        response = sns_client.publish(
            TopicArn=sns_topic_arn,
            Message=message,
            Subject=SUBJECT,
        )

        # Log the success response
        logger.info(f"SNS message sent successfully. Response: {response}")

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'SNS message sent successfully!',
                'response': response
            })
        }

    except Exception as e:
        # Log the error
        logger.error(f"Error occurred while processing the event: {str(e)}")

        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e)
            })
        }
    