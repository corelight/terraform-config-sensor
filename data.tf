data "cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

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

      # enrichment service
      cloud_provider = var.enrichment_cloud_provider_name
      container_name = var.enrichment_storage_container_name

      # enrichment service - azure
      storage_account_name = var.enrichment_storage_account_name
    })
    filename = "sensor-build.yaml"
  }
}
