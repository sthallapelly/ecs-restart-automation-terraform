import boto3
import json
import logging
from typing import Any, Dict

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)


ecs_client = boto3.client('ecs')

def lambda_handler(event: Dict[str, Any], context: Any) -> Dict[str, Any]:

    logger.info("Received event: %s", json.dumps(event))

    services = event.get("services", [])
    if not services:
        logger.warning("No services provided in input.")
        return {
            "statusCode": 400,
            "body": json.dumps({ "error": "No services provided in the input." })
        }

    results = []

    for item in services:
        cluster = item.get("cluster")
        service = item.get("service")

        if not cluster or not service:
            logger.warning("Skipping invalid entry (missing cluster/service): %s", item)
            results.append({ "status": "skipped", "reason": "missing cluster or service", "item": item })
            continue

        try:
            response = ecs_client.update_service(
                cluster=cluster,
                service=service,
                forceNewDeployment=True
            )
            logger.info("Successfully restarted service: %s in cluster: %s", service, cluster)
            results.append({ "service": service, "cluster": cluster, "status": "success" })
        except ClientError as e:
            logger.error("AWS ClientError on %s/%s: %s", cluster, service, e)
            results.append({
                "service": service,
                "cluster": cluster,
                "status": "failed",
                "error": str(e.response['Error']['Message'])
            })
        except Exception as e:
            logger.error("General exception on %s/%s: %s", cluster, service, e)
            results.append({
                "service": service,
                "cluster": cluster,
                "status": "failed",
                "error": str(e)
            })

    return {
        "statusCode": 200,
        "body": json.dumps(results)
    }
