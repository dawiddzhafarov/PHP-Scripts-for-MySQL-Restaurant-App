<?php
include('connection.php');

$order_id = $_POST['order_id'];
#$order_id = 27;

#$stmt = $connection->prepare('SELECT food_id, amount, price FROM orders_details WHERE order_id = :order_id');
$stmt = $connection->prepare('SELECT name, amount, O.price FROM menu M, orders_details O WHERE order_id = :order_id AND M.food_id = O.food_id;');

$stmt->execute([':order_id' => $order_id]);

while($fetchData = $stmt->fetch(PDO::FETCH_ASSOC)){
    $result[] = $fetchData;
}

#$nr_of_products = count($result);
echo json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);