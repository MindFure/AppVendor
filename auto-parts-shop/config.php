<?php
ob_start();
session_start();

// Настройки базы данных PostgreSQL
$ip = trim(shell_exec('hostname -I'));
define('DB_HOST', 'haproxy');
define('DB_PORT', '5432');
define('DB_NAME', 'auto_part_shop');
define('DB_USER', 'myuser');
define('DB_PASS', 'mypass');

// Подключение к PostgreSQL
try {
    $pdo = new PDO(
        "pgsql:host=" . DB_HOST . ";port=" . DB_PORT . ";dbname=" . DB_NAME,
        DB_USER,
        DB_PASS,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false
        ]
    );
    
    // !!! ВАЖНО: Устанавливаем клиентскую кодировку в UTF-8 !!!
    $pdo->exec("SET client_encoding = 'UTF8'");
    
    // Для отладки - можно проверить текущую кодировку (закомментировать после проверки)
    // $result = $pdo->query("SHOW client_encoding")->fetch();
    // error_log("Client encoding: " . print_r($result, true));
    
} catch(PDOException $e) {
    die("Ошибка подключения к БД: " . $e->getMessage());
}

// Остальной код без изменений...
define('SITE_NAME', 'AutoParts Shop');
$protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? 'https://' : 'http://';
$host = $_SERVER['HTTP_HOST'];
define('SITE_URL', $protocol . $host . '/auto-parts-shop');

function h($str) {
    return htmlspecialchars($str, ENT_QUOTES, 'UTF-8');
}

function isLoggedIn() {
    return isset($_SESSION['user_id']);
}

function isAdmin() {
    return isset($_SESSION['user_role']) && $_SESSION['user_role'] === 'admin';
}
?>
