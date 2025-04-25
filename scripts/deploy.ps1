# Define variables for Cosmos DB
$AZURE_COSMOSDB_ENDPOINT = az cosmosdb show --name liked-raptor-cosmosdb-account --resource-group rg-simple-chat --query "documentEndpoint" -o tsv
$AZURE_COSMOS_ENDPOINT = $AZURE_COSMOSDB_ENDPOINT -replace ":443/$", ""
$AZURE_COSMOSDB_KEY = az cosmosdb keys list --name liked-raptor-cosmosdb-account --resource-group rg-simple-chat --query "primaryMasterKey" -o tsv
$AZURE_COSMOSDB_ID_TYPE = az cosmosdb show --name liked-raptor-cosmosdb-account --resource-group rg-simple-chat --query "identity.type" -o tsv

# Determine authentication type
if ($AZURE_COSMOSDB_ID_TYPE -eq "none") {
    Write-Host "No default identity found. Falling back to key-based authentication."
    $AZURE_COSMOS_AUTH_TYPE = "key"
} else {
    Write-Host "Default identity found: $AZURE_COSMOSDB_ID_TYPE"
    $AZURE_COSMOS_AUTH_TYPE = "managed_identity"
}

# Define the .env file path
$ENV_FILE = "./.env"

# Write instructions and variables to the .env file
@"
# FROM VS_CODE PRESS CTRL+SHIFT+P THEN SELECT "Azure App Service: Download Remote Settings"
# SELECT THE SUBSCRIPTION AND THEN THEN APP SERVICE YOU ARE USING
# SELECT THE ".env" FILE
# THIS WILL DOWNLOAD YOUR APP SERVICES SETTINGS TO YOUR ENV FILE
# IF YOU HAVE IT OPEN, CLOSE IT WITHOUT SAVING
# THEN OPEN IT AGAIN, ADD YOUR DETAILS AND SAVE IT, THEN
# FROM VS_CODE PRESS CTRL+SHIFT+P THEN SELECT "Azure App Service: Upload Local Settings"
# SELECT THE ".env" FILE
# SELECT THE SUBSCRIPTION AND THEN THEN APP SERVICE YOU ARE USING
# THIS WILL UPLOAD THE FOLLOWING SETTINGS TO YOU APP SERVICE

# Azure Cosmos DB
AZURE_COSMOS_ENDPOINT="$AZURE_COSMOS_ENDPOINT"
AZURE_COSMOSDB_KEY="$AZURE_COSMOSDB_KEY"
AZURE_COSMOS_AUTHENTICATION_TYPE="$AZURE_COSMOS_AUTH_TYPE"

# Azure Bing Search
BING_SEARCH_ENDPOINT="https://api.bing.microsoft.com/"

# Azure AD Authentication
CLIENT_ID="<your-client-id>"
TENANT_ID="<your-tenant-id>"
AZURE_ENVIRONMENT="public" #public, usgovernment
SECRET_KEY="32-characters" # Example - "YouSh0uldGener8teYour0wnSecr3tKey!", import secrets; print(secrets.token_urlsafe(32))
"@ | Set-Content -Path $ENV_FILE

Write-Host "Environment variables and instructions written to $ENV_FILE"