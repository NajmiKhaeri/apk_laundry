<!-- donate : https://saweria.co/najmikhaeriap -->
<?php
session_start();
$conn = mysqli_connect("localhost", "root", "", "najmi_laundry");

$username = $_POST['username'];
$password = md5($_POST['password']);
$query = "SELECT * FROM user WHERE username = '$username' AND password = '$password'";
$row = mysqli_query($conn, $query);
$data = mysqli_fetch_assoc($row);
$cek = mysqli_num_rows($row);

if ($cek > 0) {
    if ($data['role'] == 'admin') {
        $_SESSION['role'] = 'admin';
        $_SESSION['username'] = $data['username'];
        $_SESSION['user_id'] = $data['id_user'];
        $_SESSION['outlet_id'] = $data['outlet_id'];
        header('location:admin');
    } else if ($data['role'] == 'kasir') {
        $_SESSION['role'] = 'kasir';
        $_SESSION['username'] = $data['username'];
        $_SESSION['user_id'] = $data['id_user'];
        $_SESSION['outlet_id'] = $data['outlet_id'];
        header('location:kasir');
    }
} else {
    $message = 'Username atau password salah!!!';
    if(mysqli_num_rows(mysqli_query($conn, "SELECT * FROM user WHERE username = '$username'")) > 0){
        $message = 'Password yang anda masukkan salah!!!';
    }else if (mysqli_num_rows(mysqli_query($conn, "SELECT * FROM user WHERE password = '$password'")) > 0){
        $message = 'Username yang anda masukkan salah!!!';
    }
    header('location:index.php?message=' . $message);
}
?>
