resource "oci_core_internet_gateway" "internet_gateway" {
  for_each       = var.internet_gateway
  display_name   = each.value.display_name
  vcn_id         = data.oci_core_vcns.existing_vcns[each.key].virtual_networks[0].id
  compartment_id = var.compartment_id_internet_gateway
}

