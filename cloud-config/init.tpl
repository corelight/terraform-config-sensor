#cloud-config

write_files:
  - owner: root:root
    path: /etc/corelight/corelightctl.yaml
    permissions: '0644'
    content: |
      sensor:
        api:
          password: ${community_string}
        license_key: ${license}
%{ if prometheus_enabled}
        prometheus:
          enable: true
%{ endif }
%{ if fedramp_mode_enabled}
        fedramp_mode: true
%{ endif }
        management_interface:
          - name: ${mgmt_int}
            wait: true
        monitoring_interface:
          name: ${mon_int}
          wait: true
%{ if health_port != "" ~}
          health_check:
            port: ${health_port}
%{ endif ~}
%{ if mon_subnet != "" }
            subnet: ${mon_subnet}
%{ endif ~}
%{ if mon_gateway != "" }
            gateway: ${mon_gateway}
%{ endif ~}
        kubernetes:
          allow_ports:
%{ for probe in probe_ranges ~}
            - protocol: tcp
              port: ${health_port}
              net: ${probe}
%{ endfor ~}
%{ if fleet_token != "" && fleet_url != "" ~}
        pairing:
          token: ${fleet_token}
          url: ${fleet_url}
          server_sslname: ${fleet_server_sslname}
%{ if fleet_http_proxy != "" ~}
          http_proxy: ${fleet_http_proxy}
%{ endif ~}
%{ if fleet_https_proxy != "" ~}
          https_proxy: ${fleet_https_proxy}
%{ endif ~}
%{ if fleet_no_proxy != "" ~}
          no_proxy: ${fleet_no_proxy}
%{ endif ~}
%{ endif ~}

runcmd:
  - corelightctl sensor deploy -v
%{ if azure_fips_enabled ~}
  - |
    timeout=120
    elapsed=0
    while [ $elapsed -lt $timeout ]; do
      version=$(waagent version 2>/dev/null | grep "Goal state agent:" | awk '{print $NF}')
      if [ -n "$version" ]; then
        # Compare versions: convert to comparable format
        current=$(echo "$version" | awk -F. '{printf "%d%03d%03d%03d\n", $1, $2, $3, $4}')
        required=$(echo "2.15.0.1" | awk -F. '{printf "%d%03d%03d%03d\n", $1, $2, $3, $4}')
        if [ "$current" -ge "$required" ]; then
          echo "waagent Goal state agent version $version is ready"
          break
        fi
      fi
      echo "Waiting for waagent Goal state agent >= 2.15.0.1, current: $version ($${elapsed}s elapsed)"
      sleep 5
      elapsed=$((elapsed + 5))
    done
    if [ $elapsed -ge $timeout ]; then
      echo "ERROR: Timeout waiting for waagent Goal state agent >= 2.15.0.1"
      exit 1
    fi
  - fips-mode-setup --enable
  - reboot
%{ endif ~}
