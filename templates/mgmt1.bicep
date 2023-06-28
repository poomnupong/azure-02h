// management resource group

param PREFIX string = 'z'
param REGION string = resourceGroup().location
param APPNAME string

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

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: '${PREFIX}stg${uniqueString(resourceGroup().id, 'storageAccount')}abc' // Adds the current date in YYYYMMDD format to the storage account name
  location: REGION
  properties: {
    kind: 'StorageV2'
    sku: {
      name: 'Standard_LRS'
    }
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
  }
}
