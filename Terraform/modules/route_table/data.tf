data "oci_core_vcns" "existing_vcns" {
  for_each       = var.route_tables
  compartment_id = var.compartment_id_route_tables
  display_name   = each.value.vcn_display_name
}

data "oci_core_internet_gateways" "existing_internet_gateways" {
  for_each       = { for k, v in var.route_tables : k => v if v.gateway_type == "internet" }
  compartment_id = var.compartment_id_route_tables
  display_name   = try(each.value.internet_gateway_display_name, "oke-k8s-igw")
  vcn_id         = data.oci_core_vcns.existing_vcns[each.key].virtual_networks[0].id
}

data "oci_core_service_gateways" "existing_service_gateways" {
  for_each       = { for k, v in var.route_tables : k => v if v.gateway_type == "service" }
  compartment_id = var.compartment_id_route_tables
  vcn_id         = data.oci_core_vcns.existing_vcns[each.key].virtual_networks[0].id
}