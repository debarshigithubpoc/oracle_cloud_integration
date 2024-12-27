resource "oci_core_security_list" "security_list" {
  for_each = var.security_lists

  display_name   = each.value.display_name
  vcn_id         = data.oci_core_vcns.existing_vcns[each.key].virtual_networks[0].id
  compartment_id = var.compartment_id_security_lists

  dynamic "ingress_security_rules" {
    for_each = try(each.value.ingress_security_rules, [])
    content {
      source   = ingress_security_rules.value.source
      protocol = ingress_security_rules.value.protocol

      dynamic "icmp_options" {
        for_each = try(ingress_security_rules.value.icmp_options, null) != null ? [ingress_security_rules.value.icmp_options] : []
        content {
          type = icmp_options.value.type
          code = icmp_options.value.code
        }
      }

      dynamic "tcp_options" {
        for_each = try(ingress_security_rules.value.tcp_options, null) != null ? [ingress_security_rules.value.tcp_options] : []
        content {
          min = tcp_options.value.destination_port_range.min
          max = tcp_options.value.destination_port_range.max
        }
      }
    }
  }

  dynamic "egress_security_rules" {
    for_each = try(each.value.egress_security_rules, [])
    content {
      destination = egress_security_rules.value.destination
      protocol    = egress_security_rules.value.protocol

      dynamic "icmp_options" {
        for_each = try(egress_security_rules.value.icmp_options, null) != null ? [egress_security_rules.value.icmp_options] : []
        content {
          type = icmp_options.value.type
          code = icmp_options.value.code
        }
      }

      dynamic "tcp_options" {
        for_each = try(egress_security_rules.value.tcp_options, null) != null ? [egress_security_rules.value.tcp_options] : []
        content {
          min = tcp_options.value.destination_port_range.min
          max = tcp_options.value.destination_port_range.max
        }
      }
    }
  }
}
