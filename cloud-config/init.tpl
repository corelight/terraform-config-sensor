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

runcmd:
  - corelightctl sensor deploy -v
%{ if enrichment_enabled && cloud_provider == "aws" ~}
  - |
    echo '{"cloud_enrichment.enable": "true", "cloud_enrichment.cloud_provider": "aws","cloud_enrichment.bucket_name": "${bucket_name}", "cloud_enrichment.bucket_location": "${bucket_region}"}' | corelightctl sensor cfg put
%{ endif ~}
%{ if enrichment_enabled && cloud_provider == "azure" ~}
  - |
    echo '{"cloud_enrichment.enable": "true", "cloud_enrichment.cloud_provider": "azure","cloud_enrichment.bucket_name": "${bucket_name}", "cloud_enrichment.azure_storage_account": "${azure_storage_account_name}"}' | corelightctl sensor cfg put
%{ endif ~}
%{ if enrichment_enabled && cloud_provider == "gcp" ~}
  - |
   echo '{"cloud_enrichment.enable": "true", "cloud_enrichment.cloud_provider": "gcp","cloud_enrichment.bucket_name": "${bucket_name}"}' | corelightctl sensor cfg put
%{ endif ~}
%{ if enrichment_enabled ~}
  - /usr/local/bin/kubectl rollout restart deployment -n corelight-sensor sensor-core
%{ endif ~}
