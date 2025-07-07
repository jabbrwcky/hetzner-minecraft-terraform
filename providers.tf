terraform {
  required_version = ">=1.10.0"
  
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.50.1"
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
    hcp = {
      source = "hashicorp/hcp"
      version = "0.108.0"
    }
  }
}

provider "hcp" {
  client_id = var.tfsp_client_id
  client_secret = var.tfsp_client_secret
}

provider "cloudinit" {}

provider "hcloud" {
  token = var.hcloud_token
}

provider "dnsimple" {
  token   = var.dnsimple_token
  account = var.dnsimple_account
}