terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.90"
    }
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

resource "yandex_vpc_network" "main" {
  name = "future2-network"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.public_cidr]
}

resource "yandex_vpc_subnet" "private" {
  name           = "private-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.private_cidr]
}

resource "yandex_vpc_security_group" "main_sg" {
  name       = "future2-sg"
  network_id = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_instance" "bastion" {
  name = "bastion-host"

  resources {
    cores  = var.bastion_cores
    memory = var.bastion_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.bastion_disk_size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.main_sg.id]
  }
}

resource "yandex_compute_instance" "app" {
  name = "application-server"

  resources {
    cores  = var.app_cores
    memory = var.app_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.app_disk_size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.main_sg.id]
  }
}

resource "yandex_compute_instance" "data" {
  name = "data-node"

  resources {
    cores  = var.data_cores
    memory = var.data_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.data_disk_size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.main_sg.id]
  }
}