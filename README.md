## Softwares Intalled in the Jenkins Pipeline Runner
- Terraform
- Python 
- OCI cli
- kubectl 
- docker
- Jave 21
- Jenkins

# oracle_cloud_integration
- All Infrastructure Codes for oracle cloud integration

# Install terraform 
- https://developer.hashicorp.com/terraform/install

# Authentication 

If windows Machine
------------------
- setx TF_VAR_tenancy_ocid <Mention the tenacy id>
- setx TF_VAR_user_ocid <Mention the user ocid>
- setx TF_VAR_fingerprint <Mention the fingerprint>
- setx TF_VAR_private_key_path <Mention the private key path >
- setx TF_VAR_region <Mention the region>
- setx TF_compartment_id_var <Mention the compartment id>

If Linux Machine
-----------------
- export TF_VAR_tenancy_ocid <Mention the tenacy id>
- export TF_VAR_user_ocid <Mention the user ocid>
- export TF_VAR_fingerprint <Mention the fingerprint>
- export TF_VAR_private_key_path <Mention the private key path >
- export TF_VAR_region <Mention the region>
- export TF_compartment_id_var <Mention the compartment id>

For Remote Backend use the below Official Documentation 
-------------------------------------------------------
- https://docs.oracle.com/en-us/iaas/Content/terraform/object-storage-state.html
