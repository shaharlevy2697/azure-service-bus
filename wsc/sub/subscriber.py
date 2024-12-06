from azure.servicebus import ServiceBusClient
import requests
import json


CONNECTION_STR = "fill-this"
TOPIC_NAME = "job-topic"
SUBSCRIPTION_NAME = "job-subscription"

def process_job_message(message_body):
    job = json.loads(message_body)
    print(f"Processing Job ID: {job['id']}, Sport: {job['sportType']}")

    # Make an API call to the job's URL
    try:
        response = requests.get(job["apiUrl"])
        if response.status_code == 200:
            print(f"API call successful for Job ID: {job['id']}")
        else:
            print(f"API call failed for Job ID: {job['id']}, Status Code: {response.status_code}")
    except Exception as e:
        print(f"Error making API call for Job ID: {job['id']}: {e}")

def receive_messages():
    servicebus_client = ServiceBusClient.from_connection_string(conn_str=CONNECTION_STR, logging_enable=True)
    with servicebus_client:
        receiver = servicebus_client.get_subscription_receiver(topic_name=TOPIC_NAME, subscription_name=SUBSCRIPTION_NAME)
        with receiver:
            for message in receiver:
                print(f"Received: {str(message)}")
                process_job_message(str(message))
                receiver.complete_message(message)

if __name__ == "__main__":
    receive_messages()