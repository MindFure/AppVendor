<?php
$pageTitle = "Корзина";
require_once '../includes/header.php';

// Обработка действий
if($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    $product_id = (int)($_POST['product_id'] ?? 0);
    $quantity = (int)($_POST['quantity'] ?? 1);
    
    // Получаем или создаем session_id для корзины
    if(!isset($_SESSION['cart_id'])) {
        $_SESSION['cart_id'] = session_id();
    }
    $cart_id = $_SESSION['cart_id'];
    
    if($action === 'add') {
        // Проверяем, есть ли уже товар в корзине
        $stmt = $pdo->prepare("SELECT * FROM cart WHERE session_id = ? AND product_id = ?");
        $stmt->execute([$cart_id, $product_id]);
        $cart_item = $stmt->fetch();
        
        if($cart_item) {
            $new_quantity = $cart_item['quantity'] + $quantity;
            $stmt = $pdo->prepare("UPDATE cart SET quantity = ? WHERE id = ?");
            $stmt->execute([$new_quantity, $cart_item['id']]);
        } else {
            $stmt = $pdo->prepare("INSERT INTO cart (session_id, product_id, quantity) VALUES (?, ?, ?)");
            $stmt->execute([$cart_id, $product_id, $quantity]);
        }
        
        header('Location: /pages/cart.php');
        exit;
    }
    
    if($action === 'update') {
        $cart_item_id = (int)($_POST['cart_item_id'] ?? 0);
        if($quantity > 0) {
            $stmt = $pdo->prepare("UPDATE cart SET quantity = ? WHERE id = ?");
            $stmt->execute([$quantity, $cart_item_id]);
        } else {
            $stmt = $pdo->prepare("DELETE FROM cart WHERE id = ?");
            $stmt->execute([$cart_item_id]);
        }
        header('Location: /pages/cart.php');
        exit;
    }
    
    if($action === 'remove') {
        $cart_item_id = (int)($_POST['cart_item_id'] ?? 0);
        $stmt = $pdo->prepare("DELETE FROM cart WHERE id = ?");
        $stmt->execute([$cart_item_id]);
        header('Location: /pages/cart.php');
        exit;
    }
}

// Получаем содержимое корзины
$cart_id = $_SESSION['cart_id'] ?? session_id();
$stmt = $pdo->prepare("SELECT c.*, p.name, p.price, p.image 
                       FROM cart c 
                       JOIN products p ON c.product_id = p.id 
                       WHERE c.session_id = ?");
$stmt->execute([$cart_id]);
$cart_items = $stmt->fetchAll();

$total = 0;
foreach($cart_items as $item) {
    $total += $item['price'] * $item['quantity'];
}
?>

<h2>Корзина</h2>

<?php if(count($cart_items) > 0): ?>
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>Товар</th>
                    <th>Цена</th>
                    <th>Количество</th>
                    <th>Сумма</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <?php foreach($cart_items as $item): ?>
                <tr>
                    <td>
                        <img src="/uploads/products/<?= h($item['image'] ?: 'no-image.jpg') ?>" 
                             style="width: 50px; height: 50px; object-fit: cover;" class="me-2">
                        <?= h($item['name']) ?>
                    </td>
                    <td><?= number_format($item['price'], 2) ?> ₽</td>
                    <td>
                        <form method="POST" style="display: inline-block;">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="cart_item_id" value="<?= $item['id'] ?>">
                            <input type="number" name="quantity" value="<?= $item['quantity'] ?>" 
                                   min="1" style="width: 70px;" onchange="this.form.submit()">
                        </form>
                    </td>
                    <td><?= number_format($item['price'] * $item['quantity'], 2) ?> ₽</td>
                    <td>
                        <form method="POST">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="cart_item_id" value="<?= $item['id'] ?>">
                            <button type="submit" class="btn btn-sm btn-danger">Удалить</button>
                        </form>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
            <tfoot>
                <tr class="table-active">
                    <td colspan="3" class="text-end"><strong>Итого:</strong></td>
                    <td><strong><?= number_format($total, 2) ?> ₽</strong></td>
                    <td></td>
                </tr>
            </tfoot>
        </table>
    </div>
    
    <div class="d-flex justify-content-between">
        <a href="/pages/catalog.php" class="btn btn-secondary">Продолжить покупки</a>
        <a href="/pages/checkout.php" class="btn btn-success">Оформить заказ</a>
    </div>
<?php else: ?>
    <div class="alert alert-info">
        Ваша корзина пуста. <a href="/pages/catalog.php">Перейти в каталог</a>
    </div>
<?php endif; ?>

<?php require_once '../includes/footer.php'; ?>