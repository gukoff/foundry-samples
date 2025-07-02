@description('Azure region for the deployment')
param location string = resourceGroup().location

param vpnSubnetId string

param vpnPublicIpName string
param vpnGatewayName string


resource publicIpVpn 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: vpnPublicIpName
  location: location
  zones: [
    '1'
    '2'
    '3'
  ]
  properties: {
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

resource vpn 'Microsoft.Network/virtualNetworkGateways@2024-07-01' = {
  name: vpnGatewayName
  location: location
  properties: {
    enablePrivateIpAddress: true
    ipConfigurations: [
      {
        name: 'default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpVpn.id
          }
          subnet: {
            id: vpnSubnetId
          }
        }
      }
    ]
    vpnClientConfiguration: {
      vpnClientAddressPool: {
        addressPrefixes: [
          '172.16.201.0/24'
        ]
      }
      vpnClientProtocols: [
        'OpenVPN'
      ]
      vpnAuthenticationTypes: [
        'AAD'
      ]
      aadTenant: '${environment().authentication.loginEndpoint}/${subscription().tenantId}/'
      aadAudience: 'c632b3df-fb67-4d84-bdcf-b95ad541b5c8'  //  Azure VPN Client
      aadIssuer: 'https://sts.windows.net/${subscription().tenantId}/'
    }
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
    vpnGatewayGeneration: 'Generation1'
    allowRemoteVnetTraffic: false
    allowVirtualWanTraffic: false
  }
}
