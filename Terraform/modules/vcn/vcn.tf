resource "oci_core_vcn" "vcn" {
  for_each       = var.oci_core_vcn
  compartment_id = var.compartment_id_vcn
  cidr_block     = try(each.value.cidr_block, null)
  display_name   = each.value.display_name
  dns_label      = try(each.value.dns_label, null)
  is_ipv6enabled = try(each.value.is_ipv6enabled, false)
  freeform_tags  = merge(try(each.value.freeform_tags, null), { "Department" = "Finance" })
  defined_tags = merge(try(each.value.defined_tags, {
    "Oracle-Tags.CreatedBy" = "default/debarshi.eee@gmail.com",
    "Oracle-Tags.CreatedOn" = "2024-12-17T08:24:50.176Z"
  }))
}

