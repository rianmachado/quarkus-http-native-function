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
	echo -e "Arguments Requeried!\nEx: delete_fuction.sh <resourceGroup> <functionAppName> <premiumPlanName>"
	exit 1
}

function validation() {
  local RESOURCE_GROUP=$1
  local FUNCTION_APP_NAME=$2
  local PREMIUM_PLAN_NAME=$3

  if [ $# -lt 3 ]; then
		validation_message
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

function delete_azure_plan() {
  local resourceGroup=$1
  local premiumPlanName=$2

az functionapp plan delete \
--resource-group $resourceGroup \
--name $premiumPlanName \

  if [ $? != 0 ]; then
    return 1
  fi

  return 0
}

# main
RESOURCE_GROUP=$1
FUNCTION_APP_NAME=$2
PREMIUM_PLAN_NAME=$3

# Validation Input
validation $RESOURCE_GROUP $FUNCTION_APP_NAME $PREMIUM_PLAN_NAME
if [ $? != 0 ]; then
	validate_deploy_process 1 "End"
	exit 1
fi

echo -e "Deleting Function $FUNCTION_APP_NAME...\n"
delete_functionapp $RESOURCE_GROUP $FUNCTION_APP_NAME
if [ $? != 0 ]; then
		validate_deploy_process 1 "Fail to Delete Function App."
		exit 1
else
  echo -e "Success to Delete Function App $FUNCTION_APP_NAME.\n\n"
fi

echo -e "\nDeleting Premium Plan $PREMIUM_PLAN_NAME...\n"
delete_azure_plan $RESOURCE_GROUP $REGION $PREMIUM_PLAN_NAME
if [ $? != 0 ]; then
		validate_deploy_process 1 "Fail to Delete Premium Plan Account."
		exit 1
else
  echo -e "Success to Delete Premium Plan Account $PREMIUM_PLAN_NAME.\n\n"
fi

echo -e "\nDeleting Function App Insights $FUNCTION_APP_NAME...\n"
delete_function_app_insights $RESOURCE_GROUP $FUNCTION_APP_NAME
if [ $? != 0 ]; then
		validate_deploy_process 1 "Fail to Delete Function App Insights."
		exit 1
else
  echo -e "Success to Delete Function App Insights $FUNCTION_APP_NAME.\n"
fi


# func azure functionapp publish $functionAppName