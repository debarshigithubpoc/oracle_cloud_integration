resource "oci_core_service_gateway" "service_gateway" {
  for_each       = var.service_gateways
  display_name   = each.value.display_name
  compartment_id = var.compartment_id_service_gateway
  vcn_id         = data.oci_core_vcns.existing_vcns[each.key].virtual_networks[0].id

  services {
    service_id = data.oci_core_services.all_services_in_oracle_services_network.services[1].id
  }
}
