<?php
$pageTitle = "Управление товарами";
require_once '../includes/header.php';

if(!isAdmin()) {
    header('Location: /index.php');
    exit;
}

// Добавление/редактирование товара
if($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['save'])) {
    $id = (int)($_POST['id'] ?? 0);
    $name = trim($_POST['name']);
    $sku = trim($_POST['sku']);
    $category_id = (int)$_POST['category_id'];
    $price = (float)$_POST['price'];
    $quantity = (int)$_POST['quantity'];
    $description = trim($_POST['description']);
    
    if($id > 0) {
        // Обновление
        $stmt = $pdo->prepare("UPDATE products SET name=?, sku=?, category_id=?, price=?, quantity=?, description=? WHERE id=?");
    }}