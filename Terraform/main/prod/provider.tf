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
    address       = "https://ax4qhhyy6wvq.objectstorage.ap-hyderabad-1.oci.customer-oci.com/p/wZnpMrVTbMJWtt3lC85gOMcGn05KtldL0BKF0V-eSs9OuBxT9LBkYCRp4Idx_7RK/n/ax4qhhyy6wvq/b/terraform-bucket/o/terraform.prod.tfstate"
    update_method = "PUT"
  }
}