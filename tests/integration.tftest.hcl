# Integration test with all features enabled
run "full_configuration" {
  command = plan

  variables {
    # Core configuration
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"

    # Health check configuration
    sensor_health_check_http_port                = "41080"
    sensor_health_check_probe_source_ranges_cidr = ["35.191.0.0/16", "130.211.0.0/22"]
    subnetwork_monitoring_cidr                   = "10.0.1.0/24"
    subnetwork_monitoring_gateway                = "10.0.1.1"

    # Fleet Manager configuration
    fleet_token          = "b1cd099ff22ed8a41abc63929d1db126"
    fleet_url            = "https://fleet.example.com:1443/fleet/v1/internal/softsensor/websocket"
    fleet_server_sslname = "fleet.example.com"
    fleet_http_proxy     = "http://proxy.example.com:8080"
    fleet_https_proxy    = "https://proxy.example.com:8443"
    fleet_no_proxy       = "localhost,127.0.0.1"

    # Feature flags
    prometheus_enabled   = true
    fedramp_mode_enabled = true

    # Output encoding
    gzip_config          = true
    base64_encode_config = true
  }

  # Note: Output is gzipped and base64 encoded, so we can't regex match content
  # Content validation is covered by other tests without encoding

  assert {
    condition     = output.cloudinit_config.rendered != null
    error_message = "cloudinit_config output should not be null"
  }

  # Verify output encoding is enabled
  assert {
    condition     = output.cloudinit_config.gzip == true
    error_message = "gzip should be enabled"
  }

  assert {
    condition     = output.cloudinit_config.base64_encode == true
    error_message = "base64_encode should be enabled"
  }

  # Verify rendered output is base64-encoded (starts with expected base64 chars)
  assert {
    condition     = can(regex("^[A-Za-z0-9+/]+=*$", output.cloudinit_config.rendered))
    error_message = "rendered output should be base64 encoded"
  }
}

# Integration test with minimal configuration (only required variables)
run "minimal_configuration" {
  command = plan

  variables {
    fleet_community_string           = "test-community-string"
    sensor_license                   = "test-license-key"
    sensor_management_interface_name = "eth0"
    sensor_monitoring_interface_name = "eth1"
  }

  assert {
    condition     = output.cloudinit_config.rendered != null
    error_message = "cloudinit_config output should not be null with minimal config"
  }

  # Verify core configuration is present
  assert {
    condition     = can(regex("password:", output.cloudinit_config.rendered))
    error_message = "Community string should be present"
  }

  # Verify optional features are not present
  assert {
    condition     = !can(regex("fleet_token:", output.cloudinit_config.rendered))
    error_message = "Fleet token should not be present in minimal config"
  }

  assert {
    condition     = !can(regex("prometheus:", output.cloudinit_config.rendered))
    error_message = "Prometheus should not be present in minimal config"
  }

  assert {
    condition     = !can(regex("fedramp_mode:", output.cloudinit_config.rendered))
    error_message = "FedRAMP mode should not be present in minimal config"
  }

  # Verify default encoding
  assert {
    condition     = output.cloudinit_config.gzip == false
    error_message = "gzip should be disabled by default"
  }

  assert {
    condition     = output.cloudinit_config.base64_encode == false
    error_message = "base64_encode should be disabled by default"
  }
}
