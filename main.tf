terraform {
  required_version = ">= 1.5.0"

  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = ">= 2.19"
    }
  }
}

locals {
  # for a full list of regions, you can check out the API endpoint at https://www.vultr.com/api/#tag/region/operation/list-regions
  regions = [
    "scl", # Santiago, Chile
    "jnb", # Johannesburg, South Africa
  ]
}

resource "vultr_instance" "veilid" {
  for_each = toset(local.regions)
  plan     = "vc2-1c-1gb"
  region   = each.key
  os_id    = 1743

  label    = "veilid-node-${each.key}"
  hostname = "veilid-node-${each.key}"

  user_data = file("./setup-veilid.yaml")

  enable_ipv6      = true
  activation_email = false

  firewall_group_id = vultr_firewall_group.veilid.id
}

resource "vultr_firewall_group" "veilid" {
  description = "veilid-firewall"
}


resource "vultr_firewall_rule" "tcp_ipv4_22" {
  firewall_group_id = vultr_firewall_group.veilid.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "22"
  notes             = "allow ssh via ipv4"
}

resource "vultr_firewall_rule" "tcp_ipv6_22" {
  firewall_group_id = vultr_firewall_group.veilid.id
  protocol          = "tcp"
  ip_type           = "v6"
  subnet            = "::"
  subnet_size       = 0
  port              = "22"
  notes             = "allow ssh via ipv6"
}

resource "vultr_firewall_rule" "tcp_ipv4_5150" {
  firewall_group_id = vultr_firewall_group.veilid.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "5150"
  notes             = "allow tcp for ipv4 on 5150"
}


resource "vultr_firewall_rule" "tcp_ipv6_5150" {
  firewall_group_id = vultr_firewall_group.veilid.id
  protocol          = "tcp"
  ip_type           = "v6"
  subnet            = "::"
  subnet_size       = 0
  port              = "5150"
  notes             = "allow tcp for ipv6 on 5150"
}


resource "vultr_firewall_rule" "udp_ipv4_5150" {
  firewall_group_id = vultr_firewall_group.veilid.id
  protocol          = "udp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "5150"
  notes             = "allow udp for ipv4 on 5150"
}


resource "vultr_firewall_rule" "udp_ipv6_5150" {
  firewall_group_id = vultr_firewall_group.veilid.id
  protocol          = "udp"
  ip_type           = "v6"
  subnet            = "::"
  subnet_size       = 0
  port              = "5150"
  notes             = "allow udp for ipv6 on 5150"
}
