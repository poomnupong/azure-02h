// bicep module to create an empty NSG for every subnet in a given VNET.
// takes the SUBNETS as a parameter.

param SUBNETS array

resource nsgs 'Microsoft.Network/networkSecurityGroups@2022-11-01' = [for subnet in SUBNETS: {
  name: '${subnet.name}-nsg'
  location: subnet.location
  properties: {
    securityRules: []
  }
}]
