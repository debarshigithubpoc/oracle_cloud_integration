data "oci_core_vcns" "existing_vcns" {
  for_each       = var.route_tables
  compartment_id = var.compartment_id_route_tables
  display_name   = each.value.vcn_display_name
}

data "oci_core_internet_gateways" "existing_internet_gateways" {
  for_each       = var.route_tables
  compartment_id = var.compartment_id_route_tables
  display_name   = each.value.internet_gateway_display_name
  vcn_id         = data.oci_core_vcns.existing_vcns[each.key].virtual_networks[0].id
}