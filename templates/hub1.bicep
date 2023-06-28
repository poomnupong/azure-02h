// hub vnet resource group

param PREFIX string = 'z'
param REGION string = resourceGroup().location
param APPNAME string = 'zapp' // normally derived from bicep file name in reusable workflow

// vnet for hub
module vnet1 '../modules/vnet-genloop-mod.bicep' = {
  name: 'vnet1'
  params: {
    REGION: REGION
    VNETNAME: '${PREFIX}-${APPNAME}-${REGION}-vnet'
    VNETADDRESSSPACE: [
      '10.1.1.0/24'
    ]
    SNETS: [
      {
        NAME: 'general1-snet'
        ADDRESSPREFIX: '10.1.1.0/28'
        NSGNAME: 'general1-snet-nsg'
      }
      {
        NAME: 'nvaoutside-snet'
        ADDRESSPREFIX: '10.1.0.32/28'
        NSGNAME: 'nvaoutside-snet-nsg'
      }
      {
        NAME: 'nvainside-snet'
        ADDRESSPREFIX: '10.1.0.48/28'
        NSGNAME: 'nvainside-snet-nsg'
      }
      {
        NAME: 'AzureFirewallSubnet'
        ADDRESSPREFIX: '10.1.0.128/26'
        NSGNAME: 'nonsg'
      }
      {
        NAME: 'RouteServerSubnet'
        ADDRESSPREFIX: '10.1.0.192/27'
        NSGNAME: 'nonsg'
      }
      {
        NAME: 'GatewaySubnet'
        ADDRESSPREFIX: '10.1.0.224/27'
        NSGNAME: 'nonsg'
      }
    ]
  }
}
