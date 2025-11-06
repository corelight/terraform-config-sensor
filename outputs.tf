output "cloudinit_config" {
  value       = data.cloudinit_config.config
  sensitive   = true
  description = "The complete cloudinit_config data source object. Use .rendered for the final user data string."
}
