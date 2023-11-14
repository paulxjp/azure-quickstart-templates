// Creates an Azure AI resource with proxied endpoints for the Azure AI services provider

@description('Azure region of the deployment')
param location string

@description('Tags to add to the resources')
param tags object

@description('AI resource name')
param aiResourceName string

@description('AI resource display name')
param aiResourceFriendlyName string = aiResourceName

@description('AI resource description')
param aiResourceDescription string

@description('Resource ID of the application insights resource for storing diagnostics logs')
param applicationInsightsId string

@description('Resource ID of the container registry resource for storing docker images')
param containerRegistryId string

@description('Resource ID of the key vault resource for storing connection strings')
param keyVaultId string

@description('Resource ID of the storage account resource for storing experimentation outputs')
param storageAccountId string

@description('Indicates whether or not the Azure AI services provider is of type AIServices or Azure OpenAI.')
@allowed(['AIServices', 'OpenAI'])
param endpointKind string = 'AIServices'

param endpointResourceId string = 'null'
 
resource aiResource 'Microsoft.MachineLearningServices/workspaces@2023-08-01-preview' = {
  name: aiResourceName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    // workspace organization
    friendlyName: aiResourceFriendlyName
    description: aiResourceDescription

    // dependent resources
    keyVault: keyVaultId
    storageAccount: storageAccountId
    applicationInsights: applicationInsightsId
    containerRegistry: containerRegistryId
  }
  kind: 'hub'
  
  resource azureOpenAIEndpoint 'endpoints@2023-08-01-preview' = {
      name: 'Azure.OpenAI'
      properties: {
        name: 'Azure.OpenAI'
        endpointType: 'Azure.OpenAI'
        associatedResourceId: endpointResourceId != 'null' ? endpointResourceId : null
      }
  }
  
  resource contentSafetyEndpoint 'endpoints@2023-08-01-preview' = {
      name: 'Azure.ContentSafety'
      properties: {
        name: 'Azure.ContentSafety'
        endpointType: 'Azure.ContentSafety'
        associatedResourceId: endpointResourceId != 'null' ? endpointResourceId : null
      }
  }
  
  resource speechEndpoint 'endpoints@2023-08-01-preview' = {
      name: 'Azure.Speech'
      properties: {
        name: 'Azure.Speech'
        endpointType: 'Azure.Speech'
        associatedResourceId: endpointResourceId != 'null' ? endpointResourceId : null
      }
  }
}

output aiResourceID string = aiResource.id
