<?php
include("connection.php");

$user_id = $_POST['user_id'];
#$user_id = 1;
$nr_of_products = $_POST['nr_of_products'];
#$nr_of_products = 5;
$comments = $_POST['comments'];
#$comments = 'sdadas';

$result = 'false';


for ($i = 1; $i <= $nr_of_products; $i++){
    #${"food_id_$i"} = $i;
    #${"food_amount_$i"} = $i;
    
    ${"food_amount_$i"} = $_POST['food_amount_' . $i];
    ${"food_id_$i"} = $_POST['food_id_' . $i];
}

for ($i = 1; $i <= $nr_of_products; $i++){
    try {
        $stmt = $connection->prepare('SELECT price FROM menu WHERE food_id = :food_id');
        $stmt->execute([':food_id' => ${"food_id_$i"}]);
        $fetchData = $stmt->fetch(PDO::FETCH_ASSOC);
        ${"food_price_$i"} = $fetchData['price'];
        $result = 'true';
    } catch (PDOException $error){
        $result = 'false';
    }
}

$status = 'przyjęte';

$total_price = 0.0;


for ($i = 1; $i <= $nr_of_products; $i++){
    $total_price += (${"food_price_$i"} * ${"food_amount_$i"});
}

$connection->beginTransaction();
try {
    $stmt = $connection->prepare('INSERT INTO orders (order_user_id,total_price,status,comments,time) VALUES (:order_user_id,:total_price,:status,:comments,NOW())');
    $stmt -> execute([':order_user_id' => $user_id, ':total_price' => $total_price, ':status' => $status, ':comments' => $comments]);
    $order_id = $connection->lastInsertId();
    

    for ($i = 1; $i <= $nr_of_products; $i++){
        $stmt = $connection->prepare('INSERT INTO orders_details (order_id,food_id,amount,price) VALUES (:order_id,:food_id,:amount,:price)');
        $stmt -> execute([':order_id' => $order_id, ':food_id' => ${"food_id_$i"}, ':amount' => ${"food_amount_$i"}, ':price' => (${"food_price_$i"} * ${"food_amount_$i"})]);
        
    }
    $connection->commit();
    $result = 'true';
} catch (PDOException $error){
    $connection -> rollBack();
    $result = 'false';
}

/*
try {
    $stmt_insert_orders = $connection->prepare('INSERT INTO orders (order_user_id,total_price,status,comments,time) VALUES (:order_user_id,:total_price,:status,:comments,NOW())');
    $stmt_insert_orders -> execute([':order_user_id' => $user_id, ':total_price' => $total_price, ':status' => $status, ':comments' => $comments]);
    $order_id = $connection->lastInsertId();
    $result = 'true';
} catch (PDOException $error){
    $result = 'false';
}
for ($i = 1; $i <= $nr_of_products; $i++){
    try {
        $stmt_insert_orders_details = $connection->prepare('INSERT INTO orders_details (order_id,food_id,amount,price) VALUES (:order_id,:food_id,:amount,:price)');
        $stmt_insert_orders_details -> execute([':order_id' => $order_id, ':food_id' => ${"food_id_$i"}, ':amount' => ${"food_amount_$i"}, ':price' => (${"food_price_$i"} * ${"food_amount_$i"})]);
        $result = 'true';
    } catch (PDOException $error){
        $result = 'false';
    }
}
*/
echo json_encode($result);

