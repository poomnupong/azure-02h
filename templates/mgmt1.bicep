// management resource group

param PREFIX string = 'z'
// param BRANCH string
param REGION string = resourceGroup().location
param APPNAME string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: '${PREFIX}-${APPNAME}-${REGION}-vnet'
  location: REGION
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/24'
      ]
    }
    subnets: [
      {
        name: '${PREFIX}-${APPNAME}-${REGION}-snet1'
        properties: {
          addressPrefix: '10.2.0.0/27'
        }
      }
      {
        name: '${PREFIX}-${APPNAME}-${REGION}-snet2'
        properties: {
          addressPrefix: '10.2.0.32/27'
        }
      }
    ]
  }
}
