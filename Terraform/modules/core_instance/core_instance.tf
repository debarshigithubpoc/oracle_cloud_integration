resource "oci_core_instance" "core_instance" {
  for_each            = var.instances
  availability_domain = each.value.availability_domain
  compartment_id      = var.compartment_core_instance
  shape               = each.value.shape

  create_vnic_details {
    subnet_id        = data.oci_core_subnets.existing_subnets[each.key].subnets[0].id
    assign_public_ip = try(each.value.assign_public_ip, false)
    nsg_ids          = [data.oci_core_network_security_groups.existing_nsgs[each.key].network_security_groups[0].id]
  }

  source_details {
    source_type = "IMAGE"
    source_id   = each.value.image_source_id
  }

  metadata = {
    ssh_authorized_keys = file(each.value.ssh_authorized_keys_path)
  }
}

