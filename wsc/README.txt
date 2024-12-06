
Azure Service Bus Communication: Publisher and Subscriber
==========================================================

This project demonstrates two microservices communicating via Azure Service Bus:
- Publisher: Sends messages to a topic.
- Subscriber: Receives messages from a subscription.

Prerequisites
-------------
- Azure CLI installed (https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Docker installed (https://www.docker.com/get-started)
- Terraform installed (https://developer.hashicorp.com/terraform/downloads)
- kubectl installed (https://kubernetes.io/docs/tasks/tools/install-kubectl/)

Running Locally
---------------
1. Extract file (wsc.zip)/clone repo

2. Install dependencies:
   
   pip install -r requirements.txt
   

3. Run the publisher:
   
   python publisher.py
   

4. Run the subscriber (in another terminal):
   
   python subscriber.py
   

Deploying to Azure
------------------
1. Set Up Azure Resources:
   Run Terraform to create the required Azure resources:
    
   terraform init
   terraform valedate
   terraform plan
   terraform apply
   

2. Build and Push Docker Images:
   
   docker build -t wsctaskforshahar.azurecr.io/pub:latest .
   docker build -t wsctaskforshahar.azurecr.io/sub:latest .

   docker push wsctaskforshahar.azurecr.io/pub:latest
   docker push wsctaskforshahar.azurecr.io/sub:latest
   

3. Deploy to AKS:
   
   kubectl apply -f publisher-deployment.yaml
   kubectl apply -f subscriber-deployment.yaml
   

4. Verify Deployments:
   
   kubectl get pods
   kubectl logs -l app=publisher
   kubectl logs -l app=subscriber
   

Cleanup
-------
1. Delete Kubernetes deployments:
   
   kubectl delete deployment publisher subscriber
   

2. Destroy Azure resources:
   
   terraform destroy
   
