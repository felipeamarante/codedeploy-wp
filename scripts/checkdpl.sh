#!/bin/bash

#Tests if all dependencies are met
for CMD in aws jq ; do
  type ${CMD} &> /dev/null || { echo "[Error] - This script uses the command: [ ${CMD} ] please install it"; exit 1; }
done


#If you wish to filter by application, you can use --application-name (string) below#
DEPLOYMENTS=$(aws deploy list-deployments --include-only-statuses InProgress --output text --query 'deployments')


if [ ! -z "${DEPLOYMENTS}" ]; then


aws deploy batch-get-deployments --deployment-ids ${DEPLOYMENTS} | jq '.deploymentsInfo[] | "DeploymentID:"+  .deploymentId + " AppName:"+ .applicationName + " Status:" + .status'

else

  echo "No InProgress deployments were found"
  echo "Ending Script"
  exit 1

fi
