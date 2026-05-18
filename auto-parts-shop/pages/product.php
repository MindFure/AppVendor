<?php
$pageTitle = "Товар";
require_once '../includes/header.php';

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

$stmt = $pdo->prepare("SELECT p.*, c.name as category_name 
                       FROM products p 
                       LEFT JOIN categories c ON p.category_id = c.id 
                       WHERE p.id = ?");
$stmt->execute([$id]);
$product = $stmt->fetch();

if(!$product) {
    header('Location: /pages/catalog.php');
    exit;
}
?>

<div class="row">
    <div class="col-md-6">
        <img src="/uploads/products/<?= h($product['image'] ?: 'no-image.jpg') ?>" 
             class="img-fluid rounded" alt="<?= h($product['name']) ?>">
    </div>
    <div class="col-md-6">
        <h1><?= h($product['name']) ?></h1>
        <p class="text-muted">Артикул: <?= h($product['sku']) ?></p>
        <p class="text-muted">Категория: <?= h($product['category_name']) ?></p>
        
        <div class="price mb-3">
            <span class="display-5 text-primary fw-bold"><?= number_format($product['price'], 2) ?> ₽</span>
        </div>
        
        <div class="availability mb-3">
            <?php if($product['quantity'] > 0): ?>
                <span class="badge bg-success">В наличии: <?= $product['quantity'] ?> шт.</span>
            <?php else: ?>
                <span class="badge bg-danger">Нет в наличии</span>
            <?php endif; ?>
        </div>
        
        <div class="description mb-4">
            <h5>Описание:</h5>
            <p><?= nl2br(h($product['description'])) ?></p>
        </div>
        
        <form action="/pages/cart.php" method="POST" class="mt-3">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="product_id" value="<?= $product['id'] ?>">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="form-label">Количество:</label>
                    <input type="number" name="quantity" class="form-control" value="1" min="1" max="<?= $product['quantity'] ?>" style="width: 100px;">
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary btn-lg" <?= $product['quantity'] == 0 ? 'disabled' : '' ?>>
                        Добавить в корзину
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<?php require_once '../includes/footer.php'; ?>