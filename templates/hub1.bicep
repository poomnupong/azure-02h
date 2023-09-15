// hub vnet resource group

param PREFIX string = 'z'
param REGION string = resourceGroup().location
param APPNAME string = 'zapp' // normally derived from bicep file name in reusable workflow

var ISDEPLOYVM1 = true

// use hubtype1
module vnethub1 '../modules/vnet-hubtype1-mod.bicep' = {
  name: 'vnethub1'
  params: {
    REGION: REGION
    VNETNAME: '${PREFIX}-${APPNAME}-${REGION}-vnet'
    VNETADDRPREFIX: '10.1.1.0/24'
  }
}

// test vm in huba
module vm1 '../modules/vm-linux-mod.bicep' = if (ISDEPLOYVM1) {
  name: 'vm1'
  dependsOn: [ vnethub1 ]
  params: {
    REGION: REGION
    // hardcoded index of subnet, not ideal but use this until we have a way to extract subnet ID by name
    // SUBNETID: vnethub1.outputs.vnet.properties.subnets[0].id
    SUBNETID: resourceId('Microsoft.Network/virtualNetworks/subnets', '${PREFIX}-${APPNAME}-${REGION}-vnet', 'general1-snet')
    VMNAME: 'test-vm1'
    VMSIZE: 'Standard_D4s_v3'
    VMADMINUSERNAME: 'azureuser'
    VMADMINPASSWORDORKEY: 'P@ssw0rd1234!'
    VMAUTHTYPE: 'password'
  }
}
