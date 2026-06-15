output "server_public_ip" {
  description = "Публичный IP-адрес нашего нового сервера"
  # Мы ссылаемся на новое имя ресурса, которое указали в main.tf
  value       = cloudru_evolution_compute_vm.app_vendor_server.interfaces[0].id
}