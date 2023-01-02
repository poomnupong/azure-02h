# Azre Lab 1 - infrastructure, hub and spoke

A lab for Azure infrastructure featuring:
- management resource groups for Log Analytics Workspace, Keyvault, and general storage account
- generic hub capable of VPN/ER gateways, Azure Firewall, Bastion and Route Servers
- spokes with a VM to test connectivity

Design principles:
- one master bicep, calling each module
- create resource groups inside each module - so destroy can be easy
  - resource group naming: {}
- conditional deployment swtiches for resources in modules

Naming strategy for resource group:
{PREFIX}-{BRANCH}-{REGION_SUFFIX}-rg
- PREFIX: arbitrary 4-digit prefix for the project
- BRANCH: git branch name, automatically etracted
- REGION_SUFFIC: region most of the time, shorten if needed

Branching strategy:
- main: release/current code
- deploy on {prod, test*, dev*}

Modules:
- mgmt-generic
- hub-generic
- spoke-generic