<?php
include('connection.php');

$user_id = $_POST['user_id'];
#$user_id = 1;

$stmt = $connection->prepare('SELECT order_id, total_price, status,time FROM orders WHERE order_user_id = :order_user_id');
$stmt->execute([':order_user_id' => $user_id]);

while($fetchData = $stmt->fetch(PDO::FETCH_ASSOC)){
    $result[] = $fetchData;
}

#$nr_of_orders = count($result);
echo json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);