variable "name" {
  description = "Name of the volume"
  type        = string
}

variable "size" {
  description = "Size of the volume in GB"
  type        = number
}

variable "location" {
  description = "Hetzner location of the volume. Must match the location of the server"
  type        = string
}

variable "format" {
  description = "Filesystem Hetzner creates on the volume. Applies only when the volume is created"
  type        = string
  default     = "ext4"
}

variable "server_id" {
  description = "ID of the server the volume is attached to"
  type        = number
}

variable "automount" {
  description = "Let Hetzner mount the volume on the server"
  type        = bool
  default     = false
}

variable "delete_protection" {
  description = "Stop Hetzner and Terraform from deleting the volume"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels applied to the volume"
  type        = map(string)
  default     = {}
}
