# Test basic sensor configuration without optional features
run "basic_sensor_config" {
  command = plan

  variables {
    fleet_community_string                       = "test-community-string"
    sensor_license                               = "test-license-key"
    sensor_management_interface_name             = "eth0"
    sensor_monitoring_interface_name             = "eth1"
    sensor_health_check_probe_source_ranges_cidr = ["35.191.0.0/16", "130.211.0.0/22"]
    subnetwork_monitoring_cidr                   = "10.0.1.0/24"
    subnetwork_monitoring_gateway                = "10.0.1.1"
  }

  assert {
    condition     = output.cloudinit_config.rendered != null
    error_message = "cloudinit_config output should not be null"
  }

  assert {
    condition     = can(regex("password: test-community-string", output.cloudinit_config.rendered))
    error_message = "Community string should be present in rendered config"
  }

  assert {
    condition     = can(regex("license_key: test-license-key", output.cloudinit_config.rendered))
    error_message = "License should be present in rendered config"
  }

  assert {
    condition     = can(regex("name: eth0", output.cloudinit_config.rendered))
    error_message = "Management interface name should be present in rendered config"
  }

  assert {
    condition     = can(regex("name: eth1", output.cloudinit_config.rendered))
    error_message = "Monitoring interface name should be present in rendered config"
  }
}

# Test minimal configuration without health checks
run "minimal_config_without_health_checks" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
  }

  assert {
    condition     = output.cloudinit_config.rendered != null
    error_message = "cloudinit_config output should not be null"
  }

  assert {
    condition     = can(regex("password: test-community-string", output.cloudinit_config.rendered))
    error_message = "Community string should be present in rendered config"
  }
}

# Test that configuration includes health check when both CIDR and gateway are provided
run "health_check_present_when_configured" {
  command = plan

  variables {
    fleet_community_string                       = "test-community-string"
    sensor_license                               = "test-license-key"
    sensor_management_interface_name             = "eth0"
    sensor_monitoring_interface_name             = "eth1"
    subnetwork_monitoring_cidr                   = "10.0.1.0/24"
    subnetwork_monitoring_gateway                = "10.0.1.1"
    sensor_health_check_probe_source_ranges_cidr = ["35.191.0.0/16"]
  }

  assert {
    condition     = can(regex("health_check:", output.cloudinit_config.rendered))
    error_message = "Health check section should be present when CIDR and gateway are configured"
  }

  assert {
    condition     = can(regex("10.0.1.0/24", output.cloudinit_config.rendered))
    error_message = "Monitoring CIDR should be present in health check config"
  }

  assert {
    condition     = can(regex("10.0.1.1", output.cloudinit_config.rendered))
    error_message = "Monitoring gateway should be present in health check config"
  }
}
