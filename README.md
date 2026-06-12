# AppVendor: High Availability E-Commerce Infrastructure

Этот репозиторий содержит исходный код интернет-магазина автозапчастей и полностью автоматизированную, отказоустойчивую инфраструктуру для его развертывания. Проект построен на принципах **Infrastructure as Code (IaC)** с использованием Ansible, Docker и современных DevOps-практик.

## 🚀 Архитектура и Стек технологий

Инфраструктура разделена на логические слои и обеспечивает высокую доступность (High Availability) без единой точки отказа (SPOF) на уровне базы данных.

* **Frontend & Backend:** Nginx, PHP-FPM 
* **High Availability Database Cluster:** PostgreSQL (Zalando Spilo), Patroni, etcd (распределенное хранилище состояний)
* **Load Balancing & Routing:** HAProxy (Layer 4 TCP балансировка с Health Checks)
* **IaC & Automation:** Ansible, Python, Cron
* **CI/CD:** Jenkins
* **Monitoring & Alerting:** Prometheus, Grafana, Node Exporter, Alertmanager

## 📂 Структура репозитория

Репозиторий организован в соответствии с лучшими практиками разделения логики приложения и конфигураций инфраструктуры:

```text
AppVendor/
├── app/                  # Исходный код интернет-магазина (PHP/HTML)
├── configs/              # Изолированные конфигурации сервисов
│   ├── haproxy/          # Настройки балансировщика и панели метрик
│   ├── monitoring/       # Правила Prometheus и Alertmanager
│   └── postgres/         # Специфичные настройки СУБД (pg_hba.conf и др.)
├── deploy/               # Сердце автоматизации IaC
│   └── ansible/          # Плейбуки, шаблоны (Jinja2) и инвентарь для развертывания
├── docker/               # Dockerfile для сборки кастомных образов (Nginx, PHP)
├── scripts/              # Системные утилиты (Watchdog сети, скрипты ротации бэкапов)
├── docker-compose.yml    # Главный декларативный манифест кластера
└── Jenkinsfile           # Пайплайн автоматической сборки и доставки (CI/CD)
🛠 Ключевые особенности инфраструктуры
Отказоустойчивая база данных (Авто-Failover): Кластер СУБД управляется Patroni. В случае падения лидера (pg-node1), etcd фиксирует изменение состояния, и pg-node2 автоматически становится лидером. HAProxy мгновенно перехватывает трафик и направляет его на выжившую ноду. Zero-downtime для пользователей.

Идемпотентный деплой: Вся система разворачивается с нуля одной командой ansible-playbook.

Автоматизация эксплуатации: * Ночные бэкапы БД без остановки контейнеров с автоматической очисткой архивов старше 7 дней.

Демон network_watchdog для непрерывного мониторинга состояния сети и логирования перезагрузок сервера.

Безопасность: Отсутствие хардкода секретов в репозитории (используется .gitignore и локальные .env файлы), строгие права доступа (группа docker).

⚙️ Установка и запуск
Требования
Ubuntu 20.04/22.04 или аналогичный Linux-сервер

Установленный ansible и git

Доступ по SSH (настроенный ключ для Jenkins, если используется CI/CD)

Быстрый старт (Локальное развертывание)
Клонируйте репозиторий:

Bash
git clone [https://github.com/MindFure/AppVendor.git](https://github.com/MindFure/AppVendor.git)
cd AppVendor
Настройте переменные окружения:
Создайте файл .env в корне проекта (по умолчанию исключен из Git) и укажите креды для БД:

Code snippet
DB_USER=myuser
DB_PASSWORD=mypass
DB_NAME=auto_part_shop
Запустите автоматический деплой через Ansible:

Bash
ansible-playbook deploy/ansible/playbook.yml -i deploy/ansible/inventory/hosts.ini -K
Ansible автоматически подготовит директории, скопирует шаблоны скриптов, настроит cron-задачи и поднимет весь кластер через Docker Compose.

📊 Мониторинг и управление
После успешного развертывания вам будут доступны следующие сервисы:

Интернет-магазин: http://<IP_сервера>:80

HAProxy Панель управления: http://<IP_сервера>:7000/stats (Визуализация состояния Patroni-кластера)

Grafana (Дашборды): http://<IP_сервера>:3000

Prometheus: http://<IP_сервера>:9090

👨‍💻 Автор
Dima
DevOps & Infrastructure Engineer | Новосибирск
