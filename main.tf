locals {
  create_dnsimple_record = (var.hostname != "" && var.dnsimple_token != "")
  cloudinit_config = merge(
    merge(
      var.server_properties,
      {
        "minecraft-server-jar-url" = var.minecraft-server-jar-url
        "volume_device"            = hcloud_volume.worlds.linux_device
        "server_id"                = random_uuid.server_id.result
        "ops"                      = jsonencode(var.ops)
        "minecraft-service"        = file("${path.module}/minecraft.service")
        "rsa_private"              = tls_private_key.rsa-host-key.private_key_openssh
        "rsa_public"               = tls_private_key.rsa-host-key.public_key_openssh
        "ecdsa_private"            = tls_private_key.ecdsa-host-key.private_key_openssh
        "ecdsa_public"             = tls_private_key.ecdsa-host-key.public_key_openssh
        "ed25519_private"          = tls_private_key.ed25519-host-key.private_key_openssh
        "ed25519_public"           = tls_private_key.ed25519-host-key.public_key_openssh
    }),
    var.server_properties.enable-rcon && var.server_properties.rcon-password == "" ? {
      rcon-password = random_password.rcon[0].result
  } : {})
}

resource "random_uuid" "server_id" {
  keepers = {
    hostname = var.hostname
  }
}

resource "random_password" "rcon" {
  count            = var.server_properties.enable-rcon && var.server_properties.rcon-password == "" ? 1 : 0
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# ECDSA key with P384 elliptic curve
resource "tls_private_key" "ecdsa-host-key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa-host-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# ED25519 key
resource "tls_private_key" "ed25519-host-key" {
  algorithm = "ED25519"
}

resource "hcloud_ssh_key" "keys" {
  for_each   = var.ssh_key
  name       = each.key
  public_key = each.value
}

resource "hcloud_primary_ip" "mainv4" {
  name          = "mc-ipv4"
  type          = "ipv4"
  datacenter    = "fsn1-dc14"
  assignee_type = "server"
  auto_delete   = false
  labels = {
    "svc" : "minecraft"
  }
}

resource "hcloud_primary_ip" "mainv6" {
  name          = "mc-ipv6"
  type          = "ipv6"
  datacenter    = "fsn1-dc14"
  assignee_type = "server"
  auto_delete   = false
  labels = {
    "svc" : "minecaft"
  }
}

resource "hcloud_server" "minecraft" {
  name        = "minecraft"
  image       = "ubuntu-24.04"
  server_type = "cx22"
  ssh_keys    = [for key in hcloud_ssh_key.keys : key.id]
  datacenter  = "fsn1-dc14"
  labels = {
    "svc" : "minecraft"
  }
  firewall_ids = [hcloud_firewall.firewall.id]
  user_data    = data.cloudinit_config.minecraft.rendered
  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.mainv4.id
    ipv6_enabled = true
    ipv6         = hcloud_primary_ip.mainv6.id
  }
}

resource "hcloud_volume_attachment" "main" {
  volume_id = hcloud_volume.worlds.id
  server_id = hcloud_server.minecraft.id
  automount = true
}

resource "hcloud_volume" "worlds" {
  name     = "minecraft-worlds"
  location = "fsn1"
  size     = 10
}

data "cloudinit_config" "minecraft" {
  gzip          = false
  base64_encode = false
  
  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/cloud-config.yaml.tftpl", local.cloudinit_config)
  }
}
