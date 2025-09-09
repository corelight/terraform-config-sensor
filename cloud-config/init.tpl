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
        management_interface:
          name: ${mgmt_int}
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