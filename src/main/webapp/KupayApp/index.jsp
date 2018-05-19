<%
    StringBuffer baseContext = request.getRequestURL();
    int nIndex = baseContext.lastIndexOf("/");
    String baseContextPath = baseContext.substring(0, nIndex + 1);
    String strFailed = request.getParameter("failed");
    if (strFailed != null && !strFailed.isEmpty())
        strFailed = "Failed to Login.  Please try again.";
    else
        strFailed = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--<base href="<%=baseContextPath%>"></base>--%>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1">
    <title>KUPAY</title>
    <!-- Modernizr -->
    <script src="${pageContext.request.contextPath}/KupayApp/js/libs/modernizr-2.6.2.min.js"></script>
    <!-- jQuery-->
    <script src="${pageContext.request.contextPath}/KupayApp/js/libs/jquery-1.10.2.min.js"></script>
    <!-- framework css --><!--[if gt IE 9]><!-->
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/KupayApp/css/groundwork.css">
    <!--slider css-->
    <script type="text/javascript" src="${pageContext.request.contextPath}/KupayApp/js/jquery-1.9.1.min.js"></script>
    <!-- use jssor.slider.mini.js (40KB) instead for release -->
    <!-- jssor.slider.mini.js = (jssor.js + jssor.slider.js) -->
    <script src="${pageContext.request.contextPath}/KupayApp/js/jssor.js"></script>
    <script src="${pageContext.request.contextPath}/KupayApp/js/jssor.slider.js"></script>
    <!--end-->
    <!-- snippet (syntax highlighting for code examples)-->
    <script src="${pageContext.request.contextPath}/KupayApp/js/demo/jquery.snippet.min.js"></script>
    <link type="text/css" rel="stylesheet"
          href="${pageContext.request.contextPath}/KupayApp/css/demo/jquery.snippet.css">
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/KupayApp/css/style.css">
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/KupayApp/css/ihover.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/KupayApp/js/slider.js"></script>
    <!--for slider-->
    <!--end slider -->
    <!--image gallery-->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="http://cdnjs.cloudflare.com/ajax/libs/gsap/latest/TweenMax.min.js"></script>
    <!--Image effects-->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/KupayApp/css/normalize.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/KupayApp/css/demo.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/KupayApp/css/component.css"/>
    <script src="${pageContext.request.contextPath}/KupayApp/js/modernizr.custom.js"></script>
    <script src="${pageContext.request.contextPath}/KupayApp/Scripts/Validate.js"></script>
    <script>
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
<header class="padded">
    <div class="container">
        <div class="row">
            <div class="one third my_logo">
                <h2 class="logo bounceIn animated">
                    <a href="#" target="_parent">
                        <img src="${pageContext.request.contextPath}/KupayApp/images/bgs/logo.png" alt="FF Fins">
                    </a>
                </h2>
            </div>
            <div class="two thirds">
                <div class="row">
                    <section class="color-9">
                        <nav class="nav red cl-effect-9">
                            <ul>
                                <li><a href="#"><span>Home</span><span>Home</span></a></li>
                                <li><a href="#"><span>Retailer</span><span>Retailer</span></a></li>
                                <li><a href="#"><span>How does it work?</span><span>How does it work?</span></a></li>
                                <li><a href="#"><span>Products</span><span>Products</span></a></li>
                                <li><a href="#"><span>Contact</span><span>Contact</span></a></li>
                            </ul>
                        </nav>
                    </section>
                </div>
            </div>
        </div>
    </div>
</header>
<!--Header end here-->
<!--slider start here-->
<!--slider start here-->

<div class="container">
    <div class="row">
        <div class="one half padded">
            <h4>The fastest web retail payment system in the UK</h4>
        </div>
        <div class="one half padded">
            <form name="the_form" method="POST" class="pure-form pure-form-stacked login" novalidate="novalidate">
                <table>
                    <tr>
                        <td class="blue-bg">Retailer Login</td>
                        <td>
                            <input id="j_username" name="j_username" type="text" placeholder="Username"
                                   required="required"/>
                        </td>
                        <td>
                            <input type="password" id="j_password" name="j_password" type="password"
                                   placeholder="Password" required="required"/>
                        </td>
                        <td>
                            <button class="info" onClick="validate_and_submit()">Login</button>
                        </td>
                    </tr>
                </table>
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

                    <font color="red"></font>
                </div>
            </form>
        </div>
    </div>
    <div class="row">
        <div class="padded" style="border:0px solid #F00;">
            <!-- Jssor Slider Begin -->
            <!-- To move inline styles to css file/block, please specify a class name for each element. -->
            <div id="slider1_container" class=""
                 style="position: relative; top: 0px; left: 0px; width: 960px; height: 300px; overflow: hidden; border:0px solid red">
                <!-- Loading Screen -->
                <div u="loading" style="position: absolute; top: 0px; left: 0px;">
                    <div style="filter: alpha(opacity=70); opacity:0.7; position: absolute; display: block;
                                 background-color: #000; top: 0px; left: 0px;width: 100%;height:100%;">
                    </div>
                    <div style="position: absolute; display: block; background: url(/KupayApp/img/loading.gif) no-repeat center center;
                                 top: 0px; left: 0px;width: 100%;height:100%;">
                    </div>
                </div>
                <!-- Slides Container -->
                <div u="slides" style="cursor: move; position: absolute; left: 0px; top: 0px; width: 1024px; height: 300px;
                             overflow: hidden;">
                    <div>
                        <a u=image href="#">
                            <img src="${pageContext.request.contextPath}/KupayApp/images/7.jpg" title="An awesome picture caption!"/>
                        </a>
                    </div>
                    <div>
                        <a u=image href="#">
                            <img src="${pageContext.request.contextPath}/KupayApp/images/bn2.jpg" title="An awesome picture caption!"/>
                        </a>
                    </div>
                    <div>
                        <a u=image href="#"><img id="eg2" src="${pageContext.request.contextPath}/KupayApp/images/58.jpg"/></a>
                    </div>
                    <div>
                        <a u=image href="#"><img id="eg3" src="${pageContext.request.contextPath}/KupayApp/images/59.jpg"/></a>
                    </div>

                </div>
                <!--#region Bullet Navigator Skin Begin -->
                <!-- Help: http://www.jssor.com/development/slider-with-bullet-navigator-jquery.html -->
                <style>
                    /* jssor slider bullet navigator skin 01 css */
                    /*
                    .jssorb01 div           (normal)
                    .jssorb01 div:hover     (normal mouseover)
                    .jssorb01 .av           (active)
                    .jssorb01 .av:hover     (active mouseover)
                    .jssorb01 .dn           (mousedown)
                    */
                    .jssorb01 {
                        position: absolute;
                    }

                    .jssorb01 div, .jssorb01 div:hover, .jssorb01 .av {
                        position: absolute;
                        /* size of bullet elment */
                        width: 12px;
                        height: 12px;
                        filter: alpha(opacity=70);
                        opacity: .7;
                        overflow: hidden;
                        cursor: pointer;
                        border: #000 1px solid;
                    }

                    .jssorb01 div {
                        background-color: gray;
                    }

                    .jssorb01 div:hover, .jssorb01 .av:hover {
                        background-color: #d3d3d3;
                    }

                    .jssorb01 .av {
                        background-color: #fff;
                    }

                    .jssorb01 .dn, .jssorb01 .dn:hover {
                        background-color: #555555;
                    }
                </style>
                <!-- bullet navigator container -->
                <div u="navigator" class="jssorb01" style="bottom: 16px; right: 10px;">
                    <!-- bullet navigator item prototype -->
                    <div u="prototype"></div>
                </div>
                <!--#endregion Bullet Navigator Skin End -->

                <!--#region Arrow Navigator Skin Begin -->
                <!-- Help: http://www.jssor.com/development/slider-with-arrow-navigator-jquery.html -->
                <style>
                    /* jssor slider arrow navigator skin 05 css */
                    /*
                    .jssora05l                  (normal)
                    .jssora05r                  (normal)
                    .jssora05l:hover            (normal mouseover)
                    .jssora05r:hover            (normal mouseover)
                    .jssora05l.jssora05ldn      (mousedown)
                    .jssora05r.jssora05rdn      (mousedown)
                    */
                    .jssora05l, .jssora05r {
                        display: block;
                        position: absolute;
                        /* size of arrow element */
                        width: 40px;
                        height: 40px;
                        cursor: pointer;
                        background: url(/KupayApp/img/a17.png) no-repeat;
                        overflow: hidden;
                    }

                    .jssora05l {
                        background-position: -10px -40px;
                    }

                    .jssora05r {
                        background-position: -70px -40px;
                    }

                    .jssora05l:hover {
                        background-position: -130px -40px;
                    }

                    .jssora05r:hover {
                        background-position: -190px -40px;
                    }

                    .jssora05l.jssora05ldn {
                        background-position: -250px -40px;
                    }

                    .jssora05r.jssora05rdn {
                        background-position: -310px -40px;
                    }
                </style>
                <!-- Arrow Left -->
                        <span u="arrowleft" class="jssora05l" style="top: 123px; left: 8px;">
                        </span>
                <!-- Arrow Right -->
                        <span u="arrowright" class="jssora05r" style="top: 123px; right: 8px;">
                        </span>

            </div>
            <!-- Jssor Slider End -->

        </div>

    </div>
</div>
<!--slider end here-->

<!--body start here-->

