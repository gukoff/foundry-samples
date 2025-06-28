@description('Azure region for the deployment')
param location string

param vnetId string
param dnsSubnetId string

param dnsIpAddress string
param dnsResolverName string


resource clientDnsResolver 'Microsoft.Network/dnsResolvers@2023-07-01-preview' = {
  properties: {
    virtualNetwork: {
      id: vnetId
    }
  }
  location: location
  name: dnsResolverName
}

resource inboundEndpoint 'Microsoft.Network/dnsResolvers/inboundEndpoints@2023-07-01-preview' = {
  properties: {
    ipConfigurations: [
      {
        subnet: {
          id: dnsSubnetId
        }
        privateIpAllocationMethod: 'Static'
        privateIpAddress: dnsIpAddress
      }
    ]
  }
  location: location
  parent: clientDnsResolver
  name: 'inbound-endpoint-1'
}
