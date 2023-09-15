// management resource group

param PREFIX string = 'z'
param REGION string = resourceGroup().location
param APPNAME string = 'zapp' // normally derived from bicep file name in reusable workflow

// vnet for management
module vnet1 '../modules/vnet-genloop-mod.bicep' = {
  name: 'vnet1'
  params: {
    REGION: REGION
    VNETNAME: '${PREFIX}-${APPNAME}-${REGION}-vnet'
    VNETADDRESSSPACE: [
      '10.1.0.0/24'
    ]
    SNETS: [
      {
        NAME: 'general1-snet'
        ADDRESSPREFIX: '10.1.0.0/27'
        NSGNAME: 'general1-snet-nsg'
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
// resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
//   name: '${PREFIX}${uniqueString(resourceGroup().id, 'abc')}'
//   location: REGION
//   properties: {
//     enabledForDeployment: true
//     enabledForTemplateDeployment: true
//     enabledForDiskEncryption: true
//     tenantId: subscription().tenantId
//     accessPolicies: [
//       {
//         tenantId: subscription().tenantId
//         objectId: '00000000-0000-0000-0000-000000000000'
//         permissions: {
//           keys: [
//             'get'
//             'list'
//           ]
//           secrets: [
//             'list'
//             'get'
//           ]
//         }
//       }
//     ]
//     sku: {
//       name: 'standard'
//       family: 'A'
//     }
//     enableSoftDelete: false
//     // softDeleteRetentionInDays: 90
//     enablePurgeProtection: true
//     enableRbacAuthorization: true
//     networkAcls: {
//       bypass: 'AzureServices'
//       defaultAction: 'Deny'
//       ipRules: []
//       virtualNetworkRules: []
//     }
//   }
// }
