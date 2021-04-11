#!/bin/bash

function deploy() {
  local functionAppName=$1
  func azure functionapp publish $functionAppName

  if [ $? != 0 ]; then
    return 1
  fi

  return 0
}

# main
FUNCTION_APP_NAME=#<replace with function name>

echo -e "Deploying Function $FUNCTION_APP_NAME...\n"
deploy $FUNCTION_APP_NAME
if [ $? != 0 ]; then
	echo -e "\nFail to Deploy Function $FUNCTION_APP_NAME."
	exit 1
else
  echo -e "\nSuccess to Deploy Function $FUNCTION_APP_NAME.\n"
fi