# 1. Провайдер Evolution
terraform {
  required_providers {
    cloudru = {
      source  = "cloud.ru/cloudru/cloud"
      version = "2.0.0"
    }
  }
}

provider "cloudru" {
  auth_key_id = var.access_key
  auth_secret = var.secret_key
  project_id  = "84c2b149-4e26-4eff-807f-e4db3df3b67f" 

  endpoints = {
    iam_endpoint     = "iam.api.cloud.ru:443"
    compute_endpoint = "compute.api.cloud.ru:443"
    vpc_endpoint     = "vpc.api.cloud.ru:443"
  }
}

# 2. Поиск образа
data "cloudru_evolution_compute_image_collection" "ubuntu_img" {
  project_id = "84c2b149-4e26-4eff-807f-e4db3df3b67f"
}

# 3. Читаем и шифруем cloud-init конфигурацию
locals {
  cloud_config = templatefile("${path.module}/cloud-init.yaml.tpl", {
    ssh_public_key = file("~/.ssh/appvendor_key.pub")
    vm_name        = "appvendor-prod"
  })
}

# 4. Создаем диск
resource "cloudru_evolution_compute_disk" "boot_disk" {
  project_id = "84c2b149-4e26-4eff-807f-e4db3df3b67f"
  name       = "appvendor-boot-disk"
  size       = 25
  bootable   = true
  zone_identifier      = { name = "ru.AZ-2" }
  disk_type_identifier = { name = "SSD" }
  image_id             = [for img in data.cloudru_evolution_compute_image_collection.ubuntu_img.images : img.id if img.name == "ubuntu-22.04"][0]
}

# 5. Создаем правильный интерфейс в твоей новой подсети
resource "cloudru_evolution_compute_interface" "app_vendor_port" {
  project_id      = "84c2b149-4e26-4eff-807f-e4db3df3b67f"
  name            = "appvendor-network-port"
  
  # Твой правильный ID подсети subnet-afabea
  subnet_id       = "b1f03ebe-ba0f-4bcd-903d-0cb58c61ca10" 
  
  # Правильная константа из документации!
  type            = "INTERFACE_TYPE_REGULAR"  
  zone_identifier = { name = "ru.AZ-2" }

  # Запрашиваем белый IP-адрес для доступа из интернета
  external_ip_specs = {
    new_external_ip = true
  }
}

# 6. Собираем сервер
resource "cloudru_evolution_compute_vm" "app_vendor_server" {
  project_id = "84c2b149-4e26-4eff-807f-e4db3df3b67f"
  name       = "AppVendor-Production"

  zone_identifier   = { name = "ru.AZ-2" }
  flavor_identifier = { id = "5f71a5d8-073f-4eb8-b9b8-1499c7372819" }

  disk_identifiers = [{ disk_id = cloudru_evolution_compute_disk.boot_disk.id }]
  
  network_interfaces = [{
    interface_id = cloudru_evolution_compute_interface.app_vendor_port.id
  }]

  # Передаем настройки ОС через cloud-init
  cloud_init_userdata = base64encode(local.cloud_config)
}

# 7. Вывод IP-адресов в консоль после создания
output "vm_internal_ip" {
  description = "Внутренний IP адрес"
  value       = cloudru_evolution_compute_interface.app_vendor_port.ip_address
}

output "vm_external_ip" {
  description = "Внешний IP адрес для подключения"
  value       = cloudru_evolution_compute_interface.app_vendor_port.external_ip.ip_address
}