#!/usr/bin/env python3
import os
import sys
import subprocess
from datetime import datetime

# Настройки
PROJECT_DIR = "/home/dyuzov/var/www/AppVendor"
LOG_FILE = f"{PROJECT_DIR}/logs/server_status.log"
STATE_FILE = f"{PROJECT_DIR}/scripts/.net_last_state.txt"
TARGET_IP = "8.8.8.8"

# Гарантируем наличие папки для логов
os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)

def log_message(message):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write(f"{timestamp} {message}\n")

def get_uptime():
    try:
        result = subprocess.run(["uptime", "-p"], capture_output=True, text=True, check=True)
        return result.stdout.strip()
    except Exception:
        return "неизвестно"

def check_internet():
    try:
        result = subprocess.run(
            ["ping", "-c", "1", "-W", "3", TARGET_IP],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
        return result.returncode == 0
    except Exception:
        return False

def get_last_state():
    if not os.path.exists(STATE_FILE):
        return "online"
    with open(STATE_FILE, "r", encoding="utf-8") as f:
        return f.read().strip()

def set_state(state):
    with open(STATE_FILE, "w", encoding="utf-8") as f:
        f.write(state)

def main():
    # Проверяем аргументы командной строки
    if len(sys.argv) > 1 and sys.argv[1] == "boot":
        log_message(f"🔄 СЕРВЕР ПЕРЕЗАГРУЗИЛСЯ. Системный аптайм: {get_uptime()}")
        set_state("online")
        sys.exit(0)

    # Обычная проверка по Крону
    is_online = check_internet()
    current_state = "online" if is_online else "offline"
    last_state = get_last_state()

    if current_state == "offline" and last_state == "online":
        log_message(f"❌ ВНИМАНИЕ: Пропал интернет! Не удается пропинговать {TARGET_IP}")
        set_state("offline")
    elif current_state == "online" and last_state == "offline":
        log_message(f"✅ ВОССТАНОВЛЕНИЕ: Интернет снова появился.")
        set_state("online")

if __name__ == "__main__":
    main()