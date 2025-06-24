/*
Virtual Network Module
This module deploys the core network infrastructure with security controls:

1. Address Space:
   - VNet CIDR: 172.16.0.0/16 OR 192.168.0.0/16
   - Agents Subnet: 172.16.0.0/24 OR 192.168.0.0/24
   - Private Endpoint Subnet: 172.16.101.0/24 OR 192.168.1.0/24

2. Security Features:
   - Network isolation
   - Subnet delegation
   - Private endpoint subnet 
*/

@description('Azure region for the deployment')
param location string

@description('The name of the virtual network')
param vnetName string = 'agents-vnet-test-clients'

@description('The name of Hub subnet')
param peSubnetName string = 'pe-subnet'

@description('The name of Hub subnet')
param dnsSubnetName string = 'dns-subnet'


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
  }
}

resource dnsSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: virtualNetwork
  name: dnsSubnetName
  properties: {
    addressPrefix: '10.1.3.0/24'
    delegations: [
      {
        name: 'Microsoft.Network.dnsResolvers'
        properties: {
          serviceName: 'Microsoft.Network/dnsResolvers'
        }
      }
    ]
  }
}

resource vpnSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: virtualNetwork
  name: 'GatewaySubnet'  // it must be named 'GatewaySubnet'
  properties: {
    addressPrefix: '10.1.2.0/24'
  }
}

resource peSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: virtualNetwork
  name: peSubnetName
  properties: {
    addressPrefix: '10.1.1.0/24'
  }
}


// Output variables
output peSubnetName string = peSubnetName

output virtualNetworkName string = virtualNetwork.name

output virtualNetworkId string = virtualNetwork.id

output dnsSubnetId string = dnsSubnet.id

output vpnSubnetId string = vpnSubnet.id

output virtualNetworkResourceGroup string = resourceGroup().name

output virtualNetworkSubscriptionId string = subscription().subscriptionId
