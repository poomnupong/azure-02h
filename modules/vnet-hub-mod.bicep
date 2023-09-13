// generic vnet template
// featuring automated subnetting depends on enabled services
// require minimum subnet size of /24
// parameters:
//   basic: VNETNAME, VNETADDRPREFIX, LOCATION
//   services: ISDEPLOYGATEWAYVPN or _EXR, ISDEPLOYFIREWALL
//   arbitrary subnets: SNETNAME, SNETADDRPREFIX

// parameter
param VNETNAME string = 'tmp-testdefault-vnet'
param VNETADDRPREFIX string = '10.255.255.0/24'
param LOCATION string = 'southcentralus'
param ISDEPLOYGATEWAYVPN bool = false
param ISDEPLOYGATEWAYEXR bool = false
param ISDEPLOYGATEWAYBOOL bool = false
param ISDEPLOYAZFW bool = false

param SNETS array = [
  {
    NAME: 'general1-snet'
    ADDRESSPREFIX: '10.127.1.0/24'
    NSGNAME: 'SNET1-nsg'
  }
  {
    NAME: 'SNET2'
    ADDRESSPREFIX: '10.127.2.0/24'
    NSGNAME: 'SNET2-nsg'
  }
  {
    NAME: 'SNET3'
    ADDRESSPREFIX: '10.127.3.0/24'
    NSGNAME: 'nonsg' // use 'nonsg' because null fails
  }
]

// vnet
resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: VNETNAME
  location: LOCATION
  properties: {
    addressSpace: {
      addressPrefixes: [
        VNETADDRPREFIX
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: cidrSubnet(VNETADDRPREFIX, 27, 7)
        }
    ]
  }
}
