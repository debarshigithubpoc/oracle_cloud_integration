data "oci_core_vcns" "existing_vcns" {
    for_each       = var.oci_core_subnet 
    compartment_id = var.compartment_id_subnet
    display_name   = each.value.vcn_display_name
}