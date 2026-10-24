output "volume_id" {
  value = hcloud_volume.this.id
}

output "linux_device" {
  value = hcloud_volume.this.linux_device
}
