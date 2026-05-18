<?php
$pageTitle = "Каталог";
require_once '../includes/header.php';

$category_id = isset($_GET['category']) ? (int)$_GET['category'] : null;

// Формируем запрос
$sql = "SELECT p.*, c.name as category_name 
        FROM products p 
        LEFT JOIN categories c ON p.category_id = c.id 
        WHERE 1=1";
$params = [];

if($category_id) {
    $sql .= " AND p.category_id = ?";
    $params[] = $category_id;
}

$sql .= " ORDER BY p.created_at DESC";
$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$products = $stmt->fetchAll();

// Получаем категории для фильтра
$categories = $pdo->query("SELECT * FROM categories")->fetchAll();
?>

<div class="row">
    <div class="col-md-3">
        <div class="card">
            <div class="card-header">
                <h5>Фильтры</h5>
            </div>
            <div class="card-body">
                <form method="get">
                    <label class="form-label">Категория</label>
                    <select name="category" class="form-select" onchange="this.form.submit()">
                        <option value="">Все категории</option>
                        <?php foreach($categories as $cat): ?>
                        <option value="<?= $cat['id'] ?>" <?= $category_id == $cat['id'] ? 'selected' : '' ?>>
                            <?= h($cat['name']) ?>
                        </option>
                        <?php endforeach; ?>
                    </select>
                </form>
            </div>
        </div>
    </div>
    
    <div class="col-md-9">
        <h2 class="mb-4">Каталог товаров</h2>
        
        <?php if(count($products) > 0): ?>
        <div class="row">
            <?php foreach($products as $product): ?>
            <div class="col-md-4 mb-4">
                <div class="card h-100">
                    <img src="/uploads/products/<?= h($product['image'] ?: 'no-image.jpg') ?>" 
                         class="card-img-top" alt="<?= h($product['name']) ?>"
                         style="height: 200px; object-fit: cover;">
                    <div class="card-body">
                        <h5 class="card-title"><?= h($product['name']) ?></h5>
                        <p class="card-text"><?= h($product['category_name']) ?></p>
                        <p class="card-text text-primary fw-bold fs-4"><?= number_format($product['price'], 2) ?> ₽</p>
                        <a href="/pages/product.php?id=<?= $product['id'] ?>" class="btn btn-primary">Подробнее</a>
                    </div>
                </div>
            </div>
            <?php endforeach; ?>
        </div>
        <?php else: ?>
        <div class="alert alert-info">Товары не найдены</div>
        <?php endif; ?>
    </div>
</div>

<?php require_once '../includes/footer.php'; ?>