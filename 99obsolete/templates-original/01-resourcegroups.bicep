// deploy all necessary resource groups

targetScope = 'subscription'

param PREFIX string = 'dummy'
param BRANCH string
param REGION string = 'southcentralus'
var REGION_SUFFIX = REGION == 'southcentralus' ? 'scus' : REGION

// specify all resource group names here in array so we can loop through them a
var RG_ARRAY = [
  // '${PREFIX}-${BRANCH}-mgmt1-${REGION_SUFFIX}-rg'
  // '${PREFIX}-${BRANCH}-onpremsim1-${REGION_SUFFIX}-rg'
  // '${PREFIX}-${BRANCH}-labconsole1-${REGION_SUFFIX}-rg'
  '${PREFIX}-${BRANCH}-hub1-${REGION_SUFFIX}-rg'
  // '${PREFIX}-${BRANCH}-lz1-${REGION_SUFFIX}-rg'
  // '${PREFIX}-${BRANCH}-lz2-${REGION_SUFFIX}-rg'
  // '${PREFIX}-${BRANCH}-lz3-${REGION_SUFFIX}-rg'
]

// create all resource groups through loop
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = [for RG_NAME in RG_ARRAY: {
  name: RG_NAME
  location: REGION
  tags:{
    branch: BRANCH  
  }
}]
