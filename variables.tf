variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  sensitive   = true
  type = string
}
variable "tfsp_client_id" {
  description = "Terraform Cloud Service Principal Client ID"
  sensitive   = true
  type = string
}
variable "tfsp_client_secret" {
  description = "Terraform Cloud Service Principal Client Secret"
  sensitive   = true
  type = string
}

variable "hcloud_location" {
  description = "Hetzner Cloud Location"
  type        = string
  default     = "fsn1"
}
variable "hcloud_datacenter" {
  description = "Hetzner Cloud datacenter"
  type        = string
  default     = "fsn1-dc14"
}

variable "hcloud_server_type" {
  description = "Hetzner Cloud Server Type"
  type        = string
  default = "cx22"
}

variable "hostname" {
  description = "Hostname to use e.g. 'foo' for foo.example.com"
  type        = string
}

variable "domain" {
  description = "Domain to use e.g. 'example.com'"
  type        = string
}

variable "dnsimple_account" {
  description = "DNSimple Account ID"
  type        = string
}

variable "dnsimple_token" {
  description = "DNSimple API Token"
  sensitive   = true
  type = string
}

variable "ssh_key" {
  description = "Public SSH key(s) to use for the server"
  type        = map(string)
}

variable "ops" {
  description = "List of Minecraft usernames to op"
  type = list(object({
    uuid                = string
    name                = string
    level               = optional(number, 4)
    bypassesPlayerLimit = optional(bool, true)
  }))
  default = []
}

variable "plugins" {
  description = "List of plugins to install"
  type = list(object({
    name        = string
    url         = string
    configfiles = optional(list(string), [])
  }))

  default = []
}

variable "server_properties" {
  description = "Minecraft server properties. See https://minecraft.wiki/w/Server.properties for details."
  type = object({
    accepts-transfers                 = optional(bool, false)
    allow-flight                      = optional(bool, false)
    allow-nether                      = optional(bool, true)
    broadcast-console-to-ops          = optional(bool, true)
    broadcast-rcon-to-ops             = optional(bool, true)
    bug-report-link                   = optional(string, "")
    difficulty                        = optional(string, "normal")
    enable-command-block              = optional(bool, false)
    enable-jmx-monitoring             = optional(bool, false)
    enable-query                      = optional(bool, false)
    enable-rcon                       = optional(bool, false)
    enable-status                     = optional(bool, true)
    enforce-secure-profile            = optional(bool, true)
    enforce-whitelist                 = optional(bool, false)
    entity-broadcast-range-percentage = optional(number, 100)
    force-gamemode                    = optional(bool, false)
    function-permission-level         = optional(number, 2)
    gamemode                          = optional(string, "survival")
    generate-structures               = optional(bool, true)
    generator-settings                = optional(string, "{}")
    hardcore                          = optional(bool, false)
    hide-online-players               = optional(bool, false)
    initial-disabled-packs            = optional(string, "")
    initial-enabled-packs             = optional(string, "vanilla")
    level-name                        = optional(string, "default")
    level-seed                        = optional(string, "")
    level-type                        = optional(string, "minecraft\\:normal")
    log-ips                           = optional(bool, true)
    max-chained-neighbor-updates      = optional(number, 1000000)
    max-players                       = optional(number, 20)
    max-tick-time                     = optional(number, 60000)
    max-world-size                    = optional(number, 29999984)
    motd                              = optional(string, "A Minecraft Server")
    network-compression-threshold     = optional(number, 256)
    online-mode                       = optional(bool, true)
    op-permission-level               = optional(number, 4)
    pause-when-empty-seconds          = optional(number, 60)
    player-idle-timeout               = optional(number, 0)
    prevent-proxy-connections         = optional(bool, false)
    pvp                               = optional(bool, true)
    query-port                        = optional(number, 25565)
    rate-limit                        = optional(number, 0)
    rcon-password                     = optional(string, "")
    rcon-port                         = optional(number, 25575)
    region-file-compression           = optional(string, "deflate")
    require-resource-pack             = optional(bool, false)
    resource-pack                     = optional(string, "")
    resource-pack-id                  = optional(string, "")
    resource-pack-prompt              = optional(string, "")
    resource-pack-sha1                = optional(string, "")
    server-ip                         = optional(string, "")
    server-port                       = optional(number, 25565)
    simulation-distance               = optional(number, 10)
    spawn-monsters                    = optional(bool, true)
    spawn-protection                  = optional(number, 16)
    sync-chunk-writes                 = optional(bool, true)
    text-filtering-config             = optional(string, "")
    text-filtering-version            = optional(number, 0)
    use-native-transport              = optional(bool, true)
    view-distance                     = optional(number, 10)
    white-list                        = optional(bool, false)
  })
}
