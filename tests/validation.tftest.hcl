# Test Fleet Manager validation - token without URL should fail
run "fleet_token_without_url_fails" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
    fleet_token                      = "test-token"
    # fleet_url and fleet_server_sslname intentionally omitted
  }

  expect_failures = [
    data.cloudinit_config.config,
  ]
}

# Test Fleet Manager validation - URL without token should fail
run "fleet_url_without_token_fails" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
    fleet_url                        = "https://fleet.example.com:1443/fleet/v1/internal/softsensor/websocket"
    # fleet_token and fleet_server_sslname intentionally omitted
  }

  expect_failures = [
    data.cloudinit_config.config,
  ]
}

# Test Fleet Manager validation - token and URL without SSL name should fail
run "fleet_without_sslname_fails" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
    fleet_token                      = "test-token"
    fleet_url                        = "https://fleet.example.com:1443/fleet/v1/internal/softsensor/websocket"
    # fleet_server_sslname intentionally omitted
  }

  expect_failures = [
    data.cloudinit_config.config,
  ]
}

# Test Fleet Manager validation - SSL name without token and URL should fail
run "fleet_sslname_without_token_url_fails" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
    fleet_server_sslname             = "fleet.example.com"
    # fleet_token and fleet_url intentionally omitted
  }

  expect_failures = [
    data.cloudinit_config.config,
  ]
}

# Test that all three Fleet variables together passes validation
run "fleet_all_three_variables_succeeds" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
    fleet_token                      = "test-token"
    fleet_url                        = "https://fleet.example.com:1443/fleet/v1/internal/softsensor/websocket"
    fleet_server_sslname             = "fleet.example.com"
  }

  assert {
    condition     = output.cloudinit_config.rendered != null
    error_message = "cloudinit_config should be valid when all Fleet variables are provided"
  }
}

# Test that none of the Fleet variables also passes validation
run "fleet_no_variables_succeeds" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
    # All fleet_* variables intentionally omitted (using defaults)
  }

  assert {
    condition     = output.cloudinit_config.rendered != null
    error_message = "cloudinit_config should be valid when no Fleet variables are provided"
  }
}
