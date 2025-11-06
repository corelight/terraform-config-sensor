# Test Fleet Manager pairing configuration
run "fleet_manager_pairing_complete" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"

    # Fleet Manager configuration
    fleet_token          = "b1cd099ff22ed8a41abc63929d1db126"
    fleet_url            = "https://fleet.example.com:1443/fleet/v1/internal/softsensor/websocket"
    fleet_server_sslname = "fleet.example.com"
  }

  assert {
    condition     = output.cloudinit_config.rendered != null
    error_message = "cloudinit_config output should not be null"
  }

  assert {
    condition     = can(regex("token: b1cd099ff22ed8a41abc63929d1db126", output.cloudinit_config.rendered))
    error_message = "Fleet token should be present in rendered config"
  }

  assert {
    condition     = can(regex("url: https://fleet.example.com:1443/fleet/v1/internal/softsensor/websocket", output.cloudinit_config.rendered))
    error_message = "Fleet URL should be present in rendered config"
  }

  assert {
    condition     = can(regex("server_sslname: fleet.example.com", output.cloudinit_config.rendered))
    error_message = "Fleet server SSL name should be present in rendered config"
  }
}

# Test Fleet Manager with proxy configuration
run "fleet_manager_with_proxy" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"

    # Fleet Manager configuration with proxy
    fleet_token          = "test-token"
    fleet_url            = "https://fleet.example.com:1443/fleet/v1/internal/softsensor/websocket"
    fleet_server_sslname = "fleet.example.com"
    fleet_http_proxy     = "http://proxy.example.com:8080"
    fleet_https_proxy    = "https://proxy.example.com:8443"
    fleet_no_proxy       = "localhost,127.0.0.1,.example.com"
  }

  assert {
    condition     = can(regex("http_proxy: http://proxy.example.com:8080", output.cloudinit_config.rendered))
    error_message = "HTTP proxy should be present in rendered config"
  }

  assert {
    condition     = can(regex("https_proxy: https://proxy.example.com:8443", output.cloudinit_config.rendered))
    error_message = "HTTPS proxy should be present in rendered config"
  }

  assert {
    condition     = can(regex("no_proxy: localhost,127.0.0.1,.example.com", output.cloudinit_config.rendered))
    error_message = "No proxy should be present in rendered config"
  }
}

# Test that configuration works without Fleet Manager
run "no_fleet_manager" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
  }

  assert {
    condition     = output.cloudinit_config.rendered != null
    error_message = "cloudinit_config output should not be null without Fleet Manager"
  }

  assert {
    condition     = !can(regex("fleet_token:", output.cloudinit_config.rendered))
    error_message = "Fleet token should not be present when not configured"
  }
}
