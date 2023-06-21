// bicep module - generic linux VM with single NIC and an NSG

param SUBNET string
param VMNAME string
param VM_SIZE string
param VM_IMAGE string
param VM_ADMIN_USERNAME string
@secure()
param VM_ADMIN_PASSWORD string
