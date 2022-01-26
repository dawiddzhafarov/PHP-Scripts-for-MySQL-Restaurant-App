<?php
include('connection.php');

$category = $_POST['category'];
#$category = 'kanapka';
$stmt1 = $connection->prepare('SET SESSION group_concat_max_len = 2048');
$stmt1->execute();
$stmt = $connection->prepare('SELECT * FROM menu WHERE category = :category');
$stmt->execute([':category' => $category]);

$result = array();
        
while($fetchData = $stmt->fetch(PDO::FETCH_ASSOC)){
    $result[][] = $fetchData;
}

$json = json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
$json = str_replace('\r\n','', $json);

echo $json;