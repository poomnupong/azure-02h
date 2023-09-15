// bicep module to create a VNET and subnet with separate NSG for each
// DYNAMIC TEMPLATE

param REGION string = resourceGroup().location

// here are example for parameters
param VNETNAME string = 'VNET1'
param VNETADDRESSSPACE array = [
  '10.127.0.0/16'
]
param SNETS array = [
  {
    NAME: 'SNET1'
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

resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: VNETNAME
  location: REGION
  properties: {
    addressSpace: {
      addressPrefixes: VNETADDRESSSPACE
    }
    subnets: [for SNET in SNETS: {
      name: SNET.NAME
      properties: {
        addressPrefix: SNET.ADDRESSPREFIX
        networkSecurityGroup: SNET.NSGNAME != 'nonsg' ? {
          // this is a hack as resourceId() returns a string with partial full capital letters
          id: toLower(resourceId('Microsoft.Network/networkSecurityGroups', SNET.NSGNAME))
          // 2023.06.28 - problem seems to go away. keeping the fix just in case.
          // id: resourceId('Microsoft.Network/networkSecurityGroups', SNET.NSGNAME)
        } : null
      }
    }]
  }
}

resource nsgs 'Microsoft.Network/networkSecurityGroups@2022-11-01' = [for SNET in SNETS: if (SNET.NSGNAME != 'nonsg') {
  name: SNET.NSGNAME
  location: REGION
  properties: {
    securityRules: [
      // {
      //   name: 'AllowAllInbound'
      //   properties: {
      //     priority: 100
      //     protocol: 'Tcp'
      //     access: 'Allow'
      //     direction: 'Inbound'
      //     sourceAddressPrefix: '*'
      //     sourcePortRange: '*'
      //     destinationAddressPrefix: '*'
      //     destinationPortRange: '*'
      //   }
      // }
    ]
  }
}]

// output vnet object
output vnet object = vnet
