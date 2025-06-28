@description('Azure region for the deployment')
param location string

@description('The name of the virtual network')
param vnetName string = 'agents-vnet-test-clients'

@description('The name of Hub subnet')
param peSubnetName string = 'pe-subnet'

@description('The name of Hub subnet')
param dnsSubnetName string = 'dns-subnet'

var dnsIpAddress = '10.1.3.4'  // Static IP for DNS resolver inbound endpoint. Must be within the DNS subnet range.

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  properties: {
    dhcpOptions: {
        dnsServers: [
            dnsIpAddress
        ]
    }
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

  dependsOn: [
    dnsSubnet // Ensure DNS subnet is created before VPN subnet
  ]
}

resource peSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: virtualNetwork
  name: peSubnetName
  properties: {
    addressPrefix: '10.1.1.0/24'
  }

  dependsOn: [
    vpnSubnet // Ensure VPN subnet is created before PE subnet
  ]
}


// Output variables
output peSubnetName string = peSubnetName

output virtualNetworkName string = virtualNetwork.name

output virtualNetworkId string = virtualNetwork.id

output dnsSubnetId string = dnsSubnet.id

output vpnSubnetId string = vpnSubnet.id

output virtualNetworkResourceGroup string = resourceGroup().name

output virtualNetworkSubscriptionId string = subscription().subscriptionId

output dnsIpAddress string = dnsIpAddress
