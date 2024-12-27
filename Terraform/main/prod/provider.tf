terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "6.21.0"
    }
  }
}

provider "oci" {
}

terraform {
  backend "http" {
    address       = "https://objectstorage.us-sanjose-1.oraclecloud.com/p/bf640XMjEo6smvwX_N9xCEzv-Y6K4EeuiTF4CznzxjTvbYNE9Qa4qJmc3eKpWNUz/n/axxeo7mon9c6/b/bucket-20240817-1023/o/terraform.prod.tfstate"
    update_method = "PUT"
  }
}