module "vcn" {
  source             = "../../modules/vcn"
  oci_core_vcn       = try(var.oci_core_vcns_var, {})
  compartment_id_vcn = try(var.compartment_id_var, null)
}

module "subnet" {
  source                = "../../modules/subnet"
  oci_core_subnet       = try(var.oci_core_subnets_var, {})
  compartment_id_subnet = try(var.compartment_id_var, null)
  depends_on            = [module.vcn]
}

module "security_lists" {
  source                        = "../../modules/security_list"
  security_lists                = try(var.security_lists_var, {})
  compartment_id_security_lists = try(var.compartment_id_var, null)
  depends_on                    = [module.vcn]
}

module "internet_gateway" {
  source                          = "../../modules/internet_gateway"
  internet_gateway                = try(var.internet_gateways_var, {})
  compartment_id_internet_gateway = try(var.compartment_id_var, null)
  depends_on                      = [module.vcn]
}

module "service_gateway" {
  source                         = "../../modules/service_gateway"
  service_gateways               = try(var.service_gateways_var, {})
  compartment_id_service_gateway = try(var.compartment_id_var, null)
  depends_on                     = [module.vcn]
}

module "route_table" {
  source                      = "../../modules/route_table"
  route_tables                = try(var.route_tables_var, {})
  compartment_id_route_tables = try(var.compartment_id_var, null)
  depends_on                  = [module.internet_gateway, module.service_gateway]
}

module "nsg" {
  source                             = "../../modules/network_security_group"
  for_each                           = try(var.network_security_group_var, {})
  compartment_network_security_group = try(var.compartment_id_var, null)
  network_security_group             = try(each.value.network_security_group, null)
  nsg_rules                          = try(each.value.nsg_rules, null)
  depends_on                         = [module.vcn]
}

module "core_instance" {
  source                    = "../../modules/core_instance"
  instances                 = try(var.instances, {})
  compartment_core_instance = try(var.compartment_id_var, null)
  depends_on                = [module.subnet, module.nsg]
}

module "kubernetes" {
  source                                     = "../../modules/kubernetes_cluster"
  oci_containerengine_cluster                = try(var.oci_containerengine_clusters_var, {})
  compartment_id_oci_containerengine_cluster = try(var.compartment_id_var, null)
  depends_on                                 = [module.subnet]
}
