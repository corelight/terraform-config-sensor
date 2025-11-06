# terraform-config-sensor

[![Terraform Tests](https://github.com/corelight/terraform-config-sensor/actions/workflows/test.yml/badge.svg)](https://github.com/corelight/terraform-config-sensor/actions/workflows/test.yml)
[![Terraform Validation](https://github.com/corelight/terraform-config-sensor/actions/workflows/fmt-check.yml/badge.svg)](https://github.com/corelight/terraform-config-sensor/actions/workflows/fmt-check.yml)
[![Trivy Security Scan](https://github.com/corelight/terraform-config-sensor/actions/workflows/scan-trivy.yml/badge.svg)](https://github.com/corelight/terraform-config-sensor/actions/workflows/scan-trivy.yml)

Terraform module for generating Corelight Sensor configuration using cloud-init. This module creates a cloud-config user data file that configures Corelight Sensors for deployment in cloud environments.

## Features

- **Template-based Configuration**: Generates `corelightctl.yaml` configuration via cloud-init
- **Fleet Manager Integration**: Optional pairing with Corelight Fleet Manager
- **Health Check Support**: Configurable HTTP health checks for cloud load balancers
- **Prometheus Metrics**: Optional Prometheus endpoint enablement
- **FedRAMP Mode**: Optional FedRAMP compliance mode
- **Flexible Output**: Optional gzip and base64 encoding for cloud providers
- **Comprehensive Testing**: 24 unit tests with 100% pass rate
- **Automated Validation**: CI/CD pipelines for formatting, testing, and security scanning

## Requirements

| Name | Version |
|------|---------|
| [Terraform](https://www.terraform.io/downloads.html) | >= 1.3.2 |
| [cloudinit provider](https://registry.terraform.io/providers/hashicorp/cloudinit/latest) | >= 2.3.0, < 3.0.0 |

**Note**: Tests require Terraform >= 1.6.0 for native testing framework support.

## Usage

### Basic Example

```terraform
module "sensor_config" {
  source = "github.com/corelight/terraform-config-sensor"

  # Required: Core sensor configuration
  fleet_community_string           = "your-fleet-community-string"
  sensor_license                   = "your-sensor-license-key"
  sensor_management_interface_name = "eth0"
  sensor_monitoring_interface_name = "eth1"

  # Optional: Health check configuration (both must be set together)
  sensor_health_check_probe_source_ranges_cidr = ["35.191.0.0/16", "130.211.0.0/22"]
  subnetwork_monitoring_cidr                   = "10.0.1.0/24"
  subnetwork_monitoring_gateway                = "10.0.1.1"
}
```

**Note**: While health check configuration is shown above, only the four core sensor variables are strictly required. Health check configuration requires both `subnetwork_monitoring_cidr` and `subnetwork_monitoring_gateway` to be set together.

### With Fleet Manager Pairing

```terraform
module "sensor_config" {
  source = "github.com/corelight/terraform-config-sensor"

  # Required configuration
  fleet_community_string           = "your-fleet-community-string"
  sensor_license                   = "your-sensor-license-key"
  sensor_management_interface_name = "eth0"
  sensor_monitoring_interface_name = "eth1"

  # Health checks
  sensor_health_check_probe_source_ranges_cidr = ["35.191.0.0/16"]
  subnetwork_monitoring_cidr                   = "10.0.1.0/24"
  subnetwork_monitoring_gateway                = "10.0.1.1"

  # Fleet Manager pairing (all three required together)
  fleet_token           = "b1cd099ff22ed8a41abc63929d1db126"
  fleet_url             = "https://fleet.example.com:1443/fleet/v1/internal/softsensor/websocket"
  fleet_server_sslname  = "fleet.example.com"

  # Optional: Fleet proxy configuration
  fleet_http_proxy  = "http://proxy.example.com:8080"
  fleet_https_proxy = "https://proxy.example.com:8443"
  fleet_no_proxy    = "localhost,127.0.0.1,.example.com"
}
```

### With Advanced Features

```terraform
module "sensor_config" {
  source = "github.com/corelight/terraform-config-sensor"

  # Required configuration
  fleet_community_string           = "your-fleet-community-string"
  sensor_license                   = "your-sensor-license-key"
  sensor_management_interface_name = "eth0"
  sensor_monitoring_interface_name = "eth1"

  # Health checks
  sensor_health_check_probe_source_ranges_cidr = ["35.191.0.0/16"]
  subnetwork_monitoring_cidr                   = "10.0.1.0/24"
  subnetwork_monitoring_gateway                = "10.0.1.1"

  # Feature flags
  prometheus_enabled   = true
  fedramp_mode_enabled = true

  # Output encoding (useful for some cloud providers)
  gzip_config          = true
  base64_encode_config = true
}
```

## Inputs

| Name                                                                                                                                                                  | Description                                                                                                                                        | Type           | Default   | Required |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------|----------------|-----------|----------|
| <a name="input_fleet_community_string"></a> [fleet_community_string](#input_fleet_community_string)                                                                   | The Fleet Manager community string (API string)                                                                                                    | `string`       | n/a       | yes      |
| <a name="input_sensor_license"></a> [sensor_license](#input_sensor_license)                                                                                           | The Corelight sensor license key string                                                                                                            | `string`       | n/a       | yes      |
| <a name="input_sensor_management_interface_name"></a> [sensor_management_interface_name](#input_sensor_management_interface_name)                                     | The sensor's management interface name (e.g., eth0, ens5)                                                                                          | `string`       | n/a       | yes      |
| <a name="input_sensor_monitoring_interface_name"></a> [sensor_monitoring_interface_name](#input_sensor_monitoring_interface_name)                                     | The sensor's monitoring interface name (e.g., eth1, ens6)                                                                                          | `string`       | n/a       | yes      |
| <a name="input_base64_encode_config"></a> [base64_encode_config](#input_base64_encode_config)                                                                         | Whether to base64 encode the configuration output                                                                                                  | `bool`         | `false`   | no       |
| <a name="input_fedramp_mode_enabled"></a> [fedramp_mode_enabled](#input_fedramp_mode_enabled)                                                                         | Enable FedRAMP compliance mode on the sensor                                                                                                       | `bool`         | `false`   | no       |
| <a name="input_fleet_http_proxy"></a> [fleet_http_proxy](#input_fleet_http_proxy)                                                                                     | HTTP proxy URL for Fleet Manager traffic (e.g., http://proxy.example.com:8080)                                                                     | `string`       | `""`      | no       |
| <a name="input_fleet_https_proxy"></a> [fleet_https_proxy](#input_fleet_https_proxy)                                                                                  | HTTPS proxy URL for Fleet Manager traffic (e.g., https://proxy.example.com:8443)                                                                   | `string`       | `""`      | no       |
| <a name="input_fleet_no_proxy"></a> [fleet_no_proxy](#input_fleet_no_proxy)                                                                                           | Comma-separated list of hosts/domains to bypass proxy for Fleet traffic                                                                            | `string`       | `""`      | no       |
| <a name="input_fleet_server_sslname"></a> [fleet_server_sslname](#input_fleet_server_sslname)                                                                         | SSL hostname for the Fleet Manager server. Must be set together with fleet_token and fleet_url                                                     | `string`       | `""`      | no       |
| <a name="input_fleet_token"></a> [fleet_token](#input_fleet_token)                                                                                                    | Fleet Manager pairing token from Fleet UI. Must be set together with fleet_url and fleet_server_sslname                                            | `string`       | `""`      | no       |
| <a name="input_fleet_url"></a> [fleet_url](#input_fleet_url)                                                                                                          | Fleet Manager WebSocket URL. Must be set together with fleet_token and fleet_server_sslname                                                        | `string`       | `""`      | no       |
| <a name="input_gzip_config"></a> [gzip_config](#input_gzip_config)                                                                                                    | Whether to gzip the configuration output (useful for large configs)                                                                                | `bool`         | `false`   | no       |
| <a name="input_prometheus_enabled"></a> [prometheus_enabled](#input_prometheus_enabled)                                                                               | Enable Prometheus metrics endpoint on the sensor                                                                                                   | `bool`         | `false`   | no       |
| <a name="input_sensor_health_check_http_port"></a> [sensor_health_check_http_port](#input_sensor_health_check_http_port)                                              | HTTP port number for health check endpoint                                                                                                         | `string`       | `"41080"` | no       |
| <a name="input_sensor_health_check_probe_source_ranges_cidr"></a> [sensor_health_check_probe_source_ranges_cidr](#input_sensor_health_check_probe_source_ranges_cidr) | List of CIDR ranges allowed to access the health check endpoint                                                                                    | `list(string)` | `[""]`    | no       |
| <a name="input_subnetwork_monitoring_cidr"></a> [subnetwork_monitoring_cidr](#input_subnetwork_monitoring_cidr)                                                       | Monitoring subnet in CIDR notation (e.g., 10.0.1.0/24). Must be valid CIDR or empty. Required with subnetwork_monitoring_gateway for health checks | `string`       | `""`      | no       |
| <a name="input_subnetwork_monitoring_gateway"></a> [subnetwork_monitoring_gateway](#input_subnetwork_monitoring_gateway)                                              | Monitoring subnet gateway IP address (e.g., 10.0.1.1). Required with subnetwork_monitoring_cidr for health checks                                  | `string`       | `""`      | no       |

### Input Notes

- **Fleet Manager Pairing**: `fleet_token`, `fleet_url`, and `fleet_server_sslname` must all be set together or all be empty. The module enforces this validation rule - providing only one or two will result in an error.
- **Health Checks**: To enable health check configuration in the generated config, both `subnetwork_monitoring_cidr` and `subnetwork_monitoring_gateway` must be provided. If either is empty, the health check section will be omitted from the cloud-init output.
- **CIDR Validation**: The `subnetwork_monitoring_cidr` variable validates that the value is either empty or a valid CIDR block (e.g., `10.0.1.0/24`).
- **Output Encoding**: Use `gzip_config` and `base64_encode_config` based on your cloud provider's requirements (e.g., AWS EC2 user data supports gzip, and some providers require base64 encoding).

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudinit_config"></a> [cloudinit_config](#output_cloudinit_config) | The complete cloudinit_config data source object. Use `.rendered` for the final user data string. |

### Output Usage

The module outputs the entire `cloudinit_config` data source, which provides multiple attributes:

```terraform
# Get the rendered user data
user_data = module.sensor_config.cloudinit_config.rendered

# Access the gzipped version (if gzip_config = true)
user_data_gzipped = module.sensor_config.cloudinit_config.gzip

# Access the base64 encoded version (if base64_encode_config = true)
user_data_base64 = module.sensor_config.cloudinit_config.base64_encode
```

## Configuration Flow

This module generates cloud-init user data through the following process:

1. **Variable Input**: User provides configuration variables to the module
2. **Template Processing**: The `data.tf` file processes the cloud-init template (`cloud-config/init.tpl`) with the provided variables
3. **Conditional Rendering**: The template conditionally includes configuration sections based on variable presence:
   - Health checks (requires both `subnetwork_monitoring_cidr` and `subnetwork_monitoring_gateway`)
   - Fleet Manager pairing (requires `fleet_token`, `fleet_url`, and `fleet_server_sslname`)
   - Prometheus metrics (requires `prometheus_enabled = true`)
   - FedRAMP mode (requires `fedramp_mode_enabled = true`)
4. **Output Generation**: The module outputs the cloudinit_config data source with optional gzip/base64 encoding
5. **Cloud-Init Execution**: When the cloud instance boots with the generated user data, cloud-init:
   - Writes `/etc/corelight/corelightctl.yaml` with the sensor configuration
   - Executes `corelightctl sensor deploy -v` to initialize the sensor
6. **Sensor Initialization**: The Corelight sensor starts with the configured settings

## Development

This project uses [Task](https://taskfile.dev/) for common operations:

```bash
# Format Terraform files
task fmt

# Check if Terraform files are properly formatted
task fmt:check

# Run Terraform unit tests
task test

# Run Terraform unit tests with verbose output
task test:verbose
```

Manual Terraform commands:

```bash
# Format recursively
terraform fmt -recursive .

# Check formatting with diff
terraform fmt -recursive -check -diff .
```

## Testing

This module includes comprehensive unit tests using Terraform's native testing framework.

**Requirements**: Terraform >= 1.6.0 for testing support

### Running Tests

Using Task (recommended):

```bash
# Run all tests
task test

# Run tests with verbose output
task test:verbose
```

Using Terraform directly:

```bash
# Run all tests
terraform test

# Run tests with verbose output
terraform test -verbose

# Run a specific test file
terraform test -filter=tests/basic_configuration.tftest.hcl
```

### Test Results

All 24 tests pass successfully:
- 3 basic configuration tests
- 5 feature flag tests
- 3 Fleet Manager tests
- 2 integration tests
- 5 output encoding tests
- 6 validation tests

### Test Coverage

The test suite validates all module functionality:

| Test File                        | Purpose                                                              | Test Count |
|----------------------------------|----------------------------------------------------------------------|------------|
| `basic_configuration.tftest.hcl` | Basic sensor config, minimal config, health check rendering          | 3          |
| `fleet_manager.tftest.hcl`       | Fleet Manager pairing, proxy configuration, non-Fleet scenarios      | 3          |
| `feature_flags.tftest.hcl`       | Prometheus and FedRAMP mode enablement                               | 5          |
| `output_encoding.tftest.hcl`     | Gzip and base64 encoding options                                     | 5          |
| `validation.tftest.hcl`          | Input validation rules (Fleet Manager dependencies, CIDR validation) | 6          |
| `integration.tftest.hcl`         | Full feature integration and minimal configuration                   | 2          |

### Key Test Scenarios

- **Required Variables**: Validates all required variables are properly rendered
- **Conditional Features**: Verifies optional sections only appear when configured
- **Fleet Manager Validation**: Ensures `fleet_token`, `fleet_url`, and `fleet_server_sslname` must all be set together
- **Health Check Logic**: Confirms health checks require both CIDR and gateway
- **Output Encoding**: Tests gzip and base64 encoding independently and together
- **CIDR Validation**: Validates `subnetwork_monitoring_cidr` accepts valid CIDR or empty string
- **Integration**: Tests realistic configurations with multiple features enabled

### Writing New Tests

Tests follow the `.tftest.hcl` format in the `tests/` directory:

```hcl
run "descriptive_test_name" {
  command = plan

  variables {
    fleet_community_string = "test-value"
    sensor_license         = "test-license"
    # ... other required variables
  }

  assert {
    condition     = can(regex("expected-pattern", output.cloudinit_config.rendered))
    error_message = "Descriptive error message explaining what should be present"
  }
}
```

For validation tests, use `expect_failures`:

```hcl
run "validation_test_name" {
  command = plan

  variables {
    # ... configuration that should fail
  }

  expect_failures = [
    var.variable_name,  # The variable with validation rule
  ]
}
```

## Continuous Integration

This module uses GitHub Actions for comprehensive automated validation. All workflows use Terraform 1.8.2.

### CI/CD Workflows

| Workflow                 | Trigger                         | Purpose                         | Status                                                                                                                                                                                                           |
|--------------------------|---------------------------------|---------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Terraform Validation** | Pull requests to `main`         | Format checking and unit tests  | [![Terraform Validation](https://github.com/corelight/terraform-config-sensor/actions/workflows/fmt-check.yml/badge.svg)](https://github.com/corelight/terraform-config-sensor/actions/workflows/fmt-check.yml)  |
| **Terraform Tests**      | PRs and pushes to `main`        | Verbose test execution          | [![Terraform Tests](https://github.com/corelight/terraform-config-sensor/actions/workflows/test.yml/badge.svg)](https://github.com/corelight/terraform-config-sensor/actions/workflows/test.yml)                 |
| **Trivy Security Scan**  | PRs, daily at 03:00 UTC, manual | Security vulnerability scanning | [![Trivy Security Scan](https://github.com/corelight/terraform-config-sensor/actions/workflows/scan-trivy.yml/badge.svg)](https://github.com/corelight/terraform-config-sensor/actions/workflows/scan-trivy.yml) |
| **Version Bump**         | Merged PRs to `main`            | Automatic version tagging       | [![Bump version](https://github.com/corelight/terraform-config-sensor/actions/workflows/tag-bump.yml/badge.svg)](https://github.com/corelight/terraform-config-sensor/actions/workflows/tag-bump.yml)            |

### Workflow Details

**Terraform Validation** (`.github/workflows/fmt-check.yml`)
- Validates Terraform formatting with `task fmt:check`
- Runs `terraform init` to ensure provider dependencies resolve
- Executes unit tests with `task test`
- Must pass before PRs can be merged

**Terraform Tests** (`.github/workflows/test.yml`)
- Runs complete test suite with verbose output (`task test:verbose`)
- Provides detailed test results for each test file
- Executes on both PRs and commits to main branch

**Trivy Security Scan** (`.github/workflows/scan-trivy.yml`)
- Scans Terraform code for security vulnerabilities and misconfigurations
- Runs automatically on PRs to catch issues early
- Scheduled nightly scans for ongoing security monitoring
- Can be triggered manually via workflow_dispatch

**Version Bump** (`.github/workflows/tag-bump.yml`)
- Automatically increments semantic version tags when PRs are merged
- Uses commit messages to determine version bump type
- Creates git tags with `v` prefix (e.g., `v1.2.3`)

### Quality Gates

All pull requests must pass the following before merging:
- Terraform formatting validation
- All 24 unit tests
- Security scanning (Trivy)

## Module Design

### Architecture Decisions

This module follows Terraform best practices and Corelight-specific patterns:

- **Data Source Only**: Generates configuration data without creating infrastructure resources, making it composable with any cloud provider module
- **Template-Based**: Uses a single cloud-init template (`cloud-config/init.tpl`) for flexibility, maintainability, and easier testing
- **Fleet Integration**: Fleet Manager pairing is always configured via the cloud-init template, ensuring consistent, automated sensor enrollment (no manual `corelightctl` commands required)
- **Conditional Rendering**: Template sections are rendered only when required variables are provided, keeping generated configs clean and minimal
- **Validation at Input**: Input validation rules catch configuration errors early, before deployment
- **No Sensitive Marking**: Variables are intentionally not marked as sensitive since this module only generates configuration strings (secrets should be protected at the consumption layer)

### Module Structure

```
.
├── cloud-config/
│   └── init.tpl              # Cloud-init template for corelightctl.yaml
├── tests/                     # Terraform native test suite (24 tests)
│   ├── basic_configuration.tftest.hcl
│   ├── feature_flags.tftest.hcl
│   ├── fleet_manager.tftest.hcl
│   ├── integration.tftest.hcl
│   ├── output_encoding.tftest.hcl
│   └── validation.tftest.hcl
├── .github/workflows/         # CI/CD pipelines
│   ├── fmt-check.yml         # Format validation and tests
│   ├── test.yml              # Verbose test execution
│   ├── scan-trivy.yml        # Security scanning
│   └── tag-bump.yml          # Automated versioning
├── data.tf                    # cloudinit_config data source
├── variables.tf               # Input variables with validation rules
├── outputs.tf                 # Module outputs
├── versions.tf                # Provider version constraints
├── Taskfile.yml              # Task runner commands
├── CLAUDE.md                 # AI assistant guidance
└── README.md                 # This file
```

### Key Files

- **`variables.tf`**: Defines 17 input variables with type constraints, defaults, descriptions, and validation rules
- **`data.tf`**: Configures the `cloudinit_config` data source, processing the template with user variables
- **`outputs.tf`**: Exposes the complete cloudinit_config object for use by consuming modules
- **`versions.tf`**: Specifies Terraform >= 1.3.2 and cloudinit provider >= 2.3.0, < 3.0.0
- **`cloud-config/init.tpl`**: Jinja-style template that generates YAML configuration for `corelightctl`
- **`tests/`**: Comprehensive test suite with 24 tests covering all functionality and edge cases

## Best Practices

### Security Considerations

1. **Protect Sensitive Variables**: While this module doesn't mark variables as sensitive (since it only generates config strings), you should protect secrets when using the module:
   ```terraform
   locals {
     # Mark sensitive values in your consuming module
     fleet_community_string = sensitive(var.fleet_community_string)
     sensor_license         = sensitive(var.sensor_license)
   }
   ```

2. **Use Terraform Cloud/Enterprise**: For production deployments, store sensitive values in Terraform Cloud/Enterprise variable sets with "Sensitive" enabled.

3. **Secrets Management Integration**: Consider integrating with secrets managers:
   ```terraform
   data "aws_secretsmanager_secret_version" "sensor_config" {
     secret_id = "corelight/sensor/config"
   }

   locals {
     secrets = jsondecode(data.aws_secretsmanager_secret_version.sensor_config.secret_string)
   }

   module "sensor_config" {
     source = "github.com/corelight/terraform-config-sensor"

     fleet_community_string = local.secrets.community_string
     sensor_license         = local.secrets.license
     # ...
   }
   ```

### Module Versioning

Pin to a specific version tag for production use:

```terraform
module "sensor_config" {
  source = "github.com/corelight/terraform-config-sensor?ref=v1.2.3"
  # ...
}
```

Check available versions: https://github.com/corelight/terraform-config-sensor/tags

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `task fmt` to format code
5. Run `task test` to ensure all tests pass
6. Submit a pull request

All PRs must pass CI checks (formatting, tests, security scan) before merging.

## Support

For issues and questions:
- **GitHub Issues**: https://github.com/corelight/terraform-config-sensor/issues
- **Corelight Support**: https://www.corelight.com/support

## License

Copyright (c) 2025 Corelight, Inc.

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
