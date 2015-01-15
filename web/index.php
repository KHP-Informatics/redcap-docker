<html>
<head>
	<title>REDCAP on DOCKER</title>
	<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>
	<style>
	body {
		background-color: white;
		text-align: center;
		padding: 50px;
		font-family: "Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;
	}

	#logo {
		margin-bottom: 40px;
	}
	</style>
</head>
<body>

	<img id="logo" src="" />
	<h1><?php echo "Access the Redcap Site at:"; ?></h1>
        <h2><?php echo $_SERVER['HTTP_HOST'] . "/redcap/index.php"; ?></h2>
	
</body>
</html>
