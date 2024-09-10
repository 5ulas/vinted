# Create Keyvault manually to avoid any leaks, storage automatically

RESOURCE_GROUP_NAME="vinted-rg"
STORAGE_ACCOUNT_NAME="vintedstoragetfstate"
CONTAINER_NAME="tfstate"

az group create --name $RESOURCE_GROUP_NAME --location northeurope

az storage account create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $STORAGE_ACCOUNT_NAME \
  --sku Standard_LRS \
  --encryption-services blob

az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_ACCOUNT_NAME
