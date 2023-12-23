terraform {
  required_version = ">= 1.6.6"

  backend "remote" {
    hostname = "${local.domain}.scalr.io"
    organization = local.domain

    workspaces {
      name = var.scalr_workspace
    }
  }

  required_providers {
    scalr = {
      source  = "Scalr/scalr"
      version = ">= 1.7.0"
    }

    proxmox = {
      source  = "Telmate/proxmox"
      version = ">= 2.9.14"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4.20.0"
    }

    # HashiCorp
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.31.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 5.10.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.23.0"
    }

    # BetterStackHQ
    logtail = {
      source  = "BetterStackHQ/logtail"
      version = ">= 0.1.14"
    }
    better-uptime = {
      source  = "BetterStackHQ/better-uptime"
      version = ">= 0.5.0"
    }
  }
}

locals {
  domain = "edgy-noodle"
}

provider "scalr" {
  hostname = "${local.domain}.scalr.io"
  token    = var.scalr_api_token
}
resource "scalr_workspace" "cli-driven" {
  name = var.scalr_workspace
  environment_id = var.scalr_env_id
  execution_mode = "local"
}

provider "proxmox" {
  pm_api_url          = var.proxmox_url
  pm_api_token_id     = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "aws" {
  region = var.aws_region
}
provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

provider "betteruptime" {
  api_token = var.betteruptime_api_token
}
provider "logtail" {
  api_token = var.logtail_api_token
}
