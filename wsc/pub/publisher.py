from azure.servicebus import ServiceBusClient, ServiceBusMessage
import json
import time


CONNECTION_STR = "fill-this"
TOPIC_NAME = "job-topic"

def send_job_messages():
    jobs = [
        {
            "id": "95246",
            "apiUrl": "https://cdn.nba.com/static/json/liveData/playbyplay/playbyplay_0022000180.json",
            "sportType": "Basketball"
        }
    ]
    
    servicebus_client = ServiceBusClient.from_connection_string(conn_str=CONNECTION_STR, logging_enable=True)
    with servicebus_client:
        sender = servicebus_client.get_topic_sender(topic_name=TOPIC_NAME)
        with sender:
            for job in jobs:
                message = ServiceBusMessage(json.dumps(job))
                sender.send_messages(message)
                print(f"Sent: {job}")
                time.sleep(1)

if __name__ == "__main__":
    send_job_messages()