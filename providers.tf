terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.50.0-rc.0"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = "2.3.6-alpha1"
    }
  }
}

provider "cloudinit" {
  # Configuration options
}

provider "hcloud" {
  token = var.hcloud_token
}