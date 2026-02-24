output "bastion_public_ip" {
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}

output "app_private_ip" {
  value = yandex_compute_instance.app.network_interface.0.ip_address
}

output "data_private_ip" {
  value = yandex_compute_instance.data.network_interface.0.ip_address
}