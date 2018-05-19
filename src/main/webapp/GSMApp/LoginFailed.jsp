<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
String ksContext = getServletContext().getContextPath();
%>

<!doctype html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"> <!--<![endif]-->
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	
	<title>GSM International - Communications solutions for international students</title>
	<meta name="description" content="Providers of mobile phones, sim cards, phone cards, mobile internet and other communications solutions for international students">
	<meta name="author" content="Chris Goodwin, www.supermonkeycreative.co.uk">
	
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	
	<!--
	<link rel="shortcut icon" href="http://www.gsminternational.co.uk/favicon.ico" />
	<link rel="apple-touch-icon" href="http://www.gsminternational.co.uk/apple-touch-icon.png" />
	<link rel="apple-touch-icon" sizes="72x72" href="http://www.gsminternational.co.uk/apple-touch-icon-72x72.png" />
	<link rel="apple-touch-icon" sizes="114x114" href="http://www.gsminternational.co.uk/apple-touch-icon-114x114.png" />
	-->
	
	<link rel="stylesheet" href="http://www.gsminternational.co.uk/css/gsm_topup/style.css" />
	<link rel="stylesheet" href="http://www.gsminternational.co.uk/css/gsm_topup/grids-min.css" />
	<link rel="stylesheet" href="http://www.gsminternational.co.uk/css/gsm_topup/layout.css" />
	<link rel="stylesheet" href="http://www.gsminternational.co.uk/css/gsm_topup/typography.css" />

	<script src="http://www.gsminternational.co.uk/js/libs/modernizr-1.7.min.js"></script>
	<script language="javascript" src="<%=ksContext%>/Scripts/Validate.js" type="text/javascript"></script>
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
	
		document.the_form.submit();
	}
	</script>
</head>

<body>
	<div id="container">
		
		<header class="yui3-g">
			<div class="yui3-u-1-2">
				<img id="logo-primary" class="float-left" src="http://www.gsminternational.co.uk/images/interface/logo_gsm_international_240x114px.png" />
			</div>
			<div class="yui3-u-1-2">
				<p class="feature-text">Specialist communication solutions<br />for international students</p>
			</div>
		</header>

		<div class="yui3-u-1 margin-t-b divider-horizontal"></div>
		
		<!-- Primary content area -->
		<div id="content-area-primary" class="yui3-u-1">
			
			<!-- Raghu, this content can be removed for pages other than the login page -->
			<div class="padder-r">
				<h1>Welcome to GSM Top-up</h1>
				<h2>Mobile top-up currently available for:</h2>
				<img class="phonecard-image" src="http://www.gsminternational.co.uk/images/content/phonecard_lyca_185x118.png" />
				<img class="phonecard-image" src="http://www.gsminternational.co.uk/images/content/phonecard_lebara_185x118.png" />
				<!-- <img class="phonecard-image" src="http://www.gsminternational.co.uk/images/content/phonecard_nomi_185x118.png" />-->
				<H4> <font color="red"> Login Failed.  Please try again. </font> </H4>
				<p>
				Please log in with your username and password. If you do not currently have an account with us please contact us 
				<a href="">or click here</a>
				 to register.	
				</p>
				<!-- Login Form -->
				<form name="the_form" method="post" action="j_security_check">
				User ID <input type="text" name="j_username" maxlength="12" size="13">
				Password <input type="password" name="j_password" maxlength="12" size="13">
				<input class="button" type="button" value="Login" onClick="validate_and_submit()">
				</form>
			</div>
			<!-- End of login page content -->
			
		</div>
		<!-- Primary content area ends -->
		
		<div class="yui3-u-1 margin-t-b divider-horizontal"></div>
		
		<footer class="yui3-g">		
			<div class="yui3-u-1-2">
				<!-- RDFa contact details -->
				<div xmlns:v="http://rdf.data-vocabulary.org/#" typeof="v:Organization" id="contact-details-support" class="secondary-copy padder-r"> 
   					<span property="v:name">For technical issues and customer support</span><br />
   					<em>Tel:</em><span property="v:tel"> +44 (0)20 8200 9345</span><br />
   					<a href="mailto:customer.eezeetel@gmail.com" rel="v:email">customer.eezeetel@gmail.com</a>
				</div>
				<br />
				<div xmlns:v="http://rdf.data-vocabulary.org/#" typeof="v:Organization" id="contact-details-main" class="secondary-copy padder-r"> 
   					For SIM card and phone card orders and our other products and services contact <span property="v:name">GSM International Ltd</span> 
   					<div rel="v:address">
      					<div typeof="v:Address">
         					<span property="v:street-address">58 Braidley Road</span>,
         					<span property="v:locality">Bournemouth</span>,
         					<span property="v:region">Dorset</span>,
         					<span property="v:postal-code">BH2 6LD</span>,
         					<span property="v:country-name">UK</span>.
      					</div>
   					</div>
   					<div rel="v:geo">
      					<span typeof="v:Geo">
         					<span property="v:latitude" content="50.7275"></span>
         					<span property="v:longitude" content="-1.8779"></span>
      					</span>
   					</div>
   					<em>Tel:</em><span property="v:tel"> +44 (0)1202 554087</span><br />
   					<a href="mailto:info@gsminternational.co.uk" rel="v:email">info@gsminternational.co.uk</a><br />
   					<a href="http://www.gsminternational.co.uk/" rel="v:url">gsminternational.co.uk</a>
				</div>
				<!-- RDFa contact details end-->
			</div>
			
			<div id="affiliations" class="yui3-u-1-2">
				<img id="affiliation-logos" class="float-right" src="http://www.gsminternational.co.uk/images/content/affiliation_logos_180x190px.png" />
			</div>
			
		</footer>
				
		<p id="legal" class="tertiary-copy inconspicuous">&copy; GSM International. All rights reserved</p>
		
	</div>

</body>
</html>