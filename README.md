# 🚀 ECS Service Restart Orchestration (AWS-Native, No Downtime)

This project automates **daily ECS service restarts** without downtime using **EventBridge Scheduler**, **Lambda**, and **IAM**, with support for **multiple services across clusters and regions**. Ideal for use cases such as:

> 🧾 **Use Case**: Automatically restart ECS services after midnight to rotate log files in a sidecar CloudWatch Agent container (which only creates new logs upon task restart).

---

## 📌 Features

- ✅ AWS-native (no 3rd-party or external libraries)
- ✅ Uses **EventBridge Scheduler**, not Rules
- ✅ Supports **multiple services via JSON array**
- ✅ Scalable and reusable across environments
---

## 🛠️ How It Works

1. **EventBridge Scheduler** triggers every night at `12:01 AM EST` (`cron(1 5 * * ? *)` UTC)
2. The scheduler **passes a JSON array** of ECS services to a Lambda function
3. Lambda loops over the array and **force-deploys each ECS service**, triggering new task launches

---

## 🧪 Example `scheduler_input.json`

```json
{
  "services": [
    {
      "cluster": "my-ecs-cluster-east",
      "service": "my-service-east"
    },
    {
      "cluster": "my-ecs-cluster-west",
      "service": "my-service-west"
    }
  ]
}

```
## 🚀 Deployment Steps

### 1. Prepare the repo:

````bash
git clone <repo>
cd ecs-restart-orchestration-terraform
````
### 2. Zip the Lambda function:

````bash
cd lambda
zip ecs_restart_lambda.zip ecs_restart_lambda.py
cd ..
````

### 3. Initialize and apply Terraform:

```` bash
terraform init 
terraform plan -var-file="input.tfvars"
terraform apply -var-file="input.tfvars" -auto-approve
````

