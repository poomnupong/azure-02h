// bicep module - generic linux VM with single NIC and an NSG
// *** still in draft ***

@description('Region to deploy resource to')
param REGION string = resourceGroup().location

@description('ObjectID of the subnet for NIC')
param SUBNETID string
// var VNETID = split(SUBNETID, '/')[9]

param VMNAME string = 'zvm1'
param VMSIZE string = 'Standard_B1s'

@description('Ubuntu version of the VM: Ubuntu-1804, Ubuntu-2004, Ubuntu-2204')
@allowed([
  'Ubuntu-1804'
  'Ubuntu-2004'
  'Ubuntu-2204'
])
param VMUBUNTUVERSION string = 'Ubuntu-2204'
param VMADMINUSERNAME string = 'azureuser'

@description('Password or SSH public key for the VM')
@secure()
param VMADMINPASSWORDORKEY string

@description('Authentication method for the VM: password or sshPublicKey')
@allowed([
  'password'
  'sshPublicKey'
])
param VMAUTHTYPE string = 'password'

@allowed([
  'Standard_LRS'
  'StandardSSD_LRS'
  'Premium_LRS'
])
param VMOSDISKTYPE string = 'Premium_LRS'
// param VM_DATADISK1_SIZE int = 1024

@description('If true, the VM will be deployed to Spot VM')
// param ISSPOTVM bool = false

//===== section - variables =====

var VMIMAGEREF = {
  'Ubuntu-1804': {
    publisher: 'Canonical'
    offer: 'UbuntuServer'
    sku: '18_04-lts-gen2'
    version: 'latest'
  }
  'Ubuntu-2004': {
    publisher: 'Canonical'
    offer: '0001-com-ubuntu-server-focal'
    sku: '20_04-lts-gen2'
    version: 'latest'
  }
  'Ubuntu-2204': {
    publisher: 'Canonical'
    offer: '0001-com-ubuntu-server-jammy'
    sku: '22_04-lts-gen2'
    version: 'latest'
  }
}
var LINUXCONFIGURATION = {
  disablePasswordAuthentication: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${VMADMINUSERNAME}/.ssh/authorized_keys'
        keyData: VMADMINPASSWORDORKEY
      }
    ]
  }
}

// var OS_DATADISK1_NAME = '${VMNAME}-diskdata1'

//===== section - resources =====

// resource for the vm

resource vm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: '${VMNAME}-${REGION}-vm'
  location: REGION
  properties: {
    hardwareProfile: {
      vmSize: VMSIZE
    }
    storageProfile: {
      imageReference: VMIMAGEREF[VMUBUNTUVERSION]
      osDisk: {
        name: '${VMNAME}-diskos'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: VMOSDISKTYPE
        }
      }
    }
    osProfile: {
      computerName: VMNAME
      adminUsername: VMADMINUSERNAME
      adminPassword: VMADMINPASSWORDORKEY
      linuxConfiguration: ((VMAUTHTYPE == 'password') ? null : LINUXCONFIGURATION)
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic1.id
        }
      ]
    }
  }
}

resource nic1 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  name: '${VMNAME}-${REGION}-nic1'
  location: REGION
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: SUBNETID
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg1.id
    }
  }
}

resource nsg1 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: '${VMNAME}-${REGION}-nsg1'
  location: REGION
  properties: {
    securityRules: []
  }
}

resource publicip1 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  name: '${VMNAME}-${REGION}-pip1'
  location: REGION
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
  }
}
