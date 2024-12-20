data "oci_core_vcns" "existing_vcns" {
  for_each       = var.security_lists
  compartment_id = var.compartment_id_security_lists
  display_name   = each.value.vcn_display_name
}