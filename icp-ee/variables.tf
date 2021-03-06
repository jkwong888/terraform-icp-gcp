variable "instance_name" {
  description = "Name of the ICP installation, will be used as basename for VMs"
  default     = "icp"
}

variable "region" {
  default = "us-central1"
}

variable "project" {
  default = ""
}

variable "zones" {
  type = "list"
  default = [ "a", "b", "c" ]
}

variable "ssh_user" {
  default = "icpdeploy"
}

variable "ssh_key" {
  default = ""
}

variable "subnet_cidr" {
  description = "VPC subnetwork CIDR "
  default = "10.20.0.0/20"
}

variable "pod_network_cidr" {
  description = "Pod network CIDR "
  default     = "172.20.0.0/16"
}

variable "service_network_cidr" {
  description = "Service network CIDR "
  default     = "172.21.0.0/16"
}


variable "image" {
  default = {
    project = "ubuntu-os-cloud"
    family = "ubuntu-1604-lts"
  }
}

variable "boot" {
  type = "map"

  default = {
    nodes         = 1
    cpu           = 2
    memory        = 4096

    disk_size           = 100   # Specify size or leave empty to use same size as template.
    docker_disk_size    = 100   # Specify size for docker disk, default 100.
  }
}

variable "master" {
  type = "map"

  default = {
    nodes         = 3
    cpu           = 8
    memory        = 32768

    disk_size           = 100   # Specify size or leave empty to use same size as template.
    docker_disk_size    = 100   # Specify size for docker disk, default 100.
  }
}

variable "proxy" {
  type = "map"

  default = {
    nodes         = 0
    cpu           = 2
    memory        = 4096

    disk_size           = 100   # Specify size or leave empty to use same size as template.
    docker_disk_size    = 100   # Specify size for docker disk, default 100.
  }
}

variable "management" {
  type = "map"

  default = {
    nodes         = 3
    cpu           = 4
    memory        = 16384

    disk_size           = 100   # Specify size or leave empty to use same size as template.
    docker_disk_size    = 100   # Specify size for docker disk, default 100.
  }
}

variable "va" {
  type    = "map"

  default = {
    nodes         = 3
    cpu           = 8
    memory        = 16384

    disk_size           = 100   # Specify size or leave empty to use same size as template.
    docker_disk_size    = 100   # Specify size for docker disk, default 100.
  }
}

variable "worker" {
  type = "map"

  default = {
    nodes         = 3
    image         = "ubuntu-1604-lts"
    cpu           = 4
    memory        = 16384

    disk_size           = 100      # Specify size or leave empty to use same size as template.
    docker_disk_size    = 100   # Specify size for docker disk, default 100.
  }
}

variable "docker_package_location" {
  description = "URI for docker package location, e.g. http://<myhost>/icp-docker-17.09_x86_64.bin or nfs:<myhost>/icp-docker-17.09_x86_64.bin"
  default     = ""
}

variable "image_location" {
  description = "URI for image package location, e.g. http://<myhost>/ibm-cloud-private-x86_64-2.1.0.2.tar.gz or nfs:<myhost>/ibm-cloud-private-x86_64-2.1.0.2.tar.gz"
  default     = ""
}

variable "icppassword" {
  description = "Password for the initial admin user in ICP; blank to generate"
  default     = ""
}

variable "icp_inception_image" {
  description = "ICP image to use for installation"
  default     = "ibmcom/icp-inception-amd64:3.1.0-ee"
}

variable "cluster_cname" {
  default = ""
}

variable "registry_server" {
  default   = ""
}

variable "registry_username" {
  default   = ""
}

variable "registry_password" {
  default   = ""
}

variable "service_account_email" {
  description = "The service account email address to attach to all compute instances, leave blank to use the default service account"
  default = ""
}

# The following services can be disabled for 3.1
# custom-metrics-adapter, image-security-enforcement, istio, metering, monitoring, service-catalog, storage-minio, storage-glusterfs, and vulnerability-advisor
variable "disabled_management_services" {
  description = "List of management services to disable"
  type        = "list"
  default     = ["istio", "vulnerability-advisor", "storage-glusterfs", "storage-minio"]
}
