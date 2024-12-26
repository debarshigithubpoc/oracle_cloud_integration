oci_core_vcns_var = {
  vcn1 = {
    cidr_block   = "10.10.0.0/16"
    display_name = "vcn-prod-001"
  }
  vcn2 = {
    cidr_block   = "10.20.0.0/16"
    display_name = "vcn-prod-002"
  }
}

security_lists_var = {
  public_security_list = {
    display_name     = "public_security_list"
    vcn_display_name = "vcn-prod-001"
    ingress_security_rules = [
      {
        source   = "0.0.0.0/0"
        protocol = "all"
      },
      {
        source   = "10.10.0.0/0"
        protocol = "all"
      }`
    ]
    egress_rules = [
      {
        destination = "0.0.0.0/0"
        protocol    = "all"
      },
      {
        destination = "10.10.0.0/0"
        protocol    = "all"
      }
    ]
  }
}

internet_gateways_var = {
  gw1 = {
    display_name     = "internet_gateway"
    vcn_display_name = "vcn-prod-001"
  }
}

route_tables_var = {
  route_table_1 = {
    display_name                  = "route_table"
    vcn_display_name              = "vcn-prod-001"
    internet_gateway_display_name = "internet_gateway"
    route_rules = [
      {

        cidr_block = "0.0.0.0/0"
      }
    ]
  }
}

network_security_group_var = {
  nsg1 = {
    network_security_group = {
      display_name     = "vcn-prod-001-nsg-001"
      vcn_display_name = "vcn-prod-001"
    }
    nsg_rules = {
      rule1 = {
        direction   = "INGRESS"
        protocol    = "6"
        source_type = "CIDR_BLOCK"
        source      = "0.0.0.0/0"

        tcp_options = {
          destination_port_range = {
            max = 22
            min = 22
          }
        }
      }
    }
  }
}

oci_core_subnets_var = {
  subnet1 = {
    cidr_block       = "10.10.1.0/24"
    display_name     = "vcn-prod-001-snet-001"
    vcn_display_name = "vcn-prod-001"
  }
  subnet2 = {
    cidr_block       = "10.10.2.0/24"
    display_name     = "vcn-prod-001-snet-002"
    vcn_display_name = "vcn-prod-001"
  }
  subnet3 = {
    cidr_block       = "10.10.3.0/24"
    display_name     = "vcn-prod-001-snet-003"
    vcn_display_name = "vcn-prod-001"
  }
}

instances = {
  instance1 = {
    availability_domain      = "MkPu:AP-HYDERABAD-1-AD-1"
    shape                    = "VM.Standard2.1"
    vcn_display_name         = "vcn-prod-001"
    subnet_display_name      = "vcn-prod-001-snet-001"
    nsg_display_name         = "example-nsg"
    image_source_id          = "ocid1.image.oc1.ap-hyderabad-1.aaaaaaaaslydatemd5ndwrvt2zgrrpmcqsde5ly53ew7r7nqonpe2czzy5cq"
    assign_public_ip         = true
    ssh_authorized_keys_path = "public_key/id_rsa.pub"
  }
}

oci_containerengine_clusters_var = {
  cluster1 = {
    kubernetes_version  = "v1.31.1"
    name                = "kub-prod-001"
    vcn_display_name    = "vcn-prod-001"
    subnet_display_name = "vcn-prod-001-snet-002"
    cluster_pod_network_options = {
      cni_type = "OCI_VCN_IP_NATIVE"
    }
    endpoint_config = {
      is_public_ip_enabled = false
    }
  }
}
