
terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.14"
    }
  }
}

terraform {
  backend "local" {
    workspace_dir = "/mnt/storage/okd/terraform/cluster"
    path          = "/mnt/storage/okd/terraform/cluster/terraform.tfstate"
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}
