#!/bin/bash

function validate_deploy_process() {
	local EXIT_CODE=$1
	local MSG=2

  if [ $EXIT_CODE == 0 ]; then
		echo -e "\n--- $MSG!\n"
		return 0
	else
		echo -e "\n--- $MSG!\n"
		return 1
	fi
}

function validation_message() {
	echo -e "Arguments Requeried!\nEx: create_all_resources.sh <resourceGroup> <storageName> <functionAppName> <region>"
	exit 1
}

function validate_storage_name() {
  local local STORAGE_NAME=$1
  local RESP=$(az storage account check-name --name $STORAGE_NAME --query nameAvailable)
  if [ $RESP != true ]; then
    return 1
  fi
  return 0
}

function validation() {
  local RESOURCE_GROUP=$1
  local STORAGE_NAME=$2
  local FUNCTION_APP_NAME=$3
  local REGION=$4

  if [ $# -lt 4 ]; then
		validation_message
		return 1
	else
		if [ -n $STORAGE_NAME ]; then
      validate_storage_name $STORAGE_NAME
      if [ $? != 0 ]; then
        	echo -e "Storage Name $STORAGE_NAME Not Available\n"
          return 1
      fi
		fi
	fi
	return 0
}

function create_resource_group() {
  local resourceGroup=$1
  local region=$2

  az group create \
  --name $resourceGroup \
  --location $region

  if [ $? != 0 ]; then
    return 1
  fi

  return 0
}

function create_storage_account() {
  local resourceGroup=$1
  local region=$2
  local storageName=$3

  az storage account create \
  --name $storageName \
  --location $region \
  --resource-group $resourceGroup \
  --sku Standard_LRS

  if [ $? != 0 ]; then
    return 1
  fi

  return 0
}

function create_functionapp() {
  local resourceGroup=$1
  local storageName=$2
  local region=$3
  local functionAppName=$4

  az functionapp create \
  --resource-group $resourceGroup \
  --storage-account $storageName \
  --name $functionAppName \
  --consumption-plan-location $region \
  --runtime custom \
  --os-type Linux \
  --functions-version 3 \
  --disable-app-insights false

  if [ $? != 0 ]; then
    return 1
  fi
  return 0
}

# main
RESOURCE_GROUP=$1
STORAGE_NAME=$2
FUNCTION_APP_NAME=$3
REGION=$4

# Validation Input
validation $RESOURCE_GROUP $STORAGE_NAME $FUNCTION_APP_NAME $REGION
if [ $? != 0 ]; then
	exit 1
fi

echo -e "Creating Resource Group $RESOURCE_GROUP...\n"
create_resource_group $RESOURCE_GROUP $REGION
if [ $? != 0 ]; then
		validate_deploy_process 1 "Fail to Create Resource Group."
		exit 1
else
  echo -e "Success to Create Resource Group.\n"
fi

echo -e "Creating Storage Account $STORAGE_NAME...\n"
create_storage_account $RESOURCE_GROUP $REGION $STORAGE_NAME
if [ $? != 0 ]; then
		validate_deploy_process 1 "Fail to Create Storage Account."
		exit 1
else
  echo -e "Success to Create Storage Account.\n"
fi

echo -e "Creating Function App $FUNCTION_APP_NAME...\n"
create_functionapp $RESOURCE_GROUP $STORAGE_NAME $REGION $FUNCTION_APP_NAME
if [ $? != 0 ]; then
		validate_deploy_process 1 "Fail to Create Function App."
		exit 1
else
  echo -e "Success to Create Function App.\n"
fi


# func azure functionapp publish $functionAppName