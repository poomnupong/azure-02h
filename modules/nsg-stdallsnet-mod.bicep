// bicep module to create an empty NSG for every subnet in a given VNET.
// takes the SUBNETS as a parameter.
// *** still in draff ***

param SUBNETS array
param VNET object

// create an empty NSG for each subnet
resource nsgs 'Microsoft.Network/networkSecurityGroups@2022-11-01' = [for SUBNET in VNET.properties.SUBNETS: {
  name: '${SUBNET.name}-nsg'
  location: SUBNET.location
  properties: {
    securityRules: []
  }
}]
