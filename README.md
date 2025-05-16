# SimpleChat ARM Template

This repository contains an Azure Resource Manager (ARM) template to deploy the resources required for the SimpleChat application. The template provisions the following resources:

- **App Service**: Hosts the Python Flask web application.
- **Azure OpenAI**: Powers core chat functionality and optional metadata extraction.
- **Azure AI Search**: Stores and indexes document chunks for retrieval-augmented generation (RAG).
- **Cosmos DB**: Stores metadata, conversations, and settings.
- **Document Intelligence**: Extracts text and layout from various file types.
- **Content Safety**: (Optional) Moderates content for safety.
- **Storage Account**: (Optional) Stores processed files.

## Deployment

Click the button below to deploy the resources to your Azure subscription:

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https://raw.githubusercontent.com/btshowers/deploy-simplechat/refs/heads/main/simpleChatARM.json)

## Parameters

The following parameters are available for customization during deployment:

- **cosmosDbLocation**: The location/region for the CosmosDB account. Choose from:
  - `Central US`
  - `East US 2` (default)
  - `West US 2`

## Outputs

After deployment, the following output will be available:

- **App Service URL**: The URL of the deployed web application (e.g., `https://<app-name>.azurewebsites.net`).

## Prerequisites

- An active Azure subscription.
- Permissions to create resources in the selected Azure region.

## Notes

- Ensure that the selected region supports all required services.
- Monitor your Azure costs closely, as some services (e.g., Azure OpenAI, Cosmos DB) are billed based on usage.

## Contributing

Feel free to submit issues or pull requests to improve this template.

## License

This project is licensed under the [MIT License](LICENSE).