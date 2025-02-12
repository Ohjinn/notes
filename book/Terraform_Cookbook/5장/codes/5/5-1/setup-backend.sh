#!/bin/bash
az group create --name "rg_tfstate" --location "westeurope"
az storage account create --name "storstatehj" --resource-group "rg_tfstate" --location "westeurope"
az storage container create --account-name "storstatehj" --name "tfbackends"