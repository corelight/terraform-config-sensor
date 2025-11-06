# Test Prometheus feature flag
run "prometheus_enabled" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
    prometheus_enabled               = true
  }

  assert {
    condition     = output.cloudinit_config.rendered != null
    error_message = "cloudinit_config output should not be null"
  }

  assert {
    condition     = can(regex("prometheus:", output.cloudinit_config.rendered))
    error_message = "Prometheus section should be present when enabled"
  }
}

# Test Prometheus disabled (default)
run "prometheus_disabled" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
    prometheus_enabled               = false
  }

  assert {
    condition     = output.cloudinit_config.rendered != null
    error_message = "cloudinit_config output should not be null"
  }

  assert {
    condition     = !can(regex("prometheus:", output.cloudinit_config.rendered))
    error_message = "Prometheus section should not be present when disabled"
  }
}

# Test FedRAMP mode enabled
run "fedramp_enabled" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
    fedramp_mode_enabled             = true
  }

  assert {
    condition     = output.cloudinit_config.rendered != null
    error_message = "cloudinit_config output should not be null"
  }

  assert {
    condition     = can(regex("fedramp_mode:", output.cloudinit_config.rendered))
    error_message = "FedRAMP mode section should be present when enabled"
  }
}

# Test FedRAMP mode disabled (default)
run "fedramp_disabled" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
    fedramp_mode_enabled             = false
  }

  assert {
    condition     = output.cloudinit_config.rendered != null
    error_message = "cloudinit_config output should not be null"
  }

  assert {
    condition     = !can(regex("fedramp_mode:", output.cloudinit_config.rendered))
    error_message = "FedRAMP mode section should not be present when disabled"
  }
}

# Test both features enabled together
run "multiple_features_enabled" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
    prometheus_enabled               = true
    fedramp_mode_enabled             = true
  }

  assert {
    condition     = can(regex("prometheus:", output.cloudinit_config.rendered))
    error_message = "Prometheus section should be present when enabled"
  }

  assert {
    condition     = can(regex("fedramp_mode:", output.cloudinit_config.rendered))
    error_message = "FedRAMP mode section should be present when enabled"
  }
}
