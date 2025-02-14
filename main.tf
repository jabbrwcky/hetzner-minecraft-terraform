resource "hcloud_primary_ip" "mainv4" {
  name          = "mc-ipv4"
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
  labels = {
    "svc" : "minecraft"
  }
}

resource "hcloud_primary_ip" "mainv6" {
  name          = "mc-ipv6"
  type          = "ipv6"
  assignee_type = "server"
  auto_delete   = false
  labels = {
    "svc" : "minecaft"
  }
}

resource "hcloud_server" "server_test" {
  name        = "test-server"
  image       = "ubuntu-24.04"
  server_type = "cx22"
  labels = {
    "svc" : "minecraft"
  }
  user_data = data.cloudinit_config.minecraft.rendered
  public_net {
    ipv4_enabled = true
    ipv4 = hcloud_primary_ip.mainv4.id
    ipv6_enabled = true
    ipv6 = hcloud_primary_ip.mainv6.id
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