terraform {
  required_version = ">=1.10.0"
  backend "s3" {
    endpoints = {
      s3 = "https://s3.eu-central-003.backblazeb2.com"
    }
    bucket = "terraform-hh"
    key    = "minecraft/minecraft.tfstate"
    region = "eu-central-003"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.56.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.7"
    }
    dnsimple = {
      source  = "dnsimple/dnsimple"
      version = "1.9.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }
    tailscale = {
      source = "tailscale/tailscale"
      version = "0.24.0"
    }
  }
}

provider "cloudinit" {}

provider "hcloud" {
  token = var.hcloud_token
}

provider "dnsimple" {
  token   = var.dnsimple_token
  account = var.dnsimple_account
}

provider "tailscale" {}
