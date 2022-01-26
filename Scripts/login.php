<?php
include("connection.php");

$email = $_POST['email'];
$password = $_POST['password'];

#$email = 'kotki@mniam.com';
#$password = 'kotki';
$stmt = $connection->prepare("SELECT * FROM users WHERE email = :email");
$stmt->execute([':email' => $email]);
        
$result = array();
        
while($fetchData = $stmt->fetch(PDO::FETCH_ASSOC)){
    $result = $fetchData;
}
        
if ($result) {
    if (password_verify($password, $result['password'])) {
        echo json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
	} else {
        echo 'false';
    }
}