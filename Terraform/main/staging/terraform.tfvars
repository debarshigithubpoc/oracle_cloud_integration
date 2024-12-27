#TODO Associate route tables with subnets 


## OCI Core Virtual Network

oci_core_vcns_var = {
  vcn1 = {
    cidr_block   = "172.0.0.0/16"
    display_name = "oke-k8sstg-vcn-vnet"
  }
}

## OCI Core Subnets
oci_core_subnets_var = {
  ## subnet for k8s service load balancer hence public access is allowed
  subnet1 = {
    cidr_block                 = "172.0.20.0/24"
    display_name               = "oke-k8sstg-svclb-subnet"
    vcn_display_name           = "oke-k8sstg-vcn-vnet"
    prohibit_public_ip_on_vnic = false
    prohibit_internet_ingress  = false
  }
  ## Subnet for k8s worker nodes hence public access is blocked 
  subnet2 = {
    cidr_block                 = "172.0.10.0/24"
    display_name               = "oke-k8sstg-node-subnet"
    vcn_display_name           = "oke-k8sstg-vcn-vnet"
    prohibit_public_ip_on_vnic = true
    prohibit_internet_ingress  = true
  }
  ## Subnet for k8s API endpoint hence public access is blocked 
  subnet3 = {
    cidr_block                 = "172.0.0.0/28"
    display_name               = "oke-k8sstg-ApiEndpoint-subnet"
    vcn_display_name           = "oke-k8sstg-vcn-vnet"
    prohibit_public_ip_on_vnic = true
    prohibit_internet_ingress  = true
  }
}

## OCI Core Security Lists
security_lists_var = {
  oke_nodeseclist = {
    display_name     = "oke-node-sec-list"
    vcn_display_name = "oke-k8sstg-vcn-vnet"
    ingress_security_rules = [
      {
        protocol = "all"
        source   = "172.0.10.0/24"
      },
      {
        protocol = "1"
        source   = "172.0.0.0/28"
        icmp_options = {
          type = 3
          code = 4
        }
      },
      {
        protocol = "6"
        source   = "172.0.0.0/28"
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
        destination = "172.0.10.0/24"
      },
      {
        protocol    = "6"
        destination = "172.0.0.0/28"
        tcp_options = {
          destination_port_range = {
            min = 6443
            max = 6443
          }
        }
      },
      {
        protocol    = "6"
        destination = "172.0.0.0/28"
        tcp_options = {
          destination_port_range = {
            min = 12250
            max = 12250
          }
        }
      },
      {
        protocol    = "1"
        destination = "172.0.0.0/28"
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
    display_name     = "oke-k8sstgApiEndpoint-sec-list"
    vcn_display_name = "oke-k8sstg-vcn-vnet"
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
        source   = "172.0.10.0/24"
        tcp_options = {
          destination_port_range = {
            min = 6443
            max = 6443
          }
        }
      },
      {
        protocol = "6"
        source   = "172.0.10.0/24"
        tcp_options = {
          destination_port_range = {
            min = 12250
            max = 12250
          }
        }
      },
      {
        protocol = "1"
        source   = "172.0.10.0/24"
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
        destination = "172.0.10.0/24"
      },
      {
        protocol    = "1"
        destination = "172.0.10.0/24"
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
    display_name     = "oke-k8sstg-igw"
    vcn_display_name = "oke-k8sstg-vcn-vnet"
  }
}

## OCI Core Service Gateways
service_gateways_var = {
  sgw1 = {
    display_name     = "oke-k8sstg-svc-gw"
    vcn_display_name = "oke-k8sstg-vcn-vnet"
  }
}