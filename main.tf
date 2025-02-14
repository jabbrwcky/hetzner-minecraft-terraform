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

resource "hcloud_firewall" "firewall" {
  name = "firewall"
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "25565"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    direction = "in"
    protocol  = "udp"
    port      = "25565"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_server" "minecraft" {
  name        = "minecraft-java"
  image       = "ubuntu-24.04"
  server_type = "cx22"
  ssh_keys    = [hcloud_ssh_key.main.id]
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

resource "hcloud_ssh_key" "main" {
  name       = "my-ssh-key"
  public_key = var.ssh_key
}

data "cloudinit_config" "minecraft" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content      = file("${path.module}/cloud-config.yaml")
  }
}