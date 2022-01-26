<?php
include('connection.php');

$stmt = $connection->prepare('SELECT food_id, name FROM (SELECT * FROM `menu` WHERE category != "napoje" AND category != "dodatki") AS m1 ORDER BY RAND() LIMIT 4');
$stmt->execute();

#można dodać cene do wyników

while($fetchData = $stmt->fetch(PDO::FETCH_ASSOC)){
    $result[] = $fetchData;
}

$json = json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);

echo $json;