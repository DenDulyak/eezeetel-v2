<!DOCTYPE html>
<html lang="en" class="no-js"><!--<![endif]--><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <title>TaajTopup - Communications solutions</title>
    <meta name="description" content="Providers of mobile phones, sim cards, phone cards, mobile internet and other communications solutions">
    <meta name="author" content="Arjun Prakash, arjun9916@gmail.com">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="./taajtopup/taajtopup files/style.css">
    <link rel="stylesheet" href="./taajtopup/taajtopup files/grids-min.css">
    <link rel="stylesheet" href="./taajtopup/taajtopup files/layout.css">
    <link rel="stylesheet" href="./taajtopup/taajtopup files/typography.css">

    <script src="./taajtopup/taajtopup files/modernizr-1.7.min.js.download"></script>
    <style>@media print {#ghostery-purple-box {display:none !important}}</style>
    <script language="javascript" src="./taajtopup/taajtopup files/validate.js" type="text/javascript"></script>
    <script language="javascript">
        function validate_and_submit() {
            if (IsNULL(document.the_form.j_username.value)) {
                alert("Please enter proper user id");
                document.the_form.j_username.focus();
                return;
            }

            if (!AlphaNumerals(document.the_form.j_username.value)) {
                alert("User ID can only have alphabets and digits");
                document.the_form.j_username.focus();
                return;
            }

            if (IsNULL(document.the_form.j_password.value)) {
                alert("Please enter proper password");
                document.the_form.j_password.focus();
                return;
            }

            if (!AlphaNumerals(document.the_form.j_password.value)) {
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
<div id="container">

    <header class="yui3-g">
        <div class="yui3-u-1-2">
            <img id="logo-primary" class="float-left" src="./taajtopup/taajtopup files/taajtopup_240_114px.png">
        </div>
		<div class="yui3-u-1-2">
		<p>
                Please log in with your username and password. If you do not currently have an account with us please
                contact us
                <a href="">or click here</a>
                to register.
            </p>
            <!-- Login Form -->
            <form name="the_form" method="post" action="">
               <table>
			   <tr>
                <th>User ID <input type="text" id="j_username" name="j_username" maxlength="12" size="13"></th>
                <th>Password <input type="password" id="j_password" name="j_password" maxlength="12" size="13"></th>
                <th>Click here <input class="button" type="button" value="Login" onclick="validate_and_submit()"></th>
				</tr>
			    </table>
            </form>
		</div>
    </header>

    <div class="yui3-u-1 margin-t-b divider-horizontal"></div>

    <!-- Primary content area -->
    <div id="content-area-primary" class="yui3-u-1">

        <!-- Raghu, this content can be removed for pages other than the login page -->
        <div class="float-left">
            <h1>Welcome to TaajTopup</h1>

            <h1>Mobile top-up, International calling cards and International Mobile top-ups are available here!</h1>
            <img src="./taajtopup/taajtopup files/network_logo_110x110px_EE.png">
            <img src="./taajtopup/taajtopup files/network_logo_110x110px_O2.png">
            <img src="./taajtopup/taajtopup files/network_logo_110x110px_Orange.png">
            <img src="./taajtopup/taajtopup files/network_logo_110x110px_T_Mobile.png">
            <br>
            <img src="./taajtopup/taajtopup files/network_logo_110x110px_Vodafone.png">
            <img src="./taajtopup/taajtopup files/network_logo_110x110px_3.png">
            <img src="./taajtopup/taajtopup files/network_logo_110x110px_Lebara.png">
            <img src="./taajtopup/taajtopup files/network_logo_110x110px_Lyca.png">
            <br>
            <img src="./taajtopup/taajtopup files/network_logo_110x110px_White.png">
            <img src="./taajtopup/taajtopup files/network_logo_110x110px_GiffGaff.png">
            <img src="./taajtopup/taajtopup files/network_logo_110x110px_Virgin.png">
            <img src="./taajtopup/taajtopup files/network_logo_110x110px_Now.png">
        </div>

		<div class="float-right">
		
        <!-- End of login page content -->
		</div>
    </div>
    <!-- Primary content area ends -->

    <div class="yui3-u-1 margin-t-b divider-horizontal"></div>

    <footer class="yui3-g">
        <div class="yui3-u-1-2">
            <!-- RDFa contact details -->
            <br>

            <div xmlns:v="http://rdf.data-vocabulary.org/#" typeof="v:Organization" id="contact-details-main" class="secondary-copy padder-r">
                For SIM card and phone card orders and our other products and services contact <span property="v:name">TaajTopup.<br /> </span>

               
                <em>Tel:</em><span property="v:tel"> 0044 2071019442</span><br>
                <em>Fax:</em><span property="v:tel"> 0044 2034417200</span><br>
                <a href="mailto:taajtopup@gmail.com" rel="v:email">taajtopup@gmail.com</a><br>
                <a href="http://www.TaajTopup.com/" rel="v:url">www.TaajTopup.com</a>
            </div>
            <!-- RDFa contact details end-->
        </div>

    </footer>

    <p id="legal" class="tertiary-copy inconspicuous">© TaajTopup. All rights reserved</p>

</div>


</body></html>