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

variable "gzip_config" {
  type        = bool
  default     = false
  description = "should the configuration be gzipped"
}

variable "base64_encode_config" {
  type        = bool
  default     = false
  description = "should the configuration be base64 encoded"
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
variable "enrichment_enabled" {
  description = "(optional) if cloud enrichment should enabled at time of sensor deployment"
  type        = string
  default     = false
}

variable "enrichment_cloud_provider_name" {
  description = "(optional) the cloud provider name"
  type        = string
  default     = ""

  validation {
    condition     = contains(["", "aws", "azure", "gcp"], var.enrichment_cloud_provider_name)
    error_message = "allowed options: \"aws\", \"azure\", \"gcp\"."
  }
}

variable "enrichment_bucket_name" {
  description = "(optional) the s3 bucket, azure storage container, or gcs bucket name"
  type        = string
  default     = ""
}

# Enrichment Service -- Azure
variable "enrichment_storage_account_name" {
  description = "(optional) the azure storage account where enrichment data is stored"
  type        = string
  default     = ""
}


# Enrichment Service -- AWS
variable "enrichment_bucket_region" {
  description = "(optional) the region for the s3 enrichment bucket"
  type        = string
  default     = ""
}