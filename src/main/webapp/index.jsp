<!DOCTYPE html>
<html lang="en">
<head>
	<title>Essy Call</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!--===============================================================================================-->
	<link rel="icon" type="image/png" href="images/icons/favicon.png"/>
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="fonts/font-awesome-4.7.0/css/font-awesome.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="fonts/iconic/css/material-design-iconic-font.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/animate/animate.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/css-hamburgers/hamburgers.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/animsition/css/animsition.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/select2/select2.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/daterangepicker/daterangepicker.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="css/util-ec.css">
	<link rel="stylesheet" type="text/css" href="css/main-ec.css">
	<!--===============================================================================================-->

	<meta charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0" />
	<meta name="keywords" content="EezeeTel, retail payment, fast payment system" />
	<meta name="description" content="Sample layout for EezeeTel homepage." />
	<title>EezeeTel - Homepage</title>
	<link rel="stylesheet" href="css/pure.css" />
	<link rel="stylesheet" href="css/glyphicons.css?v=1.8" />
	<link rel="stylesheet" href="css/social.css?v=1.8" />
	<!--<link rel="stylesheet" href="js/flexslider/flexslider.css" />-->
	<link rel="stylesheet" href="css/blue-responsive-menu.css?v=0.9.3" />
	<link rel="stylesheet" href="css/main.css?v=0.9.3" />
	<script src="js/libs/jquery.min.js"></script>
	<script src="js/modernizr.min.js"></script>
	<!--<link href='http://fonts.googleapis.com/css?family=Alegreya+Sans:100,300,400' rel='stylesheet' type='text/css' />
    <link href='http://fonts.googleapis.com/css?family=Open+Sans:300,400,700' rel='stylesheet' type='text/css' />-->
	<link href='http://fonts.googleapis.com/css?family=Droid+Sans' rel='stylesheet' type='text/css' />
	<link href='http://fonts.googleapis.com/css?family=News+Cycle:400,700' rel='stylesheet' type='text/css' />
	<link href='http://fonts.googleapis.com/css?family=PT+Sans:400,700' rel='stylesheet' type='text/css' />
	<link rel="stylesheet" href="js/rs-plugin/css/settings.css" />
	<script type="text/javascript" src="js/rs-plugin/js/jquery.themepunch.plugins.min.js"></script>
	<script type="text/javascript" src="js/rs-plugin/js/jquery.themepunch.revolution.min.js"></script>
	<!--<script src="js/flexslider/jquery.flexslider.js"></script>-->
	<link rel="prerender" href="become-a-retailer.html" />
	<link rel="next" href="become-a-retailer.html"/>
	<link rel="icon" type="image/png" href="images/favicon.png" />
	<link rel="apple-touch-icon" href="images/eezeetel-logo-v1.2-152x152.png" />
	<script type="text/javascript" src="js/validate.js"></script>
	<script language="javascript">
		function validate_and_submit()
		{
			if (IsNULL(document.the_form.j_username.value))
			{
				alert("Please enter proper user id");
				document.the_form.j_username.focus();
				return;
			}

			if (!AlphaNumerals(document.the_form.j_username.value))
			{
				alert("User ID can only have alphabets and digits");
				document.the_form.j_username.focus();
				return;
			}

			if (IsNULL(document.the_form.j_password.value))
			{
				alert("Please enter proper password");
				document.the_form.j_password.focus();
				return;
			}

			if (!AlphaNumerals(document.the_form.j_password.value))
			{
				alert("Password can only have alphabets and digits");
				document.the_form.j_password.focus();
				return;
			}

			document.the_form.action = "/login";
			document.the_form.submit();
		}
	</script>

</head>
<body>

