#!/bin/bash

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
RESOURCE_GROUP="XXXXXXXX"
FUNCTION_APP_NAME=#<replace with function name>

echo -e "Deleting Function $FUNCTION_APP_NAME...\n"
delete_functionapp $RESOURCE_GROUP $FUNCTION_APP_NAME
if [ $? != 0 ]; then
		echo -e "\nFail to Delete Function App.\n"
		exit 1
else
  echo -e "\nSuccess to Delete Function App.\n\n"
fi

echo -e "\nDeleting Function App Insights $FUNCTION_APP_NAME...\n"
delete_function_app_insights $RESOURCE_GROUP $FUNCTION_APP_NAME
if [ $? != 0 ]; then
		echo -e "\nFail to Delete Function App Insights.\n"
		exit 1
else
  echo -e "\nSuccess to Delete Function App Insights.\n"
fi