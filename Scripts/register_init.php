<?php
include("connection.php");

$email = $_POST['email'];;
$password = $_POST['password'];

if(preg_match('/^[a-zA-Z0-9\-\_\.]+\@[a-zA-Z0-9\-\_\.]+\.[a-zA-Z]{2,5}$/D', $email)) {
    $stmt = $connection->prepare('SELECT COUNT(*) FROM users where email = :email');
    $stmt->execute([':email' => $email]);
    $count = $stmt->fetchColumn();
    
    if (intval($count) == 0){
      echo json_encode('true');
    } else {
      $error_code = 7;
      echo json_encode($error_code);
    }
    
} else {
  $error_code = 8;
  echo json_encode($error_code); 
}