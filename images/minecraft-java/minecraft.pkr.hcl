packer {
  required_plugins {
    hcloud = {
      source  = "github.com/hetznercloud/hcloud"
      version = "~> 1"
    }
  }
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

variable "minecraft_version" {
  description = "Minecraft version to install"
  type = string
  default = "1.21.4"
}

source "hcloud" "base" {
  image = "ubuntu-24.04"
  token = try(var.hcloud_token)
  location = "fsn1"
  server_type = ""
  ssh_username = "root"
}

build {
    hcp_packer_registry {
    bucket_name = "mcpaper-java"
    description = "Mincraft paper server on Ubuntu 24.04"

    bucket_labels = {
      "os"             = "Ubuntu",
      "ubuntu-version" = "24.04",
*    }

    build_labels = {
      "build-time"   = timestamp()
      "build-source" = basename(path.cwd)
    }
  }

  sources = ["sourcehcloud.base"]
  snapshot_name = "papermc-java-ubuntu-24.04"
  snapshot_description = "Minecraft Java Edition on Ubuntu 24.04"
  snapshot_labels = {
    "minecraft" = "java"
    "minecraft_version" = "1.21.4"

  }

  user_data = file("../cloud-init.yml")

  provisioner "shell" {
    script = templatefile("download.sh.tftpl", {
      minecraft_version = var.minecraft_version,
      plugins = var.plugins
    })
  }

  dynamic "provisioner" {
    for_each = var.plugins
    content {
      inline = [
        "curl -o /home/minecrafter/plugins/${provisioner.value.name}.jar ${provisioner.value.url}",
        "chown minecrafter:minecrafter /home/minecrafter/plugins/${provisioner.value.name}.jar",
      ]
    }
  }

  provisioner "file" {
    source      = minecraft.service
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
