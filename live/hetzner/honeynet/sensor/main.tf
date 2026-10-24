resource "hcloud_firewall" "sensor" {
  name   = "sensor"
  labels = local.sensor_labels

  rule {
    description = "Admin SSH from admin addresses"
    direction   = "in"
    protocol    = "tcp"
    port        = tostring(var.admin_ssh_port)
    source_ips  = var.admin_cidrs
  }

  dynamic "rule" {
    for_each = var.honeypot_tcp_ports

    content {
      description = "Honeypot port ${rule.value} from anywhere"
      direction   = "in"
      protocol    = "tcp"
      port        = tostring(rule.value)
      source_ips  = ["0.0.0.0/0"]
    }
  }
}

module "sensor" {
  source = "../../../../modules/hcloud_server"

  name            = "sensor"
  server_type     = var.sensor_server_type
  image           = var.sensor_image
  location        = var.location
  ssh_key_ids     = [data.hcloud_ssh_key.honeynet.id]
  firewall_ids    = [hcloud_firewall.sensor.id]
  primary_ipv4_id = data.hcloud_primary_ip.sensor.id
  network_id      = data.hcloud_network.honeynet.id
  private_ip      = var.sensor_private_ip
  user_data       = local.sensor_user_data
  labels          = local.sensor_labels
}

module "sensor_log_volume" {
  source = "../../../../modules/hcloud_volume"

  name      = var.sensor_log_volume_name
  size      = var.sensor_log_volume_size
  location  = var.location
  server_id = module.sensor.server_id
  labels    = local.sensor_labels
}
