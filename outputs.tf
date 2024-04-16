output "public_ipv4" {
  value = [
    for node in vultr_instance.veilid : node.main_ip
  ]
}

output "public_ipv6" {
  value = [
    for node in vultr_instance.veilid : node.v6_main_ip
  ]
}
