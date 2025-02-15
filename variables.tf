variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  sensitive   = true
}

variable "hostname" {
  description = "Hostname to use e.g. 'foo' for foo.example.com"
  type = string
}

variable "domain" {
  description = "Domain to use e.g. 'example.com'"
  type = string
}

variable "dnsimple_token" {
  description = "DNSimple API Token"
  sensitive   = true
}

variable "ssh_key" {
  description = "Public SSH key"
  type        = string
}
