// vnet template for generic hub
// DECLARATIVE TEMPLATE
// subnetted to support both NVA and Azure Firewall
// featuring automated subnetting depends on enabled services
// require minimum subnet size of /24
// parameters:
//   basic: VNETNAME, VNETADDRPREFIX, LOCATION
//   services: ISDEPLOYGATEWAYVPN or _EXR, ISDEPLOYFIREWALL
//   arbitrary subnets: SNETNAME, SNETADDRPREFIX

// parameters
param REGION string = resourceGroup().location

param VNETNAME string = 'tmp-testdefault-vnet'
param VNETADDRPREFIX string = '10.255.255.0/24'
param ISDEPLOYGATEWAYVPN bool = false
param ISDEPLOYGATEWAYEXR bool = false
param ISDEPLOYGATEWAYBOOL bool = false
param ISDEPLOYAZFW bool = false

// vnet for hub
module vnet1 './vnet-genloop-mod.bicep' = {
  name: 'vnet1'
  params: {
    REGION: REGION
    VNETNAME: VNETNAME
    VNETADDRESSSPACE: [
      VNETADDRPREFIX
    ]
    SNETS: [
      {
        NAME: 'general1-snet'
        ADDRESSPREFIX: cidrSubnet(VNETADDRPREFIX, 28, 0)
        NSGNAME: 'general1-snet-nsg'
      }
      {
        NAME: 'nvamgmt-snet'
        ADDRESSPREFIX: cidrSubnet(VNETADDRPREFIX, 28, 1)
        NSGNAME: 'nvamgmt-snet-nsg'
      }
      {
        NAME: 'nvaoutside-snet'
        ADDRESSPREFIX: cidrSubnet(VNETADDRPREFIX, 28, 2)
        NSGNAME: 'nvaoutside-snet-nsg'
      }
      {
        NAME: 'nvainside-snet'
        ADDRESSPREFIX: cidrSubnet(VNETADDRPREFIX, 28, 3)
        NSGNAME: 'nvainside-snet-nsg'
      }
      {
        NAME: 'AzureFirewallSubnet'
        ADDRESSPREFIX: cidrSubnet(VNETADDRPREFIX, 26, 2)
        NSGNAME: 'nonsg'
      }
      {
        NAME: 'RouteServerSubnet'
        ADDRESSPREFIX: cidrSubnet(VNETADDRPREFIX, 27, 6)
        NSGNAME: 'nonsg'
      }
      {
        NAME: 'GatewaySubnet'
        ADDRESSPREFIX: cidrSubnet(VNETADDRPREFIX, 27, 7)
        NSGNAME: 'nonsg'
      }
    ]
  }
}

// vnet
// resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
//   name: VNETNAME
//   location: LOCATION
//   properties: {
//     addressSpace: {
//       addressPrefixes: [
//         VNETADDRPREFIX
//       ]
//     }
//     subnets: [
//       {
//         name: 'GatewaySubnet'
//         properties: {
//           addressPrefix: cidrSubnet(VNETADDRPREFIX, 27, 7)
//         }
//       }
//     ]
//   }
// }
