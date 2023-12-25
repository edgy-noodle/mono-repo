variable "pm_k8s_nodes" {
  type = map(object({
    count = number
    cidr  = string
  }))
  default = {
    "cpn" = {
      count = 3
      cidr  = "192.168.1.200/29",
    }
    "workers" = {
      count = 6
      cidr  = "192.168.1.208/29"
    }
  }

  validation {
    condition = alltrue([
      for node, config in var.pm_k8s_nodes : (
        contains(["cpn", "workers"], node) &&
        can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))$", config.cidr))
    )])
    error_message = "Must specify a valid CIDR for keys \"cpn\" and/or \"workers\"."
  }
}

locals {
  # Generate a list of objects with node and IP based on specified counts and CIDRs
  vms = flatten([
    for node, config in var.pm_k8s_nodes : [
      for octet in range(config.count) : {
        no      = octet
        node    = node
        address = cidrhost(config.cidr, octet)
      }
    ]
  ])
}
