resource "hcloud_volume" "this" {
  name              = var.name
  size              = var.size
  location          = var.location
  format            = var.format
  delete_protection = var.delete_protection
  labels            = var.labels
}

resource "hcloud_volume_attachment" "this" {
  volume_id = hcloud_volume.this.id
  server_id = var.server_id
  automount = var.automount
}
