data "cloudinit_config" "config" {
  gzip          = var.gzip_config
  base64_encode = var.base64_encode_config

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-config/init.tpl", {
      community_string = var.fleet_community_string
      license          = var.sensor_license
      mgmt_int         = var.sensor_management_interface_name
      mon_int          = var.sensor_monitoring_interface_name
      health_port      = var.sensor_health_check_http_port
      probe_ranges     = var.sensor_health_check_probe_source_ranges_cidr
      mon_subnet       = var.subnetwork_monitoring_cidr
      mon_gateway      = var.subnetwork_monitoring_gateway

      fleet_token          = var.fleet_token
      fleet_url            = var.fleet_url
      fleet_server_sslname = var.fleet_server_sslname
      fleet_http_proxy     = var.fleet_http_proxy
      fleet_https_proxy    = var.fleet_https_proxy
      fleet_no_proxy       = var.fleet_no_proxy
    })
    filename = "sensor-build.yaml"
  }
}
