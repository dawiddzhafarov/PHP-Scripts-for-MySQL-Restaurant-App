<?php
include('connection.php');

$datetime = $_POST['datetime'];
#$datetime = '2021-12-30 6:50:00';

$hour = substr($datetime,11,2);
#$hour = str_replace(':','',$hour);
if(intval($hour) >= 22 || intval($hour < 10)){
    echo json_encode('false');
} else {

    $stmt = $connection->prepare('SELECT DISTINCT(reserv_table) FROM reservations WHERE (SELECT TIMESTAMPDIFF(DAY,time, :datetime)) = 0 AND (SELECT ABS((SELECT TIMESTAMPDIFF(MINUTE, time, :datetime)))) < 120');
    $stmt -> execute([':datetime' => $datetime]);

    $result = [];
    while($fetchData = $stmt->fetch(PDO::FETCH_ASSOC)){
        $result[] = $fetchData;
    }

    $length = count($result);
    $reserved_tables = array();

    for($i=0;$i<$length;$i++){
        array_push($reserved_tables,$result[$i]['reserv_table']);
    }


    $returned = array();

    for($i = 0; $i < 13; $i++){
        if(in_array($i+1,$reserved_tables)){
            $returned[$i+1] = 0;
        } else {
            $returned[$i+1] = 1;
        }
    }
    #var_dump($returned);
    echo json_encode($returned);
}
    #1 - wolne, 0 - zajęte