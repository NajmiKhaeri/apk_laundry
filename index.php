<!-- donate : https://saweria.co/najmikhaeriap -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE-edge">
	<title>Login</title>
	<link rel="stylesheet" type="text/css" href="style.css" media="screen" title="no title">
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css">
	
	<style>
	.alert-danger {
		color: red;
	}
	</style>
</head>
<body>
<div class="login">
	<div class="avatar">
		<img src="img/icon.png" alt="">
	</div>

	<h2>Login Form</h2>

	<form action="cek_login.php" method="post">
		<?php if (isset($_GET['message'])) : ?>
			<div class="row justify-content-center">
				<small class="alert alert-danger" role="alert">
					<?= $_GET['message']; ?>
				</small>
			</div>
		<?php endif ?>
		<div class="box-login">
			<i class="fas fa-user-alt"></i>
			<input type="text" placeholder="Username" name="username" style="color:white;">
		</div>

		<div class="box-login">
			<i class="fa fa-lock"></i>
			<input type="password" placeholder="Password" name="password" style="color:white;">
		</div>

		<center><button type="submit" name="login" class="btn-login" >Login</button></center>
		<div class="bottom">
		</form>
	</div>
</div>
</body>
</html>
