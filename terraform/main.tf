terraform {
  required_version = "<= 1.5.7"

  backend "remote" {
    hostname     = "edgy-noodle.scalr.io"
    organization = "mono-repo"

    workspaces {
      name = "dev"
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
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.31.0"
    }
#    google = {
#      source  = "hashicorp/google"
#      version = ">= 5.10.0"
#    }
  }
}

locals {}

#module "bare-metal" {
#  source = "./modules/bare-metal"
#}