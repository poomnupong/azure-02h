// deploy vnet peering between lz1 and hub

targetScope = 'resourceGroup'

param BRANCH string
param PREFIX string
param REGION string = 'southcentralus'
// var RG = 'labconsole'

param VNET1NAME string = 'lz1-${REGION}-vnet-01'
param VNET2NAME string = 'conn1-${REGION}-vnet-01'

resource vnet1 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: VNET1NAME
  // scope: resourceGroup('${PREFIX}-${BRANCH}-lz1-${REGION}-rg')
}

resource vnet2 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: VNET2NAME
  scope: resourceGroup('${PREFIX}-${BRANCH}-conn1-${REGION}-rg')
}

resource peering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-07-01' = {
  name: '${VNET1NAME}-to-${VNET2NAME}'
  parent: vnet1
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: true
    remoteVirtualNetwork: {
      id: vnet2.id
    }
  }
}

