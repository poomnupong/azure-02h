// management resource group

param PREFIX string = 'z'
param REGION string = resourceGroup().location
param APPNAME string

// virtual network for management
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: '${PREFIX}-${APPNAME}-${REGION}-vnet'
  location: REGION
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/24'
      ]
    }
    subnets: [
      {
        name: 'general1-snet'
        properties: {
          addressPrefix: '10.1.0.0/27'
        }
      }
    ]
  }
}

// storage account
resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: '${PREFIX}${uniqueString(resourceGroup().id, 'abc')}'
  location: REGION
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

// log analytics workspace
resource loganalyticsworkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: '${PREFIX}-${APPNAME}-${REGION}-law'
  location: REGION
  properties: {
    retentionInDays: 30
  }
}

// key vault
resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: '${PREFIX}-${APPNAME}-${REGION}-kv'
  location: REGION
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: '00000000-0000-0000-0000-000000000000'
        permissions: {
          keys: [
            'get'
            'list'
          ]
          secrets: [
            'list'
            'get'
          ]
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
    enableSoftDelete: false
    // softDeleteRetentionInDays: 90
    enablePurgeProtection: true
    enableRbacAuthorization: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
  }
}
