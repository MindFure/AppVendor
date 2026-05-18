<?php
$pageTitle = "Админ-панель";
require_once '../includes/header.php';

if(!isAdmin()) {
    header('Location: /index.php');
    exit;
}

// Статистика
$products_count = $pdo->query("SELECT COUNT(*) FROM products")->fetchColumn();
$orders_count = $pdo->query("SELECT COUNT(*) FROM orders")->fetchColumn();
$users_count = $pdo->query("SELECT COUNT(*) FROM users")->fetchColumn();
?>

<div class="row">
    <div class="col-md-12">
        <h2>Админ-панель</h2>
        <hr>
    </div>
</div>

<div class="row">
    <div class="col-md-4 mb-3">
        <div class="card text-white bg-primary">
            <div class="card-body">
                <h5 class="card-title">Товары</h5>
                <h2><?= $products_count ?></h2>
                <a href="/admin/products.php" class="text-white">Управление →</a>
            </div>
        </div>
    </div>
    <div class="col-md-4 mb-3">
        <div class="card text-white bg-success">
            <div class="card-body">
                <h5 class="card-title">Заказы</h5>
                <h2><?= $orders_count ?></h2>
                <a href="/admin/orders.php" class="text-white">Управление →</a>
            </div>
        </div>
    </div>
    <div class="col-md-4 mb-3">
        <div class="card text-white bg-info">
            <div class="card-body">
                <h5 class="card-title">Пользователи</h5>
                <h2><?= $users_count ?></h2>
                <span class="text-white">Всего зарегистрировано</span>
            </div>
        </div>
    </div>
</div>

<?php require_once '../includes/footer.php'; ?>