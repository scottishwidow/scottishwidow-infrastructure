resource "hcloud_ssh_key" "honeynet" {
  name       = var.ssh_key_name
  public_key = file(pathexpand(var.ssh_public_key_path))
  labels     = { env = "honeynet", management = "bootstrap" }
}

resource "hcloud_primary_ip" "sensor" {
  name              = var.sensor_ipv4_name
  type              = "ipv4"
  location          = var.location
  auto_delete       = false
  delete_protection = true
  labels            = { env = "honeynet", management = "bootstrap", role = "sensor" }
}
