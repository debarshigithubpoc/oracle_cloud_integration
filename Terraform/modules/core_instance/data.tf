data "oci_core_vcns" "existing_vcns" {
  for_each       = var.instances
  compartment_id = var.compartment_core_instance
  display_name   = each.value.vcn_display_name
}

data "oci_core_subnets" "existing_subnets" {
  for_each       = var.instances
  compartment_id = var.compartment_core_instance
  display_name   = each.value.subnet_display_name
  vcn_id         = data.oci_core_vcns.existing_vcns[each.key].virtual_networks[0].id
}

data "oci_core_network_security_groups" "existing_nsgs" {
  for_each       = var.instances
  compartment_id = var.compartment_core_instance
  display_name   = each.value.nsg_display_name
  vcn_id         = data.oci_core_vcns.existing_vcns[each.key].virtual_networks[0].id
}