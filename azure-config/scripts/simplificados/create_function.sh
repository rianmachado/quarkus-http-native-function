#!/bin/bash

function create_functionapp() {
  local resourceGroup=$1
  local storageName=$2
  local premiumPlanName=$3
  local functionAppName=$4

  az functionapp create \
  --resource-group $resourceGroup \
  --storage-account $storageName \
  --name $functionAppName \
  --plan $premiumPlanName \
  --runtime custom \
  --functions-version 3 \
  --disable-app-insights false \
  --tags channel=ARS cia=BHC cost_center=CC-ARS description="ARS applications" product=ARS sigla=ARS \
  --debug

  if [ $? != 0 ]; then
    return 1
  fi
  return 0
}

# Function app and storage account names must be unique.
RESOURCE_GROUP="XXXXXXXX"
STORAGE_NAME="XXXXXXXXXXXX"
FUNCTION_APP_NAME=#<replace with function name>
PREMIUM_PLAN_NAME="XXXXXXXXXXXX"

echo -e "Creating Function $FUNCTION_APP_NAME...\n"
create_functionapp $RESOURCE_GROUP $STORAGE_NAME $PREMIUM_PLAN_NAME $FUNCTION_APP_NAME
if [ $? != 0 ]; then
		echo -e "\nFail to Create Function App.\n"
		exit 1
else
  echo -e "\nSuccess to Create Function App.\n"
fi