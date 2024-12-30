# Oracle Cloud Infrastructure Integration Guide

## Overview
This repository contains infrastructure code for Oracle Cloud integration and Jenkins pipeline configuration.

## Jenkins Pipeline Runner Configurations

### Windows Runner Software Stack
| Software | Purpose |
|----------|---------|
| Terraform | Infrastructure as Code |
| Python | Scripting and Automation |
| OCI CLI | Oracle Cloud Interface |
| Java 21 | Runtime Environment |
| Jenkins | CI/CD Pipeline |

### Linux Runner Software Stack
| Software | Purpose |
|----------|---------|
| kubectl | Kubernetes Control |
| Helm | Package Management |
| Java | Runtime Environment |
| Docker | Containerization |

## SSH Configuration
To configure
To configure

## Some other steps
- Also from jenkins box ssh-keyscan -H linuxrunner to get ssh cert and store it in C:\Users\username\.ssh\known_hosts
- It will look something like this as mentioned down below
....
|1|2uZmcDEYrYcmv/3rQQ0DP31EweY=|l+lYW9b/NlYMfA4XHlt8bkhK8Ro= ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCQF/tT5rbao78XbeHyb2HAhd/bm67FOstQjBOiTghQrRR3XSofB5Z6mVrutUcJ6hYbeodgvGIH4JSQxFvimbe3nuSTtOTQA5oo8tnDdiPk3kRU4imzVuBeEbk+06/PmhdSRR+CocpJHiKb3u/7d68wHCEOSgd5OQDCYquUCGx25udF/uf71v92+QIH1vd/MNU04jkCps7Ko2OjoMFO8NvoCwzw9Vq9cQdEwKx9529eumE43i0M8yxDLE/RPuQS899Kg+5Z4PrKBoHJiBuF3N16ehWzCChp9feajHszLKcy/fWA7i6FONZ6WB4yexe9KMzp1rmaoIVmt22xrrQDz2ABrr7JI8mZOCbqOCfQ4yhXdRiGSvIZkm5R580idTnqtxPCmhsqqBQRhQD/tWancVv0aNaHLPxBci8WmK4X7zjYOIsNCxxz/3ZmaDhJ2CdT7xKDhu3hXWMe+j0UT4P0HHVSb+lNA+/krmhQ3fYlRz+xnarzKq0xRC6WJvUev7eT0t8=

|1|Y9EXuzgQAsK9M7L9LJq80QLSjUs=|WpkLXU6h6KuOtRoUO5vTqp53eOU= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBILx6JIzH7zPsNc8i3SdsRLT81uqxRUnAj0jE1/SGNMNBPNankdGeUXtqFHMOeB8vS1LzRo8Jrl1Y1t7GhsLEwI=

|1|mOLr5swpQJEL2kaEGT9lbWvCM/A=|ec+qg9bf8OZnqZBUJfiwNRILcpg= ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKzk0KcyZ8lswtee/OdmWbOwB5pVUhVPC4B29wylWHVR
....
  
## Install terraform 
- https://developer.hashicorp.com/terraform/install

## Authentication 

## If windows Machine
------------------
- setx TF_VAR_tenancy_ocid <Mention the tenacy id>
- setx TF_VAR_user_ocid <Mention the user ocid>
- setx TF_VAR_fingerprint <Mention the fingerprint>
- setx TF_VAR_private_key_path <Mention the private key path >
- setx TF_VAR_region <Mention the region>
- setx TF_compartment_id_var <Mention the compartment id>

## If Linux Machine
-----------------
- export TF_VAR_tenancy_ocid <Mention the tenacy id>
- export TF_VAR_user_ocid <Mention the user ocid>
- export TF_VAR_fingerprint <Mention the fingerprint>
- export TF_VAR_private_key_path <Mention the private key path >
- export TF_VAR_region <Mention the region>
- export TF_compartment_id_var <Mention the compartment id>

## For Remote Backend use the below Official Documentation 
-------------------------------------------------------
- https://docs.oracle.com/en-us/iaas/Content/terraform/object-storage-state.html

## Create in Container registry in OCI container registry
- Get the region key from https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.html
- docker login region-key.ocir.io/registry-namespace/registry-name
- username: namespace/username
- password: authtoken
- Now we can push the docker image to OCI container registry
- docker build . -t dotnet:v1
- docker tag -t HYD.ocir.io/ax4qhhyy6wvq/privateregistry dotnet:v1
- docker push HYD.ocir.io/ax4qhhyy6wvq/privateregistry/dotnet:v1

## setup Kubernetes 
- sudo yum install kubectl -y
- Install oci cli tool
- bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"
- export PATH=$PATH:/home/jenkins/bin
- source ~/.bashrc
- oci --version
- oci ce cluster create-kubeconfig --cluster-id ocid1.cluster.oc1.ap-hyderabad-1.aaaaaaaacph6wj4vawfoxm6ncgurr2vahr6s4qfmowwkjgzfecd5k4ibnqya --file $HOME/.kube/config --region ap-hyderabad-1 --token-version 2.0.0  --kube-endpoint PUBLIC_ENDPOINT
- vi /home/jenkins/.oci/config > change the fingerprint
- rm /home/jenkins/.oci/oci_api_key.pem replace the pem file with the correct pem file vi /home/jenkins/.oci/oci_api_key.pem with correct signature 
