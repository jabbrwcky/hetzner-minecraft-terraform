resource "hcloud_firewall" "firewall" {
  name = "firewall"
  rule {
    description = "Allow incoming ICMP"
    direction   = "in"
    protocol    = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # Game server TCP
  rule {
    description = "Minecraft server port TCP"
    direction   = "in"
    protocol    = "tcp"
    port        = "25565"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # Game server UDP
  rule {
    description = "Minecraft server port UDP"
    direction   = "in"
    protocol    = "udp"
    port        = "25565"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # Voicechat
  rule {
    description = "Voicechat server port UDP"
    direction   = "in"
    protocol    = "udp"
    port        = "24454"
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
