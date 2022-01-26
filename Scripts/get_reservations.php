<?php
include('connection.php');

$user_id = $_POST['user_id'];
#$user_id = 10;

$stmt = $connection->prepare('SELECT reserv_id,reserv_table,time,comments FROM reservations WHERE reserv_user = :reserv_user');
$stmt->execute([':reserv_user' => $user_id]);

$result = array();
        
while($fetchData = $stmt->fetch(PDO::FETCH_ASSOC)){
    $result[] = $fetchData;
}

#var_dump($result);

#echo count($result);

$json = json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
$json = str_replace('\r\n','', $json);

echo $json;