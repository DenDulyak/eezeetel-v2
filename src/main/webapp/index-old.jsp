<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="/common/imports.jsp"%>

<%
StringBuffer baseContext = request.getRequestURL();
int nIndex = baseContext.lastIndexOf("/");
String baseContextPath = baseContext.substring(0, nIndex + 1);
String strFailed = request.getParameter("failed");
if (strFailed != null && !strFailed.isEmpty())
	strFailed = "Failed to Login.  Please try again with correct Login ID and Password.";
else
	strFailed = "";
%>

<!DOCTYPE html>
<html id="site">
	<head>
		<base href="<%=baseContextPath%>"><!--[if lte IE 6]></base><![endif]-->
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
		<header>
			<div class="sub-header">
				<div class="sub-header-items">
					<div class="item">
						<i class="glyphicons phone_alt"></i><a href="tel:+442082009345">+44 (0) 20 8200 9345</a>&nbsp;&nbsp;<a href="tel:+442070960075">+44 (0) 20 7096 0075</a>
					</div>
					<div class="item">
						<i class="social e-mail"></i><a href="mailto:contact@eezeetel.com">contact@eezeetel.com</a>
					</div>
					<div class="item">
						<a href="http://www.linkedin.com/EezeeTel" target="_blank" class="no-decoration"><i class="social linked_in"></i></a>
						<a href="http://www.facebook.com/EezeeTel" target="_blank" class="no-decoration"><i class="social facebook"></i></a>
						<a href="http://www.twitter.com/EezeeTel" target="_blank" class="no-decoration"><i class="social twitter"></i></a>
						<a href="http://www.youtube.com/EezeeTel" target="_blank" class="no-decoration"><i class="social youtube"></i></a>
					</div>
				</div>
			</div>
			<div class="logo one pure-hidden-desktop">
				<img class="logo-image" src="images/eezeetel-logo-v3.png" />
			</div>
			<nav id="primary-navigation" class="site-navigation primary-navigation" role="navigation">
				<div class="sticky-menu compact-menu clearfix">
					<div id="menu-inner">
						<a class="menu-link"><span></span></a>
						<div class="logo two">
							<img class="logo-image" src="images/eezeetel-logo-v4.1.jpg" />
						</div>
						<a class="menu-heading">Menu</a>
						<ul id="main-menu" class="menu">
							<li class="menu-item current-menu-item"><a href="/">Home</a></li>
							<li class="menu-item"><a href="become-a-retailer.html">Become a Retailer</a></li>
							<li class="menu-item"><a href="become-a-partner.html">Become a Partner</a></li>
							<li class="menu-item"><a href="become-a-provider.html">Become a Provider</a></li>
							<li class="menu-item"><a href="learn-about-our-service.html">Learn about Our Service</a></li>
						</ul>
					</div>
				</div>
			</nav>
			<div id="header-extra" class="clearfix">
				<div id="header-extra-inner">
					<h2 class="tagline">The fastest web retail payment system in the UK</h2>
					<div id="login-form-container" class="login-l-box">
						<div id="login-form-toggle">Retailer login</div>
						<form name="the_form" method="POST" class="pure-form pure-form-stacked login" novalidate="novalidate">
							<div class="j-row">
								<input id="j_username" name="j_username" type="text" placeholder="Username" required="required" />
								<input id="j_password" name="j_password" type="password" placeholder="Password" required="required" />

								<button type="button" class="pure-button pure-button-primary-off" onClick="validate_and_submit()">Login</button>
							</div>
						
							<div class="j-row k-row">
								<div class="username error-message-container">
									<span class="error-message"></span>
								</div>
								<div class="password error-message-container">
									<span class="error-message"></span>
								</div>
								<div class="login error-message-container">
									<span class="error-message"></span>
								</div>
								
								<font color="red"><%=strFailed%></font>
							
								<!-- <input type="checkbox" id="remember-me" />
								<label for="remember-me">Keep me signed in</label>-->
								<!--<a href="#">Forgot password?</a>-->
							</div>
						</form>
					</div>
				</div>
			</div><!-- #header-extra -->
		</header>
		<div id="main">
			<section>
				
				<!--<div id="slide-title-container">
					<div class="slide-title" data-for-slide="0">International and Local SIMs</div>
					<div class="slide-title hidden" data-for-slide="1">World SIMs</div>
					<div class="slide-title hidden" data-for-slide="2">International Calling Cards</div>
				</div>-->
			<div class="flexslider-container">
				<div class="flexslider">
					<ul class="slides">
						<li data-transition="fade" data-masterspeed="1500" data-slotamount="6">
							<div class="tp-bannertimer"></div>
							<img class="banner blank" src="images/local-networks/hp-slider-background-local-1200x400-v3.0.jpg" data-bgrepeat="no-repeat" data-bgfit="cover" data-bgposition="center center" o-data-kenburns="on" o-data-duration="2000" o-data-ease="Power4.easeInOut" o-data-bgfit="200" o-data-bgfitend="100" o-data-bgpositionend="center center" />
							<div class="caption sfl ezt_medium_white_bold" data-x="75" data-y="100" data-speed="700" data-start="1000" data-easing="Power4.easeOut">SIMs &amp; Vouchers</div>
							<div class="caption sfl ezt_thintext_white" data-x="75" data-y="160" data-speed="700" data-start="1600" data-easing="Power4.easeOut">SIM cards and top up vouchers<br />for all the major UK networks<br />including o2, Orange, T-Mobile<br />Vodafone, Lebara, Lyca,<br />and others.</div>
							<div class="caption customin start" data-x="825" data-y="75" data-voffset="0" data-speed="2200" data-start="800" data-endspeed="300" data-customin="x:0;y:0;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:0;scaleY:0;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:50% 50%;" data-customout="x:0;y:0;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:0.75;scaleY:0.75;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:50% 50%;" data-easing="Back.easeOut"><img src="images/local-networks/all-local-400x400.jpg" style="border-radius: 50%; width: 250px; height: 250px;" /></div>
							<div class="caption jdexcept customin start" data-x="830" data-y="80" data-speed="2800" data-start="1100" data-endspeed="300" data-easing="Back.easeInOut" data-customin="x:0;y:0;z:0;rotationX:90;rotationY:0;rotationZ:0;scaleX:1;scaleY:1;skewX:0;skewY:0;opacity:0;transformPerspective:200;transformOrigin:50% 0%;">Major UK Networks</div>
						</li>
						<li data-transition="zoomout" data-masterspeed="1000" data-slotamount="4">
							<div class="tp-bannertimer"></div>
							<img src="images/int-networks/hp-background-slider-int-v2.1-1200x400.jpg" data-bgrepeat="no-repeat" data-bgfit="cover" data-bgposition="center center" />
							<div class="caption lft ezt_medium_white_bold" data-x="center" data-y="40" data-speed="700" data-start="1000" data-easing-old="easeOutBack" data-easing="Power4.easeOut">International PAYG Mobile</div>
							<div class="caption sfl ezt_thintext_white_plus" data-x="center" data-y="100" data-speed="700" data-start="1600" data-easing="Power4.easeOut" style="text-align: center;">A variety of PAYG mobile<br />for networks around the world.</div>
							<div class="caption jdexcept customin start" data-x="center" data-y="180" data-speed="1000" data-start="2200" data-endspeed="300" data-easing="Back.easeInOut" data-customin="x:0;y:0;z:0;rotationX:90;rotationY:0;rotationZ:0;scaleX:1;scaleY:1;skewX:0;skewY:0;opacity:0;transformPerspective:200;transformOrigin:50% 0%;">International Networks</div>
							<div class="caption customin start" data-x="260" data-y="260" data-voffset="0" data-speed="1000" data-start="2800" data-endspeed="300" data-customin="x:0;y:0;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:0;scaleY:0;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:50% 50%;" data-customout="x:0;y:0;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:0.75;scaleY:0.75;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:50% 50%;" data-easing="Back.easeOut"><img src="images/int-networks/delight-mobile-logo-200x200.png" style="border-radius: 50%; width: 80px; height: 80px; box-shadow: 0 0 1px rgba(127, 127, 127, 0.3);" /></div>
							<div class="caption customin start" data-x="410" data-y="260" data-voffset="0" data-speed="1000" data-start="3000" data-endspeed="300" data-customin="x:0;y:0;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:0;scaleY:0;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:50% 50%;" data-customout="x:0;y:0;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:0.75;scaleY:0.75;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:50% 50%;" data-easing="Back.easeOut"><img src="images/int-networks/lebara-mobile-logo-200x200.png" style="border-radius: 50%; width: 80px; height: 80px; box-shadow: 0 0 1px rgba(127, 127, 127, 0.3);" /></div>
							<div class="caption customin start" data-x="560" data-y="260" data-voffset="0" data-speed="1000" data-start="3200" data-endspeed="300" data-customin="x:0;y:0;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:0;scaleY:0;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:50% 50%;" data-customout="x:0;y:0;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:0.75;scaleY:0.75;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:50% 50%;" data-easing="Back.easeOut"><img src="images/int-networks/lyca-mobile-logo-200x200.png" style="border-radius: 50%; width: 80px; height: 80px; box-shadow: 0 0 1px rgba(127, 127, 127, 0.3);" /></div>
							<div class="caption customin start" data-x="710" data-y="260" data-voffset="0" data-speed="1000" data-start="3400" data-endspeed="300" data-customin="x:0;y:0;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:0;scaleY:0;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:50% 50%;" data-customout="x:0;y:0;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:0.75;scaleY:0.75;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:50% 50%;" data-easing="Back.easeOut"><img src="images/int-networks/now-mobile-logo-200x200.png" style="border-radius: 50%; width: 80px; height: 80px; box-shadow: 0 0 1px rgba(127, 127, 127, 0.3);" /></div>
							<div class="caption customin start" data-x="860" data-y="260" data-voffset="0" data-speed="1000" data-start="3600" data-endspeed="300" data-customin="x:0;y:0;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:0;scaleY:0;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:50% 50%;" data-customout="x:0;y:0;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:0.75;scaleY:0.75;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:50% 50%;" data-easing="Back.easeOut"><img src="images/int-networks/talk-home-mobile-logo-200x200.png" style="border-radius: 50%; width: 80px; height: 80px; box-shadow: 0 0 1px rgba(127, 127, 127, 0.3);" /></div>
						</li>
						<li data-transition="slideleft" data-masterspeed="1000" data-slotamount="1">
							<div class="tp-bannertimer"></div>
							<img src="images/calling-cards/hp-slider-background-cards-v2-1200x400.jpg" data-bgrepeat="no-repeat" data-bgfit="cover" data-bgposition="center center" />
							<div class="caption skewfromrightshort ezt_medium_white_bold" data-x="550" data-y="40" data-speed="700" data-start="1000" data-easing-old="easeOutBack" data-easing="Power4.easeOut">International Calling Cards</div>
							<div class="caption customin customout start ezt_thintext_white_plus" data-x="740" data-y="100" data-speed="700" data-start="1600" data-easing="Power4.easeOut" data-customin="x:0;y:100;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:1;scaleY:3;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:0% 0%;" data-customout="x:0;y:0;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:0.75;scaleY:0.75;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:50% 50%;" style="text-align: right;">A wide selection of calling cards.</div>
							<div class="caption jdexcept customin start" data-x="120" data-y="100" data-speed="1000" data-start="2200" data-endspeed="300" data-easing="Back.easeInOut" data-customin="x:0;y:0;z:0;rotationX:90;rotationY:0;rotationZ:0;scaleX:1;scaleY:1;skewX:0;skewY:0;opacity:0;transformPerspective:200;transformOrigin:50% 0%;">These providers:</div>
							<div class="caption sfr ezt_small_red" data-x="120" data-y="160" data-speed="350" data-start="2800" data-easing="Power4.easeOut">FNT Logistics</div>
							<div class="caption sfr ezt_small_red" data-x="120" data-y="190" data-speed="350" data-start="3000" data-easing="Power4.easeOut">Golat</div>
							<div class="caption sfr ezt_small_red" data-x="120" data-y="220" data-speed="350" data-start="3200" data-easing="Power4.easeOut">Home and Away</div>
							<div class="caption sfr ezt_small_red" data-x="120" data-y="250" data-speed="350" data-start="3400" data-easing="Power4.easeOut">Lycatel</div>
							<div class="caption sfr ezt_small_red" data-x="120" data-y="280" data-speed="350" data-start="3600" data-easing="Power4.easeOut">Nowtel Global Limited</div>
							<div class="caption sfr ezt_small_red" data-x="120" data-y="310" data-speed="350" data-start="3800" data-easing="Power4.easeOut">And others...</div>
							<!--<div class="caption customin start" data-x="825" data-y="175" data-voffset="0" data-speed="2200" data-start="4000" data-endspeed="300" data-customin="x:0;y:0;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:0;scaleY:0;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:50% 50%;" data-customout="x:0;y:0;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:0.75;scaleY:0.75;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:50% 50%;" data-easing="Back.easeOut"><img src="images/calling-cards/retailer-200x200.jpg" style="border-radius: 50%; width: 200px; height: 200px;" /></div>-->
						</li>
						<li data-transition="flyin" data-masterspeed="1000" data-slotamount="6">
							<div class="tp-bannertimer"></div>
							<img class="banner blank" src="images/world-networks/hp-slider-background-world-v1-1200x400.jpg" data-bgrepeat="no-repeat" data-bgfit="cover" data-bgposition="center center" o-data-kenburns="on" o-data-duration="2000" o-data-ease="Power4.easeInOut" o-data-bgfit="200" o-data-bgfitend="100" o-data-bgpositionend="center center" />
							<div class="caption sfl ezt_medium_dark_bold" data-x="75" data-y="100" data-speed="700" data-start="1000" data-easing="Power4.easeOut">World Mobile Top-ups</div>
							<div class="caption sfl ezt_thintext_dark_plus" data-x="75" data-y="160" data-speed="700" data-start="1600" data-easing="Power4.easeOut">Top up vouchers for many<br />global networks including<br />Digicel, Mobilink, Etisalat<br />Tigo, Roshan, MTN, Globe,<br />and others.</div>
							<div class="caption customin start" data-x="825" data-y="75" data-voffset="0" data-speed="2200" data-start="800" data-endspeed="300" data-customin="x:0;y:0;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:0;scaleY:0;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:50% 50%;" data-customout="x:0;y:0;z:0;rotationX:0;rotationY:0;rotationZ:0;scaleX:0.75;scaleY:0.75;skewX:0;skewY:0;opacity:0;transformPerspective:600;transformOrigin:50% 50%;" data-easing="Back.easeOut"><img src="images/world-networks/all-global-400x400.jpg" style="border-radius: 50%; width: 250px; height: 250px;" /></div>
							<div class="caption jdexcept customin start" data-x="844" data-y="80" data-speed="2800" data-start="1100" data-endspeed="300" data-easing="Back.easeInOut" data-customin="x:0;y:0;z:0;rotationX:90;rotationY:0;rotationZ:0;scaleX:1;scaleY:1;skewX:0;skewY:0;opacity:0;transformPerspective:200;transformOrigin:50% 0%;">Global Networks</div>
						</li>
						<li data-transition="zoomout" data-masterspeed="1000" data-slotamount="4">
							<div class="tp-bannertimer"></div>
							<img src="images/hp-slider-happy-customers-1200x400.jpg" data-bgrepeat="no-repeat" data-bgfit="cover" data-bgposition="center center" />
							<div class="caption lft ezt_medium_white_bold" data-x="center" data-y="40" data-speed="700" data-start="1000" data-easing-old="easeOutBack" data-easing="Power4.easeOut">Happy Retailers</div>
							<div class="caption sfr ezt_thintext_white_plus" data-x="center" data-y="100" data-speed="700" data-start="1600" data-easing="Power4.easeOut" style="text-align: center;">We have over 750 retailers<br />who use Web Pay in the UK.</div>
							<div class="caption jdexcept fade" data-x="center" data-y="center" data-speed="1000" data-start="2200" data-endspeed="300" data-easing="Back.easeInOut"><a href="become-a-retailer.html"><u>You can join them - find out more</u></a></div>
						</li>
					</ul>
				</div>
			</div><!-- .flexslider-container -->
			</section>
			<section class="content">
				<div class="pure-g-r blank">
					<div class="pure-u-1">
						<p class="text-1-4">Besides being the fastest retail payment system in the UK, we offer one of the widest range of providers for SIM, E-mobile, International PAYG and calling cards.</p><p class="text-1-6"></p>
						<div id="feature-points" class="pure-g-r">
							<div class="pure-u-1-3">
								<div class="feature-item unveil">
									<div class="big-round-icon"><i class="glyphicons flash"></i></div>
									<h3>Lightning Fast</h3>
									<p>
										Our super fast payments system is the quickest in the country and means shorter queuing times for customers.
									</p>
								</div>
							</div>
							<div class="pure-u-1-3">
								<div class="feature-item unveil">
									<div class="big-round-icon"><i class="glyphicons more_items"></i></div>
									<h3>Wide Product Range</h3>
									<p>
										We offer a wide range of products covering SIM, calling cards and mobile topups.
									</p>
								</div>
							</div>
							<div class="pure-u-1-3">
								<div class="feature-item unveil">
									<div class="big-round-icon"><i class="glyphicons star"></i></div>
									<h3>Great Service</h3>
									<p>
										All our customers, partners and suppliers get a great service.
									</p>
								</div>
							</div>
						</div>
					</div>
					<!--<div class="pure-u-1-3">
					</div>-->
				</div>
				<div id="core-choices-grid" class="pure-g-r inverse">
					<div class="pure-u-1">
						<h1>Discover More</h1>
						<p class="text-1-2">See for yourself how your business can benefit from using our services:</p>
					</div>
					<div class="pure-u-1-3">
						<a class="l-box" href="become-a-retailer.html">
							<h3>Become a<span class="hero-text">Retailer</span></h3>
							<div class="image-container unveil"><img src="images/CLP0832131.jpg" /></div>
						</a>
					</div>
					<div class="pure-u-1-3">
						<a class="l-box" href="become-a-partner.html">
							<h3>Become a<span class="hero-text">Partner</span></h3>
							<div class="image-container unveil"><img src="images/2824740.jpg" /><!--<img src="images/USA-California-Los-Angeles-Group-AYP1253050.jpg" />--></div>
						</a>
					</div>
					<div class="pure-u-1-3">
						<a class="l-box" href="become-a-provider.html">
							<h3>Become a<span class="hero-text">Provider</span></h3>
							<div class="image-container unveil"><img src="images/6404679.jpg" /></div><!--<img src="images/Manager-in-a-Factory-Warehouse-2838316.jpg" />-->
						</a>
					</div>
				</div>
			</section>
			<section class="content">
			<div id="other-choices-grid" class="pure-g-r inverse">
				<div class="pure-u-1">
					<p class="text-1-2">For a more general idea of what we do:</p>
				</div>
				<div class="pure-u-1-3">
					<a class="l-box" href="learn-about-our-service.html">
						<h3>Learn about<span class="hero-text">Our Service</span></h3>
						<div class="image-container unveil"><img src="images/1682010.jpg" /></div>
					</a>
				</div>
			</div>
		</section>
		</div><!-- #main -->
		<section id="sub-body">
			<div id="numbers-grid" class="pure-g-r inverse">
				<div class="pure-u-1-4">
					<h2>750+</h2>
					<h3>Retailers nationwide</h3>
				</div>
				<div class="pure-u-1-4">
					<h2>Reduced</h2>
					<h3>Serving time</h3>
				</div>
				<div class="pure-u-1-4">
					<h2>95%</h2>
					<h3>Positive feedback</h3>
				</div>
				<div class="pure-u-1-4">
					<h2>3 years</h2>
					<h3>Customer satisfaction</h3>
				</div>
			</div>
		</section>
		<footer>
			<div class="pure-g-r blank">
				<div class="pure-u-1-3">
					<section>
						<i class="glyphicons google_maps"></i>
						<div class="text-after">
							<span>Address:</span>
							<div class="address">
								<span class="address-part">EezeeTel Limited</span>
								<span class="address-part">8 Talgarth Walk</span>
								<span class="address-part">London</span>
								<a href="https://www.google.co.uk/maps/preview/place/8+Talgarth+Walk,+Edgware,+London+NW9+7HW,+UK/@51.5827223,-0.2515185,17z/data=!3m1!4b1!4m2!3m1!1s0x4876113c71393d97:0xab112fb9ee1d4940" target="_blank" class="address-part">NW9 7HW</a>
							</div>
						</div>
					</section>
				</div>
				<div class="pure-u-1-3">
					<section>
						<i class="social e-mail"></i>
						<div class="text-after">
							<a href="mailto:contact@eezeetel.com">contact@eezeetel.com</a>
						</div>
					</section>
					<section>
						<i class="glyphicons phone_alt"></i>
						<div class="text-after">
							<span>Telephone:</span>
							<div class="telephone-number"><a href="tel:+442082009345">+44 (0) 20 8200 9345</a> (Main)</div>
							<div class="telephone-number"><a href="tel:+442070960075">+44 (0) 20 7096 0075</a> (Alt)</div>
						</div>
					</section>
					<section>
						<i class="social skype"></i>
						<div class="text-after">
							<a href="skype:eezeetel?call">eezeetel</a>
						</div>
					</section>
				</div>
				<div class="pure-u-1-3">
					<section>
						<i class="glyphicons clock"></i>
						<div class="text-after">
							<span>Office hours:</span>
							<div>Mon-Fri 09:00-20:00</div>
							<div>Sat-Sun 09:00-19:00</div>
						</div>
					</section>
					<section>
						<div class="text-after social-links">
							<a href="http://www.linkedin.com/EezeeTel" target="_blank" class="no-decoration"><i class="social linked_in"></i></a>
							<a href="http://www.facebook.com/EezeeTel" target="_blank" class="no-decoration"><i class="social facebook"></i></a>
							<a href="http://www.twitter.com/EezeeTel" target="_blank" class="no-decoration"><i class="social twitter"></i></a>
							<a href="http://www.youtube.com/EezeeTel" target="_blank" class="no-decoration"><i class="social youtube"></i></a>
						</div>
					</section>
				</div>
				<div class="pure-u-1">
					<section id="copyright-notice">
						<span>Copyright &copy; 2014 EezeeTel UK Limited</span>
					</section>
				</div>
			</div>
		</footer>
		<script src="js/blue-responsive-menu.js?v=0.9.3"></script>
		<script src="js/main.js?v=0.9.3"></script>
		<script>
			(function($, window) {
				$('.flexslider').revolution({
					"hideAllCaptionAtLimit": 767,
					"startwidth": 1200,
					"startheight": 400,
					"autoheight": "on"
				});
				
				if (navigator.userAgent.indexOf('MSIE')) {
					$('html').addClass('is-ie');
				} else {
					$('html').addClass('not-ie');
				}
			})(jQuery, window);
		</script>
	</body>
</html>