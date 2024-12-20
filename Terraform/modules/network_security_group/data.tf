data "oci_core_vcns" "existing_vcns" {
  compartment_id = var.compartment_network_security_group
  display_name   = var.network_security_group.vcn_display_name
}