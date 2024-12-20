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
    }
  }

  dynamic "egress_security_rules" {
    for_each = try(each.value.egress_security_rules, [])
    content {
      destination = egress_security_rules.value.destination
      protocol    = egress_security_rules.value.protocol
    }
  }
}