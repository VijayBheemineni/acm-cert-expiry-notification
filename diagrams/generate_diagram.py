from diagrams import Diagram, Edge
from diagrams.aws.compute import Lambda
from diagrams.aws.integration import Eventbridge, SNS

# Create the diagram
with Diagram("ACM Cert Expiration Notification Event Flow", show=False):
    # Define the services
    acm_event = Eventbridge("ACM Expiration Events")
    event_bus = Eventbridge("Event Bus")
    lambda_function = Lambda("Lambda Function")
    sns_topic = SNS("SNS Topic")

    # Define the flow
    acm_event >> Edge(label="Event sent to") >> event_bus
    event_bus >> Edge(label="Trigger") >> lambda_function
    lambda_function >> Edge(label="Send Notification to") >> sns_topic
