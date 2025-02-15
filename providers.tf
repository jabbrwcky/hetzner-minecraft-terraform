terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.50.0-rc.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.6-alpha1"
    }
     dnsimple = {
      source = "dnsimple/dnsimple"
      version = "1.8.0"
    }
  }
}

provider "cloudinit" {
  # Configuration options
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "dnsimple" {
  token = var.dnsimple_token
  account = var.dnsimple_account
}