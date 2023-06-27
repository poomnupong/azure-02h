// management resource group

param PREFIX string = 'z'
// param BRANCH string
param REGION string = resourceGroup().location
param APPNAME string = 'mgmt1'

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
        name: '${PREFIX}-${REGION}-1-snet'
        properties: {
          addressPrefix: '10.1.0.0/27'
        }
      }
      {
        name: '${PREFIX}-${REGION}-2-snet'
        properties: {
          addressPrefix: '10.1.0.32/27'
        }
      }
    ]
  }
}
