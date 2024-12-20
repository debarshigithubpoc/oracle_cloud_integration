data "oci_core_vcns" "existing_vcns" {
  for_each       = var.internet_gateway
  compartment_id = var.compartment_id_internet_gateway
  display_name   = each.value.vcn_display_name
}