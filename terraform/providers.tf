provider "scalr" {
  hostname = "${var.domain}.scalr.io"
}

#provider "proxmox" {
#  pm_api_token_id     = var.proxmox_token_id
#  pm_api_token_secret = var.proxmox_token_secret
#  pm_api_url          = var.proxmox_url
#}
#
#provider "talos" {}
#
#provider "cloudflare" {
#  api_token = var.cloudflare_api_token
#}

provider "aws" {
  region = var.aws_region
}
provider "awscc" {
  region = var.aws_region
}

#provider "google" {
#  project = var.gcp_project
#  region  = var.gcp_region
#}
#
#provider "betteruptime" {
#  api_token = var.betteruptime_api_token
#}
#
#provider "logtail" {
#  api_token = var.logtail_api_token
#}
