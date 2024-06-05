variable "fleet_community_string" {
  type        = string
  sensitive   = true
  description = "the Fleet Manager community string (api string)"
}

variable "sensor_license" {
  type        = string
  sensitive   = true
  description = "path to the Corelight sensor license file"
}

variable "sensor_management_interface_name" {
  type        = string
  description = "the sensor(s) management interface name"
}

variable "sensor_monitoring_interface_name" {
  type        = string
  description = "the sensor(s) monitoring interface name"
}

variable "sensor_health_check_http_port" {
  type        = string
  default     = "41080"
  description = "the port number for the HTTP health check request"
}

variable "sensor_health_check_probe_source_ranges_cidr" {
  type        = list(string)
  default     = [""]
  description = "(optional) the health check probe ranges"
}

variable "subnetwork_monitoring_cidr" {
  type        = string
  default     = ""
  description = "(optional) the monitoring subnet for the sensor(s), leaving this empty will result in no sensor.monitoring_interface.health_check section being rendered into user data."
}

variable "subnetwork_monitoring_gateway" {
  type        = string
  default     = ""
  description = "(optional) the monitoring subnet's gateway address, leaving this empty will result in no sensor.monitoring_interface.health_check section being rendered into user data."
}

# Enrichment Service

variable "enrichment_cloud_provider_name" {
  description = "(optional) the cloud provider name"
  type        = string
  default     = ""

  validation {
    condition     = contains(["", "aws", "azure", "gcp"], var.enrichment_cloud_provider_name)
    error_message = "allowed options: \"aws\", \"azure\", \"gcp\"."
  }
}

# Enrichment Service -- Azure

variable "enrichment_storage_account_name" {
  description = "(optional) the azure storage account where enrichment data is stored"
  type        = string
  default     = ""
}

variable "enrichment_storage_container_name" {
  description = "(optional) the container where enrichment data is stored"
  type        = string
  default     = ""
}
