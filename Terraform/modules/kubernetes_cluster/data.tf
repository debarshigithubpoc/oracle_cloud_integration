data "oci_core_vcns" "existing_vcns" {
  for_each       = var.oci_containerengine_cluster
  compartment_id = var.compartment_id_oci_containerengine_cluster
  display_name   = each.value.vcn_display_name
}

data "oci_core_subnets" "existing_subnets" {
  for_each       = var.oci_containerengine_cluster
  compartment_id = var.compartment_id_oci_containerengine_cluster
  display_name   = each.value.subnet_display_name
  vcn_id         = data.oci_core_vcns.existing_vcns[each.key].virtual_networks[0].id
}
