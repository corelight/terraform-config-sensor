# terraform-config-sensor

Terraform for Corelight's Sensor Configuration.

## Usage

```terraform
module "sensor_config" {
  source = "github.com/corelight/terraform-config-sensor"

  fleet_community_string                       = "<your Corelight Fleet community string>"
  sensor_license                               = "<your Corelight sensor license key>"
  sensor_management_interface_name             = "<the instance's management interface name>"
  sensor_monitoring_interface_name             = "<the instance's monitoring interface name>"
  sensor_health_check_probe_source_ranges_cidr = "<the cloud provider's health check source CIDR>"
  subnetwork_monitoring_cidr                   = "<the instance's monitoring subnetwork CIDR>"
  subnetwork_monitoring_gateway                = "<the instance's monitoring subnetwork gateway IP>"

  # Optional - Fleet Manager
  fleet_token = "b1cd099ff22ed8a41abc63929d1db126"
  fleet_url   = "https://fleet.example.com:1443/fleet/v1/internal/softsensor/websocket"
  fleet_server_sslname = "foo.example.com"
}
```

## Deployment

The variables for this module all have default values that can be overwritten
to meet your naming and compliance standards.

Deployment examples can be found [here](examples).

## License

The project is licensed under the MIT license.

[MIT]: LICENSE
