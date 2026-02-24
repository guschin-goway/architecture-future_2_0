variable "token" {}
variable "cloud_id" {}
variable "folder_id" {}
variable "zone" {}

variable "public_cidr" {}
variable "private_cidr" {}

variable "image_id" {}

variable "bastion_cores" {
  type    = number
  default = 2
}

variable "bastion_memory" {
  type    = number
  default = 2
}

variable "bastion_disk_size" {
  type    = number
  default = 20
}

variable "app_cores" {
  type    = number
  default = 4
}

variable "app_memory" {
  type    = number
  default = 4
}

variable "app_disk_size" {
  type    = number
  default = 40
}

variable "data_cores" {
  type    = number
  default = 4
}

variable "data_memory" {
  type    = number
  default = 8
}

variable "data_disk_size" {
  type    = number
  default = 100
}