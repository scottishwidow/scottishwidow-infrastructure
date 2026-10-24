variable "ssh_key_name" {
  description = "Name of the Hetzner SSH key for admin access to the Honeynet servers"
  type        = string
  default     = "honeynet"
}

variable "ssh_public_key_path" {
  description = "Local path to the public key of the Honeynet-only key pair. Never use a key that is trusted outside the Honeynet"
  type        = string
  default     = "~/.ssh/honeynet.pub"
}

variable "sensor_ipv4_name" {
  description = "Name of the Sensor primary IPv4. The sensor root reads the address by this name"
  type        = string
  default     = "sensor-ipv4"
}

variable "location" {
  description = "Hetzner location of the Sensor primary IPv4. Must match the location of the Sensor"
  type        = string
  default     = "fsn1"
}
