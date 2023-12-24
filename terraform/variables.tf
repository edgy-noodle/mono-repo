variable "domain" {
  type = string
}

variable "scalr_api_token" {
  type      = string
  sensitive = true
}

#variable "proxmox_url" {
#  type = string
#}
#variable "proxmox_token_id" {
#  type      = string
#  sensitive = true
#}
#variable "proxmox_token_secret" {
#  type      = string
#  sensitive = true
#}
#
#variable "cloudflare_api_token" {
#  type      = string
#  sensitive = true
#}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

#variable "gcp_project" {
#  type = string
#}
#variable "gcp_region" {
#  type    = string
#  default = "europe-central2"
#}
#
#variable "betteruptime_api_token" {
#  type      = string
#  sensitive = true
#}
#variable "logtail_api_token" {
#  type      = string
#  sensitive = true
#}