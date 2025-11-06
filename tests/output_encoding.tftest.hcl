# Test gzip encoding enabled (requires base64 to also be enabled)
run "gzip_enabled" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
    gzip_config                      = true
    base64_encode_config             = true
  }

  assert {
    condition     = output.cloudinit_config.rendered != null
    error_message = "cloudinit_config output should not be null"
  }

  assert {
    condition     = output.cloudinit_config.gzip == true
    error_message = "gzip should be true when gzip_config is enabled"
  }

  assert {
    condition     = output.cloudinit_config.base64_encode == true
    error_message = "base64_encode must be true when gzip is enabled"
  }
}

# Test gzip encoding disabled (default)
run "gzip_disabled" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
    gzip_config                      = false
  }

  assert {
    condition     = output.cloudinit_config.gzip == false
    error_message = "gzip should be false when gzip_config is disabled"
  }
}

# Test base64 encoding enabled
run "base64_enabled" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
    base64_encode_config             = true
  }

  assert {
    condition     = output.cloudinit_config.base64_encode == true
    error_message = "base64_encode should be true when base64_encode_config is enabled"
  }
}

# Test base64 encoding disabled (default)
run "base64_disabled" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
    base64_encode_config             = false
  }

  assert {
    condition     = output.cloudinit_config.base64_encode == false
    error_message = "base64_encode should be false when base64_encode_config is disabled"
  }
}

# Test both encodings enabled
run "both_encodings_enabled" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
    gzip_config                      = true
    base64_encode_config             = true
  }

  assert {
    condition     = output.cloudinit_config.gzip == true
    error_message = "gzip should be true when gzip_config is enabled"
  }

  assert {
    condition     = output.cloudinit_config.base64_encode == true
    error_message = "base64_encode should be true when base64_encode_config is enabled"
  }

  assert {
    condition     = output.cloudinit_config.rendered != null
    error_message = "cloudinit_config rendered output should not be null"
  }
}
