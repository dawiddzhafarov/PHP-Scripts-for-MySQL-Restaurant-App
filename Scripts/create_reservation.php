<?php
include('connection.php');


$table_id = $_POST['table_id'];
#$table_id = 5;
$user_id = $_POST['user_id'];
#$user_id = 10;
$wanted_time = $_POST['wanted_time'];
#$wanted_time = '2021-12-30 18:30:00';
if(isset($_POST['comments'])){
    $comments = $_POST['comments'];
}

$result = 'false';
$connection->beginTransaction();

try {
    $stmt = $connection->prepare('SELECT * FROM tables WHERE table_id = :table_id FOR UPDATE');
    $stmt -> execute([':table_id' => $table_id]);
  
    
    $stmt2 = $connection->prepare('SELECT COUNT(*) FROM reservations WHERE reserv_table = :reserv_table AND (SELECT TIMESTAMPDIFF(DAY,time, :wanted_time)) = 0 AND (SELECT ABS((SELECT TIMESTAMPDIFF(MINUTE, time, :wanted_time)))) < 120');
    $stmt2 -> execute([':reserv_table' => $table_id, ':wanted_time' => $wanted_time]);
    #SELECT COUNT(*) FROM reservations WHERE reserv_table = 1 AND (SELECT TIMESTAMPDIFF(DAY,time, '2021-12-30 18:00:00')) = 0 AND (SELECT ABS((SELECT TIMESTAMPDIFF(MINUTE, time, '2021-12-30 18:00:00')))) < 120;
    #zwraca liczbe wierszy, jeśli 0 - można zarezerwować, jeśli 1 nunu
    $counter = $stmt2 -> fetchColumn();
    
    if($counter == 0){
        if(isset($comments)){
            $stmt3 = $connection->prepare('INSERT INTO reservations (reserv_user, reserv_table, time, comments) VALUES (:reserv_user, :reserv_table, :time, :comments)');
            $stmt3 -> execute([':reserv_user' => $user_id, ':reserv_table' => $table_id, ':time' => $wanted_time, ':comments' => $comments]);
            $connection->commit();
            $result = 'true';
        } else {
            $stmt3 = $connection->prepare('INSERT INTO reservations (reserv_user, reserv_table, time) VALUES (:reserv_user, :reserv_table, :time)');
            $stmt3 -> execute([':reserv_user' => $user_id, ':reserv_table' => $table_id, ':time' => $wanted_time]);
            $connection->commit();
            $result = 'true';
        }
    } else {
        $connection -> rollBack();
        $result = 'false';
    }
        #zapytanie SELECT TIMESTAMPDIFF(MINUTE,LogOutTime,LogInTime) AS TimeLoggedInFROM LogTable mniejszy/wiekszy od jakiejs wartości jako warunek innego zapytania
    # sprawdzenie zajętości stolika, zwrocenie false/true/0/1
       # timestampdiff(DAY) if 0 then reject if >0 then accept
    #jeśli wolne to insert:


} catch (PDOException $error){
    $connection -> rollBack();
    $result = 'false';
}
echo json_encode($result);