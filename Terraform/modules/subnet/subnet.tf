resource "oci_core_subnet" "subnet" {
  for_each            = var.oci_core_subnet
  cidr_block          = each.value.cidr_block
  compartment_id      = var.compartment_id_subnet
  vcn_id              = data.oci_core_vcns.existing_vcns[each.key].virtual_networks[0].id
  availability_domain = try(each.value.availability_domain, null)
  defined_tags = merge(try(each.value.defined_tags, {
    "Oracle-Tags.CreatedBy" = "default/debarshi.eee@gmail.com",
    "Oracle-Tags.CreatedOn" = "2024-12-17"
  }))

  display_name               = each.value.display_name
  dns_label                  = try(each.value.dns_label, null)
  freeform_tags              = merge(try(each.value.freeform_tags, null), { "Department" = "Finance" })
  prohibit_internet_ingress  = try(each.value.prohibit_internet_ingress, false)
  prohibit_public_ip_on_vnic = try(each.value.prohibit_public_ip_on_vnic, false)
  route_table_id             = try(each.value.route_table_id, null)
  security_list_ids          = try(each.value.security_list_ids, null)
}