#TODO Associate route tables with subnets 


## OCI Core Virtual Network

oci_core_vcns_var = {
  vcn1 = {
    cidr_block   = "10.0.0.0/16"
    display_name = "oke-k8sdev-vcn-vnet"
  }
}

## OCI Core Subnets
oci_core_subnets_var = {
  ## subnet for k8s service load balancer hence public access is allowed
  subnet1 = {
    cidr_block                 = "10.0.20.0/24"
    display_name               = "oke-k8sdev-svclb-subnet"
    vcn_display_name           = "oke-k8sdev-vcn-vnet"
    prohibit_public_ip_on_vnic = false
    prohibit_internet_ingress  = false
  }
  ## Subnet for k8s worker nodes hence public access is blocked 
  subnet2 = {
    cidr_block                 = "10.0.10.0/24"
    display_name               = "oke-k8sdev-node-subnet"
    vcn_display_name           = "oke-k8sdev-vcn-vnet"
    prohibit_public_ip_on_vnic = true
    prohibit_internet_ingress  = true
  }
  ## Subnet for k8s API endpoint hence public access is blocked 
  subnet3 = {
    cidr_block                 = "10.0.0.0/28"
    display_name               = "oke-k8sdev-ApiEndpoint-subnet"
    vcn_display_name           = "oke-k8sdev-vcn-vnet"
    prohibit_public_ip_on_vnic = true
    prohibit_internet_ingress  = true
  }
}

## OCI Core Security Lists
security_lists_var = {
  oke_nodeseclist = {
    display_name     = "oke-node-sec-list"
    vcn_display_name = "oke-k8sdev-vcn-vnet"
    ingress_security_rules = [
      {
        protocol = "all"
        source   = "10.0.10.0/24"
      },
      {
        protocol = "1"
        source   = "10.0.0.0/28"
        icmp_options = {
          type = 3
          code = 4
        }
      },
      {
        protocol = "6"
        source   = "10.0.0.0/28"
      },
      {
        protocol = "6"
        source   = "0.0.0.0/0"
        tcp_options = {
          destination_port_range = {
            min = 22
            max = 22
          }
        }
      }
    ]
    egress_security_rules = [
      {
        protocol    = "all"
        destination = "10.0.10.0/24"
      },
      {
        protocol    = "6"
        destination = "10.0.0.0/28"
        tcp_options = {
          destination_port_range = {
            min = 6443
            max = 6443
          }
        }
      },
      {
        protocol    = "6"
        destination = "10.0.0.0/28"
        tcp_options = {
          destination_port_range = {
            min = 12250
            max = 12250
          }
        }
      },
      {
        protocol    = "1"
        destination = "10.0.0.0/28"
        icmp_options = {
          type = 3
          code = 4
        }
      },
      {
        protocol    = "6"
        destination = "0.0.0.0/0"
        tcp_options = {
          destination_port_range = {
            min = 443
            max = 443
          }
        }
      },
      {
        protocol    = "all"
        destination = "0.0.0.0/0"
      }
    ]
  }

  oke_k8sApiEndpoint_seclist = {
    display_name     = "oke-k8sdevApiEndpoint-sec-list"
    vcn_display_name = "oke-k8sdev-vcn-vnet"
    ingress_security_rules = [
      {
        protocol = "6"
        source   = "0.0.0.0/0"
        tcp_options = {
          destination_port_range = {
            min = 6443
            max = 6443
          }
        }
      },
      {
        protocol = "6"
        source   = "10.0.10.0/24"
        tcp_options = {
          destination_port_range = {
            min = 6443
            max = 6443
          }
        }
      },
      {
        protocol = "6"
        source   = "10.0.10.0/24"
        tcp_options = {
          destination_port_range = {
            min = 12250
            max = 12250
          }
        }
      },
      {
        protocol = "1"
        source   = "10.0.10.0/24"
        icmp_options = {
          type = 3
          code = 4
        }
      }
    ]
    egress_security_rules = [
      {
        protocol    = "6"
        destination = "0.0.0.0/0"
        tcp_options = {
          destination_port_range = {
            min = 443
            max = 443
          }
        }
      },
      {
        protocol    = "6"
        destination = "10.0.10.0/24"
      },
      {
        protocol    = "1"
        destination = "10.0.10.0/24"
        icmp_options = {
          type = 3
          code = 4
        }
      }
    ]
  }
}

## OCI Core Internet Gateways
internet_gateways_var = {
  gw1 = {
    display_name     = "oke-k8sdev-igw"
    vcn_display_name = "oke-k8sdev-vcn-vnet"
  }
}

## OCI Core Service Gateways
service_gateways_var = {
  sgw1 = {
    display_name     = "oke-k8sdev-svc-gw"
    vcn_display_name = "oke-k8sdev-vcn-vnet"
  }
}

## Imported route table copy the ocid as resource id of the route table 
## terraform.exe import "module.route_table.oci_core_route_table.route_table[\"route_table_1\"]" ocid1.routetable.oc1.ap-hyderabad-1.aaaaaaaajlckzyxxn36spfcqt6fkg6kbtbx2c6yqvzk33jlx73nlobaegnwq
## OCI Core Route tabels for private and public subnet
route_tables_var = {
  route_table_1 = {
    display_name     = "oke-k8sdev-private-routetable"
    vcn_display_name = "oke-k8sdev-vcn-vnet"
    gateway_type     = "service"
    route_rules = [
      {
        destination      = "all-hyd-services-in-oracle-services-network"
        description      = "Route rule for Service gateway"
        destination_type = "SERVICE_CIDR_BLOCK"
      }
    ]
  }

  route_table_2 = {
    display_name     = "oke-k8sdev-public-routetable"
    vcn_display_name = "oke-k8sdev-vcn-vnet"
    gateway_type     = "internet"
    route_rules = [
      {
        destination                   = "0.0.0.0/0"
        description                   = "Route rule for NAT gateway"
        internet_gateway_display_name = "oke-k8sdev-igw"
        destination_type              = "CIDR_BLOCK"
      }
    ]
  }
}

## K8S Cluster for OCI Container Engine
oci_containerengine_clusters_var = {
  quick-cluster1 = {
    name                = "oke-k8sdev-cluster1"
    kubernetes_version  = "v1.31.1"
    vcn_display_name    = "oke-k8sdev-vcn-vnet"
    subnet_display_name = "oke-k8sdev-ApiEndpoint-subnet"
    cluster_pod_network_options = {
      cni_type = "OCI_VCN_IP_NATIVE"
    }
    endpoint_config = {
      is_public_ip_enabled = false
    }
  }
}

## Jumpbox to connect to K8s Cluster
instances = {
  instance1 = {
    availability_domain      = "MkPu:AP-HYDERABAD-1-AD-1"
    shape                    = "VM.Standard2.1"
    vcn_display_name         = "oke-k8sdev-vcn-vnet"
    subnet_display_name      = "oke-k8sdev-svclb-subnet"
    image_source_id          = "ocid1.image.oc1.ap-hyderabad-1.aaaaaaaaslydatemd5ndwrvt2zgrrpmcqsde5ly53ew7r7nqonpe2czzy5cq"
    assign_public_ip         = true
    ssh_authorized_keys_path = "C:/jenkins_workspace/oracle_cloud_integration/Terraform/main/dev/public_key/id_rsa.pub"
  }
}
## ssh opc@140.245.217.53 -i ~/.ssh/id_rsa
## Install necessary tools
## sudo dnf -y install oraclelinux-developer-release-el8
## sudo dnf install python36-oci-cli
## oci setup config
## 


# network_security_group_var = {
#   nsg1 = {
#     network_security_group = {
#       display_name     = "vcn-dev-001-nsg-001"
#       vcn_display_name = "vcn-dev-001"
#     }
#     nsg_rules = {
#       rule1 = {
#         direction   = "INGRESS"
#         protocol    = "6"
#         source_type = "CIDR_BLOCK"
#         source      = "0.0.0.0/0"

#         tcp_options = {
#           destination_port_range = {
#             max = 22
#             min = 22
#           }
#         }
#       }
#     }
#   }
# }