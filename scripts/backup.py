#!/usr/bin/env python3
import os
import subprocess
import time
from datetime import datetime

# Настройки
PROJECT_DIR = "/home/dyuzov/var/www/AppVendor"
BACKUP_DIR = f"{PROJECT_DIR}/backups"
DATE_STR = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
FILENAME = f"{BACKUP_DIR}/auto_part_shop_{DATE_STR}.sql"

# Создаем папку для бэкапов, если её нет
os.makedirs(BACKUP_DIR, exist_ok=True)

print(f"🎒 [{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] Запуск резервного копирования...")

try:
    # Открываем файл на запись и перенаправляем туда вывод команды
    with open(FILENAME, "w") as backup_file:
        result = subprocess.run(
            ["docker", "exec", "-u", "postgres", "pg-node1", "pg_dump", "-d", "auto_part_shop"],
            stdout=backup_file,
            stderr=subprocess.PIPE,
            text=True
        )

    if result.returncode == 0:
        # Считаем размер получившегося файла
        file_size = os.path.getsize(FILENAME) / (1024 * 1024) # Переводим в МБ
        print(f"✅ Бэкап успешно создан: {FILENAME}")
        print(f"📦 Размер файла: {file_size:.2f} MB")
        
        # Ротация: удаляем файлы старше 7 дней
        print("🧹 Очистка старых архивов...")
        now = time.time()
        cutoff = now - (7 * 86400) # 7 дней в секундах

        for file in os.listdir(BACKUP_DIR):
            file_path = os.path.join(BACKUP_DIR, file)
            if os.path.isfile(file_path) and file.endswith(".sql"):
                if os.path.getmtime(file_path) < cutoff:
                    os.remove(file_path)
                    print(f"  🗑️ Удален старый бэкап: {file}")
        print("✨ Всё готово!")
    else:
        print(f"❌ Ошибка при создании бэкапа!\nЛог ошибки: {result.stderr}")
        if os.path.exists(FILENAME):
            os.remove(FILENAME)

except Exception as e:
    print(f"💥 Фатальное исключение в скрипте: {e}")
    if os.path.exists(FILENAME):
        os.remove(FILENAME)