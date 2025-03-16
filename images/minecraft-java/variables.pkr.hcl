
variable "hcloud_token" {
  type      = string
  sensitive = true
  description = "value of the Hetzner Cloud API token - default is read from the HCLOUD_TOKEN environment variable"
  default   = "${env("HCLOUD_TOKEN")}"
}

variable "plugins" {
  description = "List of plugin names and thei download URL to install"
  type = list(object({
    name        = string
    url         = string
  }))

  default = []
}

variable "minecraft_version" {
  description = "Minecraft version to install"
  type        = string
  default     = "1.21.4"
}
