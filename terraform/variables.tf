variable "domain" {
  type = string
}

variable "slack_channel_name" {
  type    = string
  default = "alerts-scalr"
}
variable "slack_account_id" {
  type = string
}
variable "slack_channel_id" {
  type = string
}
variable "slack_events" {
  type    = list(string)
  default = ["run_approval_required", "run_success", "run_errored"]
}

variable "scalr_api_token" {
  type      = string
  sensitive = true
}
variable "scalr_env_id" {
  type = string
}
variable "scalr_workspace_id" {
  type = string
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