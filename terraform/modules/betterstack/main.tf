terraform {
  required_providers {
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