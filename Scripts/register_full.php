<?php
include("connection.php");

$name = $_POST['name'];
$lastname = $_POST['lastname'];
$email = $_POST['email'];
$password = $_POST['password'];
$street = $_POST['street'];
$house_nr = $_POST['house_nr'];
if(isset($_POST['apartment_nr'])){
    $apartment_nr = $_POST['apartment_nr'];
}
$postal_code = $_POST['postal_code'];
$city = $_POST['city'];
$phone_nr = $_POST['phone_nr'];

#$name = 'Ninaaar';
#$lastname = 'Kalienteeer';
#$email = 'tescik54444@gmail.com';
#$password = 'lolekbolek123';
#$street = 'Dziwna';
#$house_nr = 234;
#$apartment_nr = 2;
#$postal_code = '33-333';
#$city = 'Dziwne';
#$phone_nr = 590178393;


$password_hashed = password_hash($password, PASSWORD_DEFAULT);

if(isset($apartment_nr)){
    try {
        $stmt = $connection->prepare('INSERT INTO users (name,lastname,email,password,street,house_nr,apartment_nr,postal_code,city,phone_nr) VALUES (:name, :lastname, :email, :password, :street, :house_nr, :apartment_nr, :postal_code, :city, :phone_nr)');
        $stmt->execute([':name' => $name, ':lastname' => $lastname, ':email' => $email, ':password' => $password_hashed, ':street' => $street, ':house_nr' => $house_nr, ':apartment_nr' => $apartment_nr, ':postal_code' => $postal_code, ':city' => $city, ':phone_nr' => $phone_nr]);
        echo json_encode('true');
    } catch (PDOException $error){
        $mess = $error->getMessage();
        $uniq = $error->getCode();
        if(strcmp($uniq, '23000') == 0){
            $code = '9';
            echo json_encode($code);
        } else {
            echo json_encode(substr($mess, -1));
        }
    }
} else {
    try {
        $stmt = $connection->prepare('INSERT INTO users (name,lastname,email,password,street,house_nr,postal_code,city,phone_nr) VALUES (:name, :lastname, :email, :password, :street, :house_nr, :postal_code, :city, :phone_nr)');
        $stmt->execute([':name' => $name, ':lastname' => $lastname, ':email' => $email, ':password' => $password_hashed, ':street' => $street, ':house_nr' => $house_nr, ':postal_code' => $postal_code, ':city' => $city, ':phone_nr' => $phone_nr]);
        echo json_encode('true');
    } catch (PDOException $error){
        $mess = $error->getMessage();
        $uniq = $error->getCode();
        if(strcmp($uniq, '23000') == 0){
            $code = '9';
            echo json_encode($code);
        } else {
            echo json_encode(substr($mess, -1));
        }
    
    }
}
/*
INSERT INTO `users`(`name`, `lastname`, `email`, `password`, `street`, `house_nr`, `apartment_nr`, `postal_code`, `city`, `phone_nr`) VALUES ('Bubyyy','Dodaaaa','emailsdf@gmail.com','dsasad3333','Żałosna',5,5,'23-492','Daaaa',010101011);
*/