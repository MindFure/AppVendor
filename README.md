# 🚗 AutoParts Store

Магазин автозапчастей на чистом PHP (Slim) с полным циклом деплоя: Docker, CI/CD, мониторинг.

## 🚀 Технологии

| Компонент | Технология |
|-----------|-------------|
| Backend | PHP 8.2 + Slim 4 |
| Database | PostgreSQL 15 |
| Web Server | Nginx + PHP-FPM |
| Container | Docker / docker-compose |
| Automation | Ansible |
| CI/CD | GitLab CI |
| Metrics | Prometheus PHP client + Grafana |
| Server Monitoring | Zabbix |

## 📦 Возможности

- ✅ Каталог автозапчастей (CRUD)
- ✅ Поиск по VIN-коду автомобиля
- ✅ Поиск по названию запчасти / OEM-номеру
- ✅ Фильтрация по марке, модели, году
- ✅ Корзина и оформление заказа
- ✅ Админ-панель (управление запчастями, заказами)
- ✅ Docker-контейнеризация
- ✅ Автоматический деплой через GitLab CI
- ✅ Метрики для Prometheus
- ✅ Мониторинг сервера (Zabbix)
- Проверка 123
## 🐳 Быстрый старт (локально)

```bash
git clone https://github.com/yourusername/autoparts-store-php.git
cd autoparts-store-php
cp .env.example .env
docker-compose up -d
docker exec -it autoparts-store-php php vendor/bin/phinx migrate
