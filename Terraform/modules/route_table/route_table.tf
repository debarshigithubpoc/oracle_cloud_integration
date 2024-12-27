resource "oci_core_route_table" "route_table" {
  for_each = var.route_tables

  display_name   = each.value.display_name
  vcn_id         = data.oci_core_vcns.existing_vcns[each.key].virtual_networks[0].id
  compartment_id = var.compartment_id_route_tables

  dynamic "route_rules" {
    for_each = try(each.value.route_rules, [])
    content {
      destination       = try(route_rules.value.destination, null)
      network_entity_id = each.value.gateway_type == "internet" ? try(data.oci_core_internet_gateways.existing_internet_gateways[each.key].gateways[0].id, null) : try(data.oci_core_service_gateways.existing_service_gateways[each.key].service_gateways[0].id, null)
      description       = try(route_rules.value.description, null)
      destination_type  = try(each.value.destination_type, null)
    }
  }
}
