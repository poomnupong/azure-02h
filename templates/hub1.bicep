// hub vnet resource group

param PREFIX string = 'z'
param REGION string = resourceGroup().location
param APPNAME string = 'zapp' // normally derived from bicep file name in reusable workflow

param ISDEPLOYVM1 bool = false

// use hubtype1
module vnet-hub1 '../modules/vnet-hubtype1-mod.bicep' = {
VNETNAME: '${PREFIX}-${APPNAME}-${REGION}-vnet'
VNETADDRESSPREFIX: '10.1.1.0/24'
}

// vnet for hub
// module vnet1 '../modules/vnet-genloop-mod.bicep' = {
//   name: 'vnet1'
//   params: {
//     REGION: REGION
//     VNETNAME: '${PREFIX}-${APPNAME}-${REGION}-vnet'
//     VNETADDRESSSPACE: [
//       '10.1.1.0/24'
//     ]
//     SNETS: [
//       {
//         NAME: 'general1-snet'
//         ADDRESSPREFIX: '10.1.1.0/28'
//         NSGNAME: 'general1-snet-nsg'
//       }
//       {
//         NAME: 'nvaoutside-snet'
//         ADDRESSPREFIX: '10.1.1.32/28'
//         NSGNAME: 'nvaoutside-snet-nsg'
//       }
//       {
//         NAME: 'nvainside-snet'
//         ADDRESSPREFIX: '10.1.1.48/28'
//         NSGNAME: 'nvainside-snet-nsg'
//       }
//       {
//         NAME: 'AzureFirewallSubnet'
//         ADDRESSPREFIX: '10.1.1.128/26'
//         NSGNAME: 'nonsg'
//       }
//       {
//         NAME: 'RouteServerSubnet'
//         ADDRESSPREFIX: '10.1.1.192/27'
//         NSGNAME: 'nonsg'
//       }
//       {
//         NAME: 'GatewaySubnet'
//         ADDRESSPREFIX: '10.1.1.224/27'
//         NSGNAME: 'nonsg'
//       }
//     ]
//   }
// }

// test vm in hub
// module vm1 '../modules/vm-linux-mod.bicep' = if (ISDEPLOYVM1) {
//   name: 'vm1'
//   dependsOn: [ vnet1 ]
//   params: {
//     REGION: REGION
//     // hardcoded index of subnet, not ideal but use this until we have a way to extract subnet ID by name
//     SUBNETID: vnet1.outputs.vnet.properties.subnets[0].id
//     VMNAME: 'test-vm1'
//     VMSIZE: 'Standard_D4s_v3'
//     VMADMINUSERNAME: 'azureuser'
//     VMADMINPASSWORDORKEY: 'P@ssw0rd1234!'
//     VMAUTHTYPE: 'password'
//   }
// }
