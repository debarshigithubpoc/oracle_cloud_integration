data "oci_core_vcns" "existing_vcns" {
  for_each       = var.service_gateways
  compartment_id = var.compartment_id_service_gateway
  display_name   = each.value.vcn_display_name
}

data "oci_core_services" "all_services_in_oracle_services_network" {
}