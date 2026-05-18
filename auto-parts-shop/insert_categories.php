<?php
header('Content-Type: text/html; charset=utf-8');
require_once 'config.php';

// Установить кодировку
$pdo->exec("SET client_encoding = 'UTF8'");

// Очищаем таблицы (если нужно)
$pdo->exec("DELETE FROM products");
$pdo->exec("DELETE FROM users");

// Сбрасываем последовательности
$pdo->exec("SELECT setval('products_id_seq', 1, false)");
$pdo->exec("SELECT setval('users_id_seq', 1, false)");

echo "<h2>Вставка данных в таблицу products</h2>";

$products = [
    [
        'name' => 'Масло моторное 5W-30 4л',
        'sku' => 'OIL-001',
        'category_id' => 2, // Масла и жидкости (проверьте ID категории!)
        'price' => 2500.00,
        'quantity' => 50,
        'description' => 'Синтетическое моторное масло для бензиновых и дизельных двигателей',
        'image' => 'oil-5w30.jpg'
    ],
    [
        'name' => 'Масло моторное 10W-40 4л',
        'sku' => 'OIL-002',
        'category_id' => 2, // Масла и жидкости
        'price' => 2200.00,
        'quantity' => 45,
        'description' => 'Полусинтетическое моторное масло',
        'image' => 'oil-10w40.jpg'
    ],
    [
        'name' => 'Фильтр масляный',
        'sku' => 'FIL-001',
        'category_id' => 3, // Фильтры
        'price' => 450.00,
        'quantity' => 100,
        'description' => 'Масляный фильтр для легковых автомобилей',
        'image' => 'oil-filter.jpg'
    ],
    [
        'name' => 'Фильтр воздушный',
        'sku' => 'FIL-002',
        'category_id' => 3, // Фильтры
        'price' => 350.00,
        'quantity' => 80,
        'description' => 'Воздушный фильтр двигателя',
        'image' => 'air-filter.jpg'
    ],
    [
        'name' => 'Фильтр салона',
        'sku' => 'FIL-003',
        'category_id' => 3, // Фильтры
        'price' => 280.00,
        'quantity' => 120,
        'description' => 'Салонный фильтр с активированным углем',
        'image' => 'cabin-filter.jpg'
    ],
    [
        'name' => 'Колодки тормозные передние',
        'sku' => 'BRK-001',
        'category_id' => 4, // Тормозная система
        'price' => 1800.00,
        'quantity' => 30,
        'description' => 'Тормозные колодки для передних колес',
        'image' => 'brake-pads.jpg'
    ],
    [
        'name' => 'Диск тормозной передний',
        'sku' => 'BRK-002',
        'category_id' => 4, // Тормозная система
        'price' => 3200.00,
        'quantity' => 25,
        'description' => 'Вентилируемый тормозной диск',
        'image' => 'brake-disc.jpg'
    ],
    [
        'name' => 'Амортизатор передний',
        'sku' => 'SUS-001',
        'category_id' => 5, // Подвеска
        'price' => 4500.00,
        'quantity' => 20,
        'description' => 'Газомасляный амортизатор',
        'image' => 'shock-absorber.jpg'
    ],
    [
        'name' => 'Сайлентблок',
        'sku' => 'SUS-002',
        'category_id' => 5, // Подвеска
        'price' => 650.00,
        'quantity' => 60,
        'description' => 'Сайлентблок переднего рычага',
        'image' => 'silentblock.jpg'
    ],
    [
        'name' => 'Аккумулятор 60 Ач',
        'sku' => 'ELE-001',
        'category_id' => 6, // Электроника
        'price' => 5500.00,
        'quantity' => 15,
        'description' => 'Автомобильный аккумулятор 60 Ач',
        'image' => 'battery.jpg'
    ],
    [
        'name' => 'Лампа H7',
        'sku' => 'ELE-002',
        'category_id' => 6, // Электроника
        'price' => 350.00,
        'quantity' => 200,
        'description' => 'Галогенная лампа ближнего света',
        'image' => 'lamp-h7.jpg'
    ],
    [
        'name' => 'Свеча зажигания',
        'sku' => 'ELE-003',
        'category_id' => 6, // Электроника
        'price' => 280.00,
        'quantity' => 150,
        'description' => 'Иридиевая свеча зажигания',
        'image' => 'spark-plug.jpg'
    ]
];

$stmt = $pdo->prepare("INSERT INTO products (name, sku, category_id, price, quantity, description, image) VALUES (?, ?, ?, ?, ?, ?, ?)");

foreach ($products as $product) {
    $stmt->execute([
        $product['name'],
        $product['sku'],
        $product['category_id'],
        $product['price'],
        $product['quantity'],
        $product['description'],
        $product['image']
    ]);
    echo "Добавлен товар: " . $product['name'] . "<br>";
}

echo "<br><h2>Вставка данных в таблицу users</h2>";

$users = [
    [
        'username' => 'admin',
        'email' => 'admin@shop.ru',
        'password' => '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'role' => 'admin'
    ],
    [
        'username' => 'user',
        'email' => 'user@mail.ru',
        'password' => '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'role' => 'user'
    ]
];

$stmt = $pdo->prepare("INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)");

foreach ($users as $user) {
    $stmt->execute([
        $user['username'],
        $user['email'],
        $user['password'],
        $user['role']
    ]);
    echo "Добавлен пользователь: " . $user['username'] . " (" . $user['role'] . ")<br>";
}

echo "<br><strong>Готово! Все данные успешно добавлены.</strong>";

// Вывод информации о добавленных записях
$productCount = $pdo->query("SELECT COUNT(*) FROM products")->fetchColumn();
$userCount = $pdo->query("SELECT COUNT(*) FROM users")->fetchColumn();
echo "<br><br>Всего товаров в базе: " . $productCount;
echo "<br>Всего пользователей в базе: " . $userCount;
?>