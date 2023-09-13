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

// use parseCidr function to determine if VNETADDRPREFIX is larger than /24

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
    ]
  }
}
