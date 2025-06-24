@description('Azure region for the deployment')
param location string

@description('The name of the virtual network')
param vnetName string = 'agents-vnet-test-clients'

@description('The name of Agents Subnet')
param vpnSubnetName string = 'vpn-subnet'

@description('The name of Hub subnet')
param dnsSubnetName string = 'dns-subnet'



@description('Generated from /subscriptions/0ba8e327-2264-402b-b5f6-602f1fd2b1da/resourceGroups/rg-agents-private-standard-ip172/providers/Microsoft.Network/dnsResolvers/kgukov-dns-resolver')
resource kgukovdnsresolver 'Microsoft.Network/dnsResolvers@2023-07-01-preview' = {
  properties: {
    virtualNetwork: {
      id: '/subscriptions/0ba8e327-2264-402b-b5f6-602f1fd2b1da/resourceGroups/rg-agents-private-standard-ip172/providers/Microsoft.Network/virtualNetworks/agents-vnet-test'
    }
  }
  location: 'swedencentral'
  name: 'kgukov-dns-resolver'
}




@description('Generated from /subscriptions/0ba8e327-2264-402b-b5f6-602f1fd2b1da/resourceGroups/rg-agents-private-standard-ip172/providers/Microsoft.Network/publicIPAddresses/ip-vpn-ip172')
resource ipvpnip 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: 'ip-vpn-ip172'
  location: 'swedencentral'
  zones: [
    '1'
    '2'
    '3'
  ]
  properties: {
    ipAddress: '74.241.211.221'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
}
@description('Generated from /subscriptions/0ba8e327-2264-402b-b5f6-602f1fd2b1da/resourceGroups/rg-agents-private-standard-ip172/providers/Microsoft.Network/virtualNetworkGateways/vpn-agents172')
resource vpnagents 'Microsoft.Network/virtualNetworkGateways@2024-07-01' = {
  name: 'vpn-agents172'
  location: 'swedencentral'
  tags: {}
  properties: {
    packetCaptureDiagnosticState: 'None'
    enablePrivateIpAddress: false
    isMigrateToCSES: false
    isMigratedLegacySKU: false
    blockUpgradeOfMigratedLegacyGateways: false
    virtualNetworkGatewayMigrationStatus: {
      state: 'None'
      phase: 'None'
      errorMessage: ''
    }
    ipConfigurations: [
      {
        name: 'default'
        id: '/subscriptions/0ba8e327-2264-402b-b5f6-602f1fd2b1da/resourceGroups/rg-agents-private-standard-ip172/providers/Microsoft.Network/virtualNetworkGateways/vpn-agents172/ipConfigurations/default'
        type: 'Microsoft.Network/virtualNetworkGateways/ipConfigurations'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: '/subscriptions/0ba8e327-2264-402b-b5f6-602f1fd2b1da/resourceGroups/rg-agents-private-standard-ip172/providers/Microsoft.Network/publicIPAddresses/ip-vpn-ip172'
          }
          subnet: {
            id: '/subscriptions/0ba8e327-2264-402b-b5f6-602f1fd2b1da/resourceGroups/rg-agents-private-standard-ip172/providers/Microsoft.Network/virtualNetworks/agents-vnet-test/subnets/GatewaySubnet'
          }
        }
      }
    ]
    natRules: []
    virtualNetworkGatewayPolicyGroups: []
    enableBgpRouteTranslationForNat: false
    disableIPSecReplayProtection: false
    sku: {
      name: 'VpnGw1AZ'
      tier: 'VpnGw1AZ'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    enableHighBandwidthVpnGateway: false
    activeActive: false
    bgpSettings: {
      asn: 65515
      bgpPeeringAddress: '172.16.3.254'
      peerWeight: 0
      bgpPeeringAddresses: [
        {
          ipconfigurationId: '/subscriptions/0ba8e327-2264-402b-b5f6-602f1fd2b1da/resourceGroups/rg-agents-private-standard-ip172/providers/Microsoft.Network/virtualNetworkGateways/vpn-agents172/ipConfigurations/default'
          customBgpIpAddresses: []
        }
      ]
    }
    zones: 'ZoneRedundant'
    vpnGatewayGeneration: 'Generation1'
    allowRemoteVnetTraffic: false
    allowVirtualWanTraffic: false
  }
}
