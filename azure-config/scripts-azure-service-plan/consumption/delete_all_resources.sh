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
	echo -e "Arguments Requeried!\nEx: delete_all_resources.sh <resourceGroup> <storageName> <functionAppName> <region>"
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
  local FUNCTION_APP_NAME=$3
  local REGION=$4

  if [ $# -lt 4 ]; then
		validation_message
		return 1
	else
		if [ -n $STORAGE_NAME ]; then
      validate_storage_account $STORAGE_NAME $RESOURCE_GROUP
      if [ $? != 0 ]; then
        	echo -e "Storage Account $STORAGE_NAME Not Found\n"
          return 1
      fi
		fi
	fi
	return 0
}

function delete_resource_group() {
  local resourceGroup=$1
  local region=$2

  az group delete \
  --name $resourceGroup
  
  if [ $? != 0 ]; then
    return 1
  fi

  return 0
}

function delete_storage_account() {
  local resourceGroup=$1
  local region=$2
  local storageName=$3

  az storage account delete \
  --name $storageName \
  --resource-group $resourceGroup

  if [ $? != 0 ]; then
    return 1
  fi

  return 0
}

function delete_functionapp() {
  local resourceGroup=$1
  local functionAppName=$2

  az functionapp delete \
  --name $functionAppName \
  --resource-group $resourceGroup

  if [ $? != 0 ]; then
    return 1
  fi

  return 0
}

function delete_function_app_insights() {
  local resourceGroup=$1
  local functionAppName=$2
  
  az monitor app-insights component delete \
  --app $functionAppName \
  --resource-group $resourceGroup

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
	validate_deploy_process 1 "End"
	exit 1
fi

echo -e "Deleting Function $FUNCTION_APP_NAME...\n"
delete_functionapp $RESOURCE_GROUP $FUNCTION_APP_NAME
if [ $? != 0 ]; then
		validate_deploy_process 1 "Fail to Create Function App."
		exit 1
fi

echo -e "\nDeleting Function App Insights $FUNCTION_APP_NAME...\n"
delete_function_app_insights $RESOURCE_GROUP $FUNCTION_APP_NAME
if [ $? != 0 ]; then
		validate_deploy_process 1 "Fail to Delete Function App Insights."
		exit 1
else
  echo -e "Success to Delete Function App Insights $FUNCTION_APP_NAME.\n"
fi

echo -e "\nDeleting Storage Account $STORAGE_NAME...\n"
delete_storage_account $RESOURCE_GROUP $REGION $STORAGE_NAME
if [ $? != 0 ]; then
		validate_deploy_process 1 "Fail to Create Storage Account."
		exit 1
else
  echo -e "Success to Delete Storage Account $FUNCTION_APP_NAME.\n"
fi

echo -e "\nDeleting Resource Group $RESOURCE_GROUP...\n"
delete_resource_group $RESOURCE_GROUP $REGION
if [ $? != 0 ]; then
		validate_deploy_process 1 "Fail to Create Resource Group."
		exit 1
else
  echo -e "Success to Delete Resource Group $FUNCTION_APP_NAME.\n"
fi