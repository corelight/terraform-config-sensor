# terraform-config-sensor

Terraform for Corelight's Sensor Configuration.

## Usage

```hcl
module "sensor_config" {
  source = "github.com/corelight/terraform-config-sensor"

  fleet_community_string                       = "<your Corelight Fleet community string>"
  sensor_license                               = "<your Corelight sensor license key>"
  sensor_management_interface_name             = "<the instance's management interface name>"
  sensor_monitoring_interface_name             = "<the instance's monitoring interface name>"
  sensor_health_check_probe_source_ranges_cidr = "<the cloud provider's health check source CIDR>"
  subnetwork_monitoring_cidr                   = "<the instance's monitoring subnetwork CIDR>"
  subnetwork_monitoring_gateway                = "<the instance's monitoring subnetwork gateway IP>"

  # Optional - Enrichment Service
  enrichment_cloud_provider_name    = "<the cloud provider name>"
  enrichment_storage_container_name = "<name of the enrichment container in the storage account>"

  # Optional - Enrichment Service Azure
  enrichment_storage_account_name   = "<name of the enrichment storage account>"
}
```

## Deployment

The variables for this module all have default values that can be overwritten
to meet your naming and compliance standards.

Deployment examples can be found [here](examples).

## License

The project is licensed under the MIT license.

[MIT]: LICENSE
