#!/bin/bash

function validation_message() {
	echo -e "Arguments Requeried!\nEx: deploy_function.sh <functionAppName>"
	exit 1
}

function validation() {
  local FUNCTION_APP_NAME=$1

  if [ $# -lt 1 ]; then
		validation_message
		return 1
	fi
	return 0
}

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

function deploy() {
  local functionAppName=$1
  func azure functionapp publish $functionAppName

  if [ $? != 0 ]; then
    return 1
  fi

  return 0
}

# main
FUNCTION_APP_NAME=$1

# Validation Input
validation $FUNCTION_APP_NAME
if [ $? != 0 ]; then
	validate_deploy_process 1 "End"
	exit 1
fi

echo -e "Deploying Function $FUNCTION_APP_NAME...\n"
deploy $FUNCTION_APP_NAME
if [ $? != 0 ]; then
		validate_deploy_process 1 "Fail to Deploy Function $FUNCTION_APP_NAME."
		exit 1
else
  echo -e "\nSuccess to Deploy Function $FUNCTION_APP_NAME.\n"
fi