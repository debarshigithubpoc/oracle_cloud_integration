resource "oci_containerengine_cluster" "test_cluster" {
  for_each           = var.oci_containerengine_cluster
  compartment_id     = var.compartment_id_oci_containerengine_cluster
  kubernetes_version = each.value.kubernetes_version
  name               = each.value.name
  vcn_id             = data.oci_core_vcns.existing_vcns[each.key].virtual_networks[0].id

  cluster_pod_network_options {
    cni_type = each.value.cluster_pod_network_options.cni_type
  }

  endpoint_config {
    is_public_ip_enabled = try(each.value.endpoint_config.is_public_ip_enabled, false)
    nsg_ids              = try(each.value.endpoint_config.nsg_ids, null)
    subnet_id            = data.oci_core_subnets.existing_subnets[each.key].subnets[0].id
  }

  freeform_tags = merge(try(each.value.freeform_tags, null), { "Department" = "Finance" })
  defined_tags = merge(try(each.value.defined_tags, {
    "Oracle-Tags.CreatedBy" = "default/debarshi.eee@gmail.com",
    "Oracle-Tags.CreatedOn" = "2024-12-17"
  }))
}

