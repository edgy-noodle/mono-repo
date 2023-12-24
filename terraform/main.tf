terraform {
  required_version = "<= 1.5.7"

  backend "remote" {
    hostname     = "${var.domain}.scalr.io"
    organization = var.domain

    workspaces {
      name = var.scalr_workspace
    }
  }

  required_providers {
    scalr = {
      source  = "Scalr/scalr"
      version = ">= 1.7.0"
    }

#    cloudflare = {
#      source  = "cloudflare/cloudflare"
#      version = ">= 4.20.0"
#    }
#
#    aws = {
#      source  = "hashicorp/aws"
#      version = ">= 5.31.0"
#    }
#    google = {
#      source  = "hashicorp/google"
#      version = ">= 5.10.0"
#    }
  }
}

locals {}

resource "scalr_workspace" "cli-driven" {
  name           = var.scalr_workspace
  environment_id = var.scalr_env_id
  execution_mode = "local"
}

#module "bare-metal" {
#  source = "./modules/bare-metal"
#}