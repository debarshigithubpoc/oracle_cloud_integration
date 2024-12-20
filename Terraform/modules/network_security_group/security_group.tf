resource "oci_core_network_security_group" "nsg" {
  compartment_id = var.compartment_network_security_group
  vcn_id         = data.oci_core_vcns.existing_vcns.id
  display_name   = var.network_security_group.display_name
}


resource "oci_core_network_security_group_security_rule" "rules" {
  for_each                  = var.nsg_rules
  network_security_group_id = oci_core_network_security_group.nsg.id
  direction                 = each.value.direction
  protocol                  = try(each.value.protocol, null)
  source                    = try(each.value.source, null)
  source_type               = try(each.value.source_type, null)
  destination               = try(each.value.destination, null)
  destination_type          = try(each.value.destination_type, null)
  stateless                 = try(each.value.stateless, null)
  tcp_options {
    destination_port_range {
      max = each.value.tcp_options.destination_port_range.max
      min = each.value.tcp_options.destination_port_range.min
    }
  }
  description = try(each.value.description, null)
}

