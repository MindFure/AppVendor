#!/bin/bash
VM_INTERNAL_IP=$(terraform output -raw vm_internal_ip 2>/dev/null)
EXTERNAL_IP=$(terraform output -raw vm_external_ip 2>/dev/null)

if [ -z "$VM_INTERNAL_IP" ] || [ -z "$EXTERNAL_IP" ]; then
  echo "Ошибка: не удалось получить IP адреса." >&2
  exit 1
fi

# Генерируем inventory файл с динамическим путем
mkdir -p ../ansible/inventory
cat << EOF > ../ansible/inventory/hosts.ini
[webservers]
appvendor-prod ansible_host=${EXTERNAL_IP} ansible_user=dyuzov ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[webservers:vars]
internal_ip=${VM_INTERNAL_IP}
project_root="/home/dyuzov/var/www/AppVendor"
ansible_python_interpreter=/usr/bin/python3
EOF

echo "Inventory сгенерирован для IP: ${EXTERNAL_IP}"