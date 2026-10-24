output "ssh_key_name" {
  value = hcloud_ssh_key.honeynet.name
}

output "sensor_public_ipv4" {
  value = hcloud_primary_ip.sensor.ip_address
}
