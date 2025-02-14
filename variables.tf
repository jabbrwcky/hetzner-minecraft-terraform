variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  sensitive   = true
}

variable "ssh_key" {
  description = "Public SSH key"
  type        = string
}
