metadata name = 'API Management Service APIs Policies'
metadata description = 'This module deploys an API Management Service API Policy.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent API. Required if the template is used in a standalone deployment.')
param apiName string

@description('Conditional. The name of the parent (API) operation. Required if the template is used in a standalone deployment.')
param operationName string

@description('Optional. The name of the policy.')
param name string = 'policy'

@description('Optional. Format of the policyContent.')
@allowed([
  'rawxml'
  'rawxml-link'
  'xml'
  'xml-link'
])
param format string = 'xml'

@description('Required. Contents of the Policy as defined by the format.')
param value string

resource service 'Microsoft.ApiManagement/service@2023-05-01-preview' existing = {
  name: apiManagementServiceName

  resource api 'apis' existing = {
    name: apiName

    resource operation 'operations' existing = {
      name: operationName
    }
  }
}

resource policy 'Microsoft.ApiManagement/service/apis/operations/policies@2024-06-01-preview' = {
  name: name
  parent: service::api::operation
  properties: {
    format: format
    value: value
  }
}

@description('The resource ID of the API policy.')
output resourceId string = policy.id

@description('The name of the API policy.')
output name string = policy.name

@description('The resource group the API policy was deployed into.')
output resourceGroupName string = resourceGroup().name
