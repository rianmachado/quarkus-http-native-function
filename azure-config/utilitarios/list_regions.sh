#!/bin/bash

function list_regions() {
  az account list-locations --query [].name -o table
}

list_regions

# func azure functionapp publish $functionAppName