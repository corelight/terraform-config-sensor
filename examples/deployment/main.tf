locals {
  community_string         = "abc123"
  license                  = file("~/corelight-license.txt")
  mgmt_interface           = "eth0"
  mon_interface            = "eth1"
  probe_source_ranges_cidr = ["130.211.0.0/22", "35.191.0.0/16"]
  mon_cidr                 = "10.3.0.0/24"
  mon_gateway              = "10.3.0.1"

  enrichment_cloud_provider         = "azure"
  enrichment_storage_account_name   = "account-foo"
  enrichment_storage_container_name = "bucket-bar"
}

module "sensor_config" {
  source = "../../"

  fleet_community_string                       = local.community_string
  sensor_license                               = local.license
  sensor_management_interface_name             = local.mgmt_interface
  sensor_monitoring_interface_name             = local.mon_interface
  sensor_health_check_probe_source_ranges_cidr = local.probe_source_ranges_cidr
  subnetwork_monitoring_cidr                   = local.mon_cidr
  subnetwork_monitoring_gateway                = local.mon_gateway

  # Optional - Enrichment Service
  enrichment_cloud_provider_name    = local.enrichment_cloud_provider
  enrichment_storage_container_name = local.enrichment_storage_container_name

  # Optional - Enrichment Service Azure
  enrichment_storage_account_name = local.enrichment_storage_account_name
}
