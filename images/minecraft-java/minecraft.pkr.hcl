packer {
  required_plugins {
    hcloud = {
      source  = "github.com/hetznercloud/hcloud"
      version = "~> 1"
    }
  }
}

locals {
  plugins = [ for plugin in var.plugins :
    "curl --output-dir /home/minecrafter/plugins/${plugin.name} --create-dirs -OL ${plugin.url}"
  ]
}

source "hcloud" "base" {
  image         = "ubuntu-24.04"
  token         = var.hcloud_token
  location      = "fsn1"
  server_type   = "cx22"
  ssh_username  = "root"
  snapshot_name = "papermc-java-ubuntu-24.04-${var.minecraft_version}-${timestamp()}"

  snapshot_labels = {
    "minecraft"         = "java"
    "minecraft_version" = var.minecraft_version
  }

  user_data = <<-EOF
    #cloud-config
    growpart:
      mode: "off"
    resize_rootfs: false
  EOF
}

build {
  hcp_packer_registry {
    bucket_name = "mcpaper-java"
    description = "Mincraft paper server on Ubuntu 24.04"

    bucket_labels = {
      "os"             = "Ubuntu",
      "ubuntu-version" = "24.04",
    }

    build_labels = {
      "build-time"   = timestamp()
      "build-source" = basename(path.cwd)
      "version"      = var.minecraft_version
    }
  }

  source "hcloud.base" {
    name         = "papermc-java"
  }

  provisioner "shell" {
    inline           = ["cloud-init status --wait --long"]
    valid_exit_codes = [0, 2]
  }

  provisioner "file" {
    destination = "/tmp/ghostty.terminfo"
    source      = "../ghostty.terminfo"
  }

  provisioner "shell" {
    script = "scripts/system_setup.sh"
  }
  
  provisioner "shell" {
    script = "scripts/download.sh"
    environment_vars = [
      "MINECRAFT_VERSION=${var.minecraft_version}",
    ]
  }

  dynamic "provisioner" {
    labels = ["shell"]
    for_each = var.plugins
    content {
      inline_shebang = "/bin/sh -ex"
      inline = [
        "curl --output-dir /home/minecrafter/plugins/ --create-dirs -OL ${provisioner.value.url}"
      ]
    }
  }

  provisioner "file"{
    destination = "/home/minecrafter/eula.txt"
    source = "eula.txt"
  }

  provisioner "file"{
    destination = "/home/minecrafter/plugins"
    source = "plugins"
  }

  provisioner "file" {
    source      = "minecraft.service"
    destination = "/tmp/minecraft.service"
  }

  provisioner "shell" {
    script = "scripts/init.sh"
  }

  provisioner "shell" {
    inline = [
      "mv /tmp/minecraft.service /etc/systemd/system/minecraft.service",
      "systemctl daemon-reload",
      "systemctl enable minecraft",
    ]
  }

  provisioner "shell" {
    script = "../scripts/upgrade.sh"
  }

  provisioner "shell" {
    script = "../scripts/cleanup.sh"
  }
  
  post-processor "manifest" {
    output     = "packer_manifest.json"
    strip_path = true
    custom_data = {
      version_fingerprint = packer.versionFingerprint
    }
  }
}
