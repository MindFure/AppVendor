<?php
$pageTitle = "Главная";
require_once 'includes/header.php';

// Получаем последние товары
$stmt = $pdo->query("SELECT * FROM products ORDER BY created_at DESC LIMIT 6");
$latest_products = $stmt->fetchAll();

// Получаем категории
$categories = $pdo->query("SELECT * FROM categories")->fetchAll();
?>

<div class="hero bg-primary text-white text-center py-5 mb-4 rounded">
    <h1>Добро пожаловать в <?= SITE_NAME ?></h1>
    <p class="lead">Качественные автозапчасти по доступным ценам</p>
    <a href="/pages/catalog.php" class="btn btn-light btn-lg">Перейти в каталог</a>
</div>

<div class="row">
    <div class="col-md-3">
        <div class="card mb-4">
            <div class="card-header">
                <h5>Категории</h5>
            </div>
            <div class="list-group list-group-flush">
                <?php foreach($categories as $cat): ?>
                <a href="/pages/catalog.php?category=<?= $cat['id'] ?>" class="list-group-item list-group-item-action">
                    <?= h($cat['name']) ?>
                </a>
                <?php endforeach; ?>
            </div>
        </div>
    </div>
    
    <div class="col-md-9">
        <h2 class="mb-4">Новинки</h2>
        <div class="row">
            <?php foreach($latest_products as $product): ?>
            <div class="col-md-4 mb-4">
                <div class="card h-100">
                    <img src="/uploads/products/<?= h($product['image'] ?: 'no-image.jpg') ?>" 
                         class="card-img-top" alt="<?= h($product['name']) ?>"
                         style="height: 200px; object-fit: cover;">
                    <div class="card-body">
                        <h5 class="card-title"><?= h($product['name']) ?></h5>
                        <p class="card-text text-primary fw-bold fs-4"><?= number_format($product['price'], 2) ?> ₽</p>
                        <a href="/pages/product.php?id=<?= $product['id'] ?>" class="btn btn-primary">Подробнее</a>
                    </div>
                </div>
            </div>
            <?php endforeach; ?>
        </div>
    </div>
</div>

<?php require_once 'includes/footer.php'; ?>