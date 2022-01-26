<?php
include('connection.php');

$user_id = $_POST['user_id'];
$name = $_POST['name'];
$lastname = $_POST['lastname'];
$street = $_POST['street'];
$house_nr = $_POST['house_nr'];
if(isset($_POST['apartment_nr'])){
    $apartment_nr = $_POST['apartment_nr'];
}
$postal_code = $_POST['postal_code'];
$city = $_POST['city'];
$phone_nr = $_POST['phone_nr'];

#$user_id = 10;
#$name = 'Dawidek';
#$lastname = 'Dzg';
#$street = 'Aasolna';
#$house_nr = 5;
#$postal_code = '324-456';
#$city = 'Wachock';
#$phone_nr = 454545450;

if(isset($apartment_nr)){
    try {
        $stmt = $connection->prepare('UPDATE users SET name = :name, lastname = :lastname, street = :street, house_nr = :house_nr, apartment_nr = :apartment_nr, postal_code = :postal_code, city = :city, phone_nr = :phone_nr WHERE user_id = :user_id');
        $stmt->execute([':name' => $name, ':lastname' => $lastname, ':street' => $street, ':house_nr' => $house_nr, ':apartment_nr' => $apartment_nr, ':postal_code' => $postal_code, ':city' => $city, ':phone_nr' => $phone_nr, ':user_id' => $user_id]);
        echo json_encode('true');
    } catch (PDOException $error){
        $mess = $error->getMessage();
        echo substr($mess, -1);
    }
} else {
    try {
        $stmt = $connection->prepare('UPDATE users SET name = :name, lastname = :lastname, street = :street, house_nr = :house_nr, postal_code = :postal_code, city = :city, phone_nr = :phone_nr WHERE user_id = :user_id');
        $stmt->execute([':name' => $name, ':lastname' => $lastname, ':street' => $street, ':house_nr' => $house_nr, ':postal_code' => $postal_code, ':city' => $city, ':phone_nr' => $phone_nr, ':user_id' => $user_id]);
        echo json_encode('true');
        
    } catch (PDOException $error){
        $mess = $error->getMessage();
        echo substr($mess, -1);
    }
}