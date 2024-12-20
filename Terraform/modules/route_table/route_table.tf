resource "oci_core_route_table" "route_table" {
  for_each = var.route_tables

  display_name   = each.value.display_name
  vcn_id         = data.oci_core_vcns.existing_vcns[each.key].virtual_networks[0].id
  compartment_id = var.compartment_id_route_tables

  dynamic "route_rules" {
    for_each = try(each.value.route_rules, [])
    content {
      cidr_block        = route_rules.value.cidr_block
      network_entity_id = data.oci_core_internet_gateways.existing_internet_gateways[each.key].id
      description       = try(route_rules.value.description, null)
    }
  }
}