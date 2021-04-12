#!/bin/bash

function validate_deploy_process() {
	local EXIT_CODE=$1
	local MSG=2

  if [ $EXIT_CODE == 0 ]; then
		echo -e "\n$MSG!\n"
		return 0
	else
		echo -e "\n$MSG!\n"
		return 1
	fi
}

function validation_message() {
	echo -e "Arguments Requeried!\nEx: create_fuction.sh <resourceGroup> <storageName> <planName> <region>"
	exit 1
}


function validate_storage_account() {
  local STORAGE_NAME=$1
  local RESOURCE_GROUP=$2

  local RESP=$(az storage account show --resource-group $RESOURCE_GROUP --name $STORAGE_NAME)
  #not found
  if [ $? != 0 ]; then
    return 1
  fi
  return 0
}

function validation() {
  local RESOURCE_GROUP=$1
  local STORAGE_NAME=$2
  local PREMIUM_PLAN_NAME=$3
  local REGION=$4

  if [ $# -lt 4 ]; then
		validation_message
		return 1
	else
		if [ -n $STORAGE_NAME ]; then
      validate_storage_account $STORAGE_NAME $RESOURCE_GROUP
      if [ $? != 0 ]; then
        	echo -e "Storage Name $STORAGE_NAME Not Found\n"
          return 1
      fi
		fi
	fi
	return 0
}

function create_functionapp() {
  local resourceGroup=$1
  local storageName=$2
  local premiumPlanName=$3
  local functionAppName='MyFunction198274'

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
RESOURCE_GROUP=$1
STORAGE_NAME=$2
PREMIUM_PLAN_NAME=$3
REGION=$4

# Validation Input
validation $RESOURCE_GROUP $STORAGE_NAME  $PREMIUM_PLAN_NAME $REGION
if [ $? != 0 ]; then
	validate_deploy_process 1 "End"
	exit 1
fi

echo -e "Creating Function $FUNCTION_APP_NAME...\n"
create_functionapp $RESOURCE_GROUP $STORAGE_NAME $PREMIUM_PLAN_NAME
if [ $? != 0 ]; then
		echo -e "\nFail to Create Function App.\n"
		exit 1
else
  echo -e "\nSuccess to Create Function App.\n"
fi

echo -e "Creating Function $FUNCTION_APP_NAME...\n"
create_functionapp $RESOURCE_GROUP $STORAGE_NAME $PREMIUM_PLAN_NAME
if [ $? != 0 ]; then
		validate_deploy_process 1 "Fail to Create Function App."
		exit 1
else
  echo -e "Success to Create Function App.\n"
fi