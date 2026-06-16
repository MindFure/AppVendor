-- Создаем пользователя приложения
CREATE USER myuser WITH PASSWORD 'mypass';

-- Создаем базу данных и назначаем владельца
CREATE DATABASE auto_part_shop OWNER myuser;

-- Выдаем все права пользователю на эту базу
GRANT ALL PRIVILEGES ON DATABASE auto_part_shop TO myuser;