packer {
  required_plugins {
    hcloud = {
      source  = "github.com/hetznercloud/hcloud"
      version = "~> 1"
    }
  }
}

variable "hcloud_token" {
  type      = string
  sensitive = true
  default   = "${env("HCLOUD_TOKEN")}"
}

variable "plugins" {
  description = "List of plugins to install"
  type = list(object({
    name        = string
    url         = string
    configfiles = list(string)
  }))

  default = []
}

variable "minecraft_version" {
  description = "Minecraft version to install"
  type        = string
  default     = "1.21.4"
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

  user_data = file("cloud-init.yaml")
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
    }
  }

  source "hcloud.base" {
    name         = "papermc-java"
  }
  provisioner "shell" {
    execute_command = "echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    inline = [
      "cloud-init status --wait",
    ]
  }

  provisioner "shell" {
    script = "download.sh"
    environment_vars = [
      "MINECRAFT_VERSION=${var.minecraft_version}",
    ]
  }

  # provisioner "shell" {
  #   inline = templatefile("download_plugins.pkrtpl.hcl", {
  #     minecraft_version = var.minecraft_version,
  #     plugins           = var.plugins
  #   })
  # }

  provisioner "file" {
    source      = "minecraft.service"
    destination = "/tmp/minecraft.service"
  }

  provisioner "shell" {
    inline = [
      "mv /tmp/minecraft.service /etc/systemd/system/minecraft.service",
      "systemctl daemon-reload",
      "systemctl enable minecraft",
    ]
  }

  provisioner "shell" {
    script = "../cleanup.sh"
  }
}