<div class="container pad-top">
    <div class="row padded my_headbox">
        <div class="box red">
            <h2 class="align-center">The fastest web retail payment system in the UK</h2>
        </div>
    </div>
    <!--body1 start here-->
    <div class="row pad-left bounceInLeft animated">
        <h2>Who We Are</h2>

        <p>We are providing international calling cards to make the country to country or in the country to use the
            voice calls, text messaging and data (This is for browsing the internet). This will providing by the nearest
            retailer register our self or one of our own store or register yourself as a retailer, partner or provider.
            We open the stores internationally.</p>
    </div>
    <!--body1 end here-->

    <!--level2 here-->
    <div class="row">

        <div class="one third padded bounceInLeft animated align-center" style="border:0px solid #F00;">
            <img src="${pageContext.request.contextPath}/KupayApp/images/bgs/sk1.png">
            <h4 class=" pad-top">Lightning Fast</h4>

            <p>Our super fast payments system is the quickest in the country and means shorter queuing times for
                customers.</p>
        </div>
        <div class="one third padded  bounceInUp animated align-center" style="border:0px solid #F00;">
            <img src="${pageContext.request.contextPath}/KupayApp/images/bgs/sk2.png">
            <h4 class=" pad-top">Wide Product Range</h4>

            <p>We offer a wide range of products covering SIM, calling cards and mobile topups.</p>
        </div>
        <div class="one third padded bounceInRight animated align-center" style="border:0px solid #F00;">
            <img src="${pageContext.request.contextPath}/KupayApp/images/bgs/sk3.png">
            <h4 class=" pad-top">Great Service</h4>

            <p>All our customers, partners and suppliers get a great service.</p>
        </div>
    </div>
    <!--level 2end-->

    <!--level3 here-->
    <div class="row">
        <div class="row padded my_headbox">
            <div class="box square red">
                <h2 class=" align-center">Discover More</h2>
            </div>
        </div>
        <div class="one third padded bounceInLeft animated " style="border:0px solid #F00;">
            <h2 class=" align-center">Become a Retailer</h2>
            <!-- end normal -->
            <div class="ih-item square effect6 from_top_and_bottom centered">
                <a href="#">
                    <div class="img"><img src="${pageContext.request.contextPath}/KupayApp/images/62.jpg" alt="img">
                    </div>
                    <div class="info">
                        <h3>KUPAY</h3>

                        <p>Become a Retailer</p>
                    </div>
                </a>
            </div>
            <!-- end normal -->

        </div>
        <div class="one third padded  bounceInUp animated " style="border:0px solid #F00;">
            <h2 class=" align-center">Become a Partner</h2>
            <!-- end normal -->
            <div class="ih-item square effect6 from_top_and_bottom centered">
                <a href="#">
                    <div class="img"><img src="${pageContext.request.contextPath}/KupayApp/images/50.jpg" alt="img">
                    </div>
                    <div class="info">
                        <h3>KUPAY</h3>

                        <p>Become a Partner</p>
                    </div>
                </a>
            </div>
            <!-- end normal -->

        </div>
        <div class="one third padded bounceInRight animated " style="border:0px solid #F00;">
            <h2 class=" align-center">Become a Provider</h2>
            <!-- end normal -->
            <div class="ih-item square effect6 from_top_and_bottom centered">
                <a href="#">
                    <div class="img centering"><img src="/KupayApp/images/53.jpg" alt="img"></div>
                    <div class="info">
                        <h3>KUPAY</h3>

                        <p>Become a Provider</p>
                    </div>
                </a>
            </div>
            <!-- end normal -->

        </div>
    </div>
    <!--level 3end-->

    <!--level3 here-->

    <!--level 3end-->
</div>

<!--body end here-->

<!--footer here-->

<footer>
    <div class="row pad-top">
        <div class="container">
            <div class="one third padded" style="border:0px solid #F00;">
                <h3>About Us</h3>

                <p>Pioneers in Mobile Business Applications that improve efficiency and costs of doing business in
                    developing countries. Automation using the power of Mobile Apps and cloud computing.</p>
            </div>
            <div class="one third padded" style="border:0px solid #F00;">
                <h3>Our Services</h3>

                <p>Pioneers in Mobile Business Applications that improve efficiency and costs of doing business in
                    developing countries. Automation using the power of Mobile Apps and cloud computing. </p>
            </div>
            <div class="one third padded" style="border:0px solid #F00;">
                <h3>Contact Info</h3>

                <p>Above Andhra Bank,<br>4th Floor,<br>
                    Karkhana,<br>Secunderabad.</p>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="container padded footer_row">
            <p>&copy; Findfacts 2015.</p>
        </div>
    </div>
</footer>

<!--footer end here-->
<script type="text/javascript" src="${pageContext.request.contextPath}/KupayApp/js/groundwork.all.js"></script>
<script type="text/javascript">
    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-XXXXXXXX-X']);
    _gaq.push(['_trackPageview']);
    (function () {
        var ga = document.createElement('script');
        ga.type = 'text/javascript';
        ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(ga, s);
    })();
</script>
</body>

</html>