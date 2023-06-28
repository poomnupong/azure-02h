// management resource group

param PREFIX string = 'z'
param REGION string = resourceGroup().location
param APPNAME string = 'zapp'

// virtual network for management
resource vnet1 'Microsoft.Network/virtualNetworks@2022-11-01' = {
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
      {
        name: 'general2-snet'
        properties: {
          addressPrefix: '10.1.0.32/27'
        }
      }
    ]
  }
}

// calling module for creating vnet
module vnet2 '../modules/vnet-genloop-mod.bicep' = {
  name: 'vnet2'
  params: {
    REGION: REGION
    VNETNAME: '${PREFIX}-${APPNAME}-${REGION}-vnet2'
    VNETADDRESSSPACE: [
      '10.1.0.0/24'
    ]
    SNETS: [
      {
        NAME: 'general1-snet'
        ADDRESSPREFIX: '10.1.0.0/27'
        NSGNAME: 'general1-snet-nsg'
      }
      {
        NAME: 'general2-snet'
        ADDRESSPREFIX: '10.1.0.32/27'
        NSGNAME: 'general2-snet-nsg'
      }
      {
        NAME: 'GatewaySubnet'
        ADDRESSPREFIX: '10.1.0.128/27'
        NSGNAME: 'nonsg'
      }
    ]
  }
}

// storage account
resource storageaccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: '${PREFIX}${uniqueString(resourceGroup().id, 'abc')}'
  location: REGION
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          enabled: true
        }
        blob: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
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
  name: '${PREFIX}${uniqueString(resourceGroup().id, 'abc')}'
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