<div class="limiter">
	<div class="container-login100">
		<div class="tp-dottedoverlay twoxtwo"><!-- dotted overlay --></div>
		<div class="wrap-login100">
			<form name="the_form" method="POST" class="login100-form validate-form">
					<span class="login100-form-logo">
						<img src="images/logo.jpg" class="img-fluid" />
					</span>

					<span class="login100-form-title p-b-34 p-t-27">
						Log in
					</span>

				<div class="j-row">
					<div class="wrap-input100 validate-input" data-validate = "Enter username">
						<input id="j_username" class="input100" name="j_username" type="text" placeholder="Username" required="required" />
						<span class="focus-input100" data-placeholder="&#xf207;"></span>
					</div>
					<div class="wrap-input100 validate-input" data-validate="Enter password">
						<input id="j_password" class="input100" name="j_password" type="password" placeholder="Password" required="required" />
						<span class="focus-input100" data-placeholder="&#xf191;"></span>
					</div>
				</div>




				<div class="contact100-form-checkbox">
					<input class="input-checkbox100" id="ckb1" type="checkbox" name="remember-me">
					<label class="label-checkbox100" for="ckb1">
						Remember me
					</label>
				</div>
				<%--<button type="button" class="pure-button pure-button-primary-off" onClick="validate_and_submit()">Login</button>--%>
				<div class="container-login100-form-btn">
					<button class="login100-form-btn" onClick="validate_and_submit()">
						Login
					</button>
				</div>

				<div class="text-center p-t-90">
					<a class="txt1" href="#">
						Forgot Password?
					</a>
				</div>
			</form>
		</div>
	</div>


	<footer class="hidden-print">

		<div class="tp-dottedoverlay twoxtwo"><!-- dotted overlay --></div>
		<div class="overlay-footer"></div>
		<div class="footer-inner">
			<div class="container">
				<h1 class="section-title wow fadeInDown">CONTACT US</h1>
				<div class="row">
					<div class="col-md-4">
						<div class="info wow fadeInUp">
							<h3><i class="fa fa-envelope-o "></i>  EMAIL</h3>
							<div class="content">
								<p>info@xxxxxxxx.com</p>
								<p>xxxxxxx@xxxxxxxx.com</p>
							</div>
						</div>
					</div>
					<div class="col-md-4">
						<div class="info wow fadeInUp">
							<h3><i class="fa fa-mobile" aria-hidden="true"></i> PHONE </h3>
							<div class="content">
								<p> +961 1 123 456 </p>
								<p> +961 3 123 456</p>
							</div>
						</div>
					</div>
					<div class="col-md-4">
						<div class="info wow fadeInUp">
							<h3><i class="fa fa-map-marker" aria-hidden="true"></i> OFFICE </h3>
							<div class="content">
								1st Floor, xxxxx xxxxx<br />
								xxx xxxx , xxxxx  Street <br />
								Beirut - Lebanon
							</div>
						</div>
					</div>
				</div>
				<div class="social">
                <span>

                            <a href="#" class="social-facebook wow fadeInDown" data-wow-delay="0.2s"
							   target="_blank" data-toggle="tooltip" data-placement="top" title="twitter" data-original-title="twitter">
								<i class="fa fa-twitter" aria-hidden="true"></i></a>

                            <a href="#" class="social-facebook wow fadeInDown" data-wow-delay="0.4s"
							   target="_blank" data-toggle="tooltip" data-placement="top" title="facebook" data-original-title="facebook">
								<i class="fa fa-facebook" aria-hidden="true"></i></a>

                            <a href="#" class="social-youtube wow fadeInDown" data-wow-delay="0.6s"
							   target="_blank" data-toggle="tooltip" data-placement="top" title="" data-original-title="">
								<i class="fa fa-youtube" aria-hidden="true"></i></a>

                            <a href="#" class="social-google-plus wow fadeInDown" data-wow-delay="0.8s"
							   target="_blank" data-toggle="tooltip" data-placement="top" title="" data-original-title="">
								<i class="fa fa-google-plus" aria-hidden="true"></i></a>

                            <a href="#" class="social-vk wow fadeInDown" data-wow-delay="1s"
							   target="_blank" data-toggle="tooltip" data-placement="top" title="" data-original-title="">
								<i class="fa fa-vk" aria-hidden="true"></i></a>

                            <a href="#" class="social-linkedin wow fadeInDown" data-wow-delay="1.2s"
							   target="_blank" data-toggle="tooltip" data-placement="top" title="" data-original-title="">
								<i class="fa fa-linkedin" aria-hidden="true"></i></a>

                            <a href="#" class="social-flickr wow fadeInDown" data-wow-delay="1.4s"
							   target="_blank" data-toggle="tooltip" data-placement="top" title="" data-original-title="">
								<i class="fa fa-flickr" aria-hidden="true"></i></a>

                            <a href="#" class="social-instagram wow fadeInDown" data-wow-delay="1.6s"
							   target="_blank" data-toggle="tooltip" data-placement="top" title="" data-original-title="">
								<i class="fa fa-instagram" aria-hidden="true"></i></a>

                            <a href="https://telegram.org" class="social-telegram wow fadeInDown" data-wow-delay="1.8s"
							   target="_blank" data-toggle="tooltip" data-placement="top" title="" data-original-title="">
								<i class="fa fa-paper-plane" aria-hidden="true"></i></a>
                                            </span>
				</div>
				<div class="copyright text-center wow fadeInUp" data-wow-delay="0.8s">
					Copyright © 2018 <a href="#">Essy Call</a> . Powered By <a href="#">SWT</a>
				</div>

			</div>
		</div>
	</footer>
</div>
<div id="dropDownSelect1"></div>

<!--===============================================================================================-->
<script src="vendor/jquery/jquery-3.2.1.min.js"></script>
<!--===============================================================================================-->
<script src="vendor/animsition/js/animsition.min.js"></script>
<!--===============================================================================================-->
<script src="vendor/bootstrap/js/popper.js"></script>
<script src="vendor/bootstrap/js/bootstrap.min.js"></script>
<!--===============================================================================================-->
<script src="vendor/select2/select2.min.js"></script>
<!--===============================================================================================-->
<script src="vendor/daterangepicker/moment.min.js"></script>
<script src="vendor/daterangepicker/daterangepicker.js"></script>
<!--===============================================================================================-->
<script src="vendor/countdowntime/countdowntime.js"></script>
<!--===============================================================================================-->
<script src="js/main-ec.js"></script>

</body>
</html>