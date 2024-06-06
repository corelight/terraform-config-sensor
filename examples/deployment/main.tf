locals {
  community_string         = "abc123"
  license                  = file("~/corelight-license.txt")
  mgmt_interface           = "eth0"
  mon_interface            = "eth1"
  probe_source_ranges_cidr = ["130.211.0.0/22", "35.191.0.0/16"]
  mon_cidr                 = "10.3.0.0/24"
  mon_gateway              = "10.3.0.1"


  # Enrichment
  enrichment_enabled              = "<true | false>"
  enrichment_cloud_provider       = "<aws | azure | gcp>"
  enrichment_storage_account_name = "account-foo"
  enrichment_bucket_name          = "bucket-bar"
  enrichment_s3_bucket_region     = "us-east-1"
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
  enrichment_enabled             = local.enrichment_enabled
  enrichment_cloud_provider_name = local.enrichment_cloud_provider
  enrichment_bucket_name         = local.enrichment_bucket_name

  # Optional - Enrichment Service Azure Only
  enrichment_storage_account_name = local.enrichment_storage_account_name

  # Optional - Enrichment Service AWS Only
  enrichment_bucket_region = local.enrichment_s3_bucket_region
}
