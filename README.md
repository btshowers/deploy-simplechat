# SimpleChat ARM Template Deployment

This repository contains an Azure Resource Manager (ARM) template to deploy the complete infrastructure required for the SimpleChat application. The template provisions all necessary Azure services with optimal configurations for development, demo, POC, or MVP scenarios.

## Resources Deployed

The ARM template creates the following Azure resources:

### Core Application Infrastructure
- **App Service Plan**: Premium V3 (P0v3) Linux plan - 1 Core, 4 GB RAM, 250 GB Storage
- **App Service**: Python 3.12 web application hosting with Linux runtime

### AI and Cognitive Services
- **Azure OpenAI**: Standard S0 tier for GPT models, embeddings, and image generation
- **Azure AI Search**: Standard tier with 1 replica and 1 partition for document indexing and RAG capabilities
- **Document Intelligence**: Standard S0 tier for text and layout extraction from files
- **Content Safety**: Standard S0 tier for content moderation (optional feature)

### Data Storage
- **Cosmos DB**: NoSQL database with vector search capabilities, provisioned throughput, and public network access
- **Storage Account**: General Purpose V2 with LRS redundancy for file storage

## Quick Deploy

Click the button below to deploy all resources to your Azure subscription:

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https://raw.githubusercontent.com/your-repo-name/your-branch-name/simpleChatARM.json)

## Parameters

### Required Parameters
- **cosmosDbLocation**: Select the region for your Cosmos DB deployment
  - `Central US`
  - `East US 2` (default)
  - `West US 2`

All other resources will be deployed to the same region as your resource group.

## Deployment Outputs

After successful deployment, you'll receive the following outputs:

- **App Service URL**: The web application endpoint (e.g., `https://<random-name>-simplechat-app.azurewebsites.net`)
- **Cosmos DB URI**: The endpoint URL for your Cosmos DB account
- **Cosmos DB Primary Key**: The primary access key for Cosmos DB authentication

## Resource Naming Convention

All resources use a consistent naming pattern with a unique prefix:
- Format: `<uniqueString>-simplechat-<service-type>`
- Example: `abc123def-simplechat-app`, `abc123def-simplechat-cosmosdb`

## Key Features

### Security & Access
- Cosmos DB configured with public network access enabled
- TLS 1.2 minimum encryption
- HTTPS-only traffic for storage accounts

### Performance & Scalability
- Premium V3 App Service plan for optimal performance
- Standard tier AI services for production-ready capabilities
- Vector search enabled in Cosmos DB for RAG scenarios

### Cost Optimization
- Provisioned throughput for Cosmos DB (pay for what you reserve)
- Standard tiers selected for balance of cost and performance
- Free tier disabled on Cosmos DB (insufficient for application needs)

## Prerequisites

- Active Azure subscription
- Resource group creation permissions
- Sufficient quota for Premium App Service plans in selected region
- Azure OpenAI service availability in your chosen region

## Post-Deployment Configuration

After deployment, you'll need to:

1. **Deploy Application Code**: Upload your Python Flask application to the App Service
2. **Configure Authentication**: Set up Azure AD/Entra ID authentication
3. **Deploy AI Models**: Create deployments for required models in Azure OpenAI:
   - GPT model (e.g., gpt-4o)
   - Embedding model (e.g., text-embedding-3-small)
   - Image generation model (e.g., dall-e-3) - optional
4. **Initialize Search Indexes**: Create required indexes in Azure AI Search
5. **Configure Application Settings**: Set environment variables with service endpoints and keys

## Cost Considerations

- **App Service**: Fixed monthly cost based on Premium V3 tier
- **Azure OpenAI**: Pay-per-use for tokens processed
- **Cosmos DB**: Provisioned throughput charges (start ~$58/month for 1000 RU/s)
- **AI Search**: Fixed monthly cost for Standard tier (~$250/month)
- **Other Services**: Pay-per-use for Document Intelligence, Content Safety

**Recommendation**: Monitor costs closely and adjust service tiers based on actual usage patterns.

## Support

For issues with the template or deployment:
1. Check Azure Activity Log for deployment errors
2. Verify service availability in your selected region
3. Ensure sufficient Azure quota for requested resources

## License

This project is licensed under the [MIT License](LICENSE).