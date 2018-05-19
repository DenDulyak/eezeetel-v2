<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
<html lang="en">
<head>
    <base href="<%=baseContextPath%>">
    <!--[if lte IE 6]></base><![endif]-->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="Generator" content="Serif WebPlus X5 (13.0.3.029)">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
    <title>Welcome to KAS Global | Home</title>
    <script type="text/javascript" src="wpscripts/jquery.js"></script>
    <script type="text/javascript" src="wpscripts/jquery.timers.js"></script>
    <script type="text/javascript" src="wpscripts/jquery.wpgallery.js"></script>

    <script type="text/javascript">
        var nImgNum_pg_1 = 0;
        wp_imgArray_pg_1 = new Array();
        wp_imgArray_pg_1[nImgNum_pg_1++] = new wp_galleryimage("wpimages/e63783d998dc.jpg", 886, 333, "wpimages/e63783d998dct.jpg", "");
        wp_imgArray_pg_1[nImgNum_pg_1++] = new wp_galleryimage("wpimages/6af5fe21e254.jpg", 886, 333, "wpimages/6af5fe21e254t.jpg", "");
        wp_imgArray_pg_1[nImgNum_pg_1++] = new wp_galleryimage("wpimages/275bf318cef0.jpg", 886, 333, "wpimages/275bf318cef0t.jpg", "");
        wp_imgArray_pg_1[nImgNum_pg_1++] = new wp_galleryimage("wpimages/b4996d361e89.jpg", 886, 333, "wpimages/b4996d361e89t.jpg", "");
        wp_imgArray_pg_1[nImgNum_pg_1++] = new wp_galleryimage("wpimages/5b5bcaa2c04f.jpg", 886, 333, "wpimages/5b5bcaa2c04ft.jpg", "");
    </script>
    <style type="text/css">
        body {
            margin: 0px;
            padding: 0px;
        }

        .Body-P {
            margin: 0.0px 0.0px 0.0px 0.0px;
            text-align: right;
            font-weight: 400;
        }

        .Body-P-P0 {
            margin: 0.0px 0.0px 0.0px 0.0px;
            text-align: justify;
            font-weight: 400;
        }

        .Body-C {
            font-family: "Georgia", serif;
            color: #1f5b8b;
            font-size: 13.0px;
            line-height: 1.23em;
        }

        .Body-C-C0 {
            font-family: "Georgia", serif;
            color: #ffffff;
            font-size: 13.0px;
            line-height: 1.23em;
        }

        .Body-C-C1 {
            font-family: "Georgia", serif;
            color: #ffffff;
            font-size: 11.0px;
            line-height: 1.27em;
        }

        .Body-C-C2 {
            font-family: "Georgia", serif;
            font-size: 13.0px;
            line-height: 1.23em;
        }

        .Body-C-C3 {
            font-family: "Georgia", serif;
            color: #0000ff;
            font-size: 13.0px;
            line-height: 1.23em;
        }

        .Hyperlink-C {
            font-family: "Georgia", serif;
            color: #ffffff;
            font-size: 13.0px;
            line-height: 1.23em;
        }

        .Heading-1-C {
            font-family: "Baskerville Old Face", serif;
            font-weight: 700;
            color: #ffffff;
            font-size: 21.0px;
            line-height: 1.14em;
        }

        .Body-C-C4 {
            font-family: "Georgia", serif;
            font-weight: 700;
            color: #ffffff;
            font-size: 15.0px;
            line-height: 1.20em;
        }

        .Button1, .Button1:link, .Button1:visited {
            background-position: 0px -48px;
            text-decoration: none;
            display: block;
            position: absolute;
            background-image: url(wpimages/wp35712dda_06.png);
        }

        .Button1:focus {
            outline-style: none;
        }

        .Button1:hover {
            background-position: 0px -96px;
        }

        .Button1 span, .Button1:link span, .Button1:visited span {
            color: #000000;
            font-family: Georgia, serif;
            font-weight: normal;
            text-decoration: none;
            text-align: center;
            text-transform: none;
            font-style: normal;
            left: 2px;
            top: 10px;
            width: 117px;
            height: 17px;
            font-size: 13px;
            display: block;
            position: absolute;
            cursor: pointer;
        }

        .Button2, .Button2:link, .Button2:visited {
            background-position: 0px 0px;
            text-decoration: none;
            display: block;
            position: absolute;
            background-image: url(wpimages/wp35712dda_06.png);
        }

        .Button2:focus {
            outline-style: none;
        }

        .Button2:hover {
            background-position: 0px -96px;
        }

        .Button2:active {
            background-position: 0px -48px;
        }

        .Button2 span, .Button2:link span, .Button2:visited span {
            color: #ffffff;
            font-family: Georgia, serif;
            font-weight: normal;
            text-decoration: none;
            text-align: center;
            text-transform: none;
            font-style: normal;
            left: 2px;
            top: 10px;
            width: 117px;
            height: 17px;
            font-size: 13px;
            display: block;
            position: absolute;
            cursor: pointer;
        }

        .Button2:hover span {
            color: #000000;
        }

        .Button2:active span {
            color: #000000;
        }
    </style>
    <script type="text/javascript" src="wpscripts/jspngfix.js"></script>
    <script type="text/javascript" src="/js/validate.js"></script>
    <link rel="stylesheet" href="wpscripts/wpstyles.css" type="text/css">
    <script type="text/javascript">var blankSrc = "wpscripts/blank.gif";
    </script>
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

    <script type="text/javascript">
        $(document).ready(function () {

            $('#wp_gallery_pg_1').wpgallery({
                imageArray: wp_imgArray_pg_1,
                nTotalImages: nImgNum_pg_1,
                nGalleryLeft: 56,
                nGalleryTop: 284,
                nGalleryWidth: 886,
                nGalleryHeight: 333,
                nImageDivLeft: 0,
                nImageDivTop: 0,
                nImageDivWidth: 886,
                nImageDivHeight: 333,
                nControlBarStyle: 0,
                nControlBarExternalTop: 10,
                bNavBarOnTop: true,
                bShowNavBar: false,
                nNavBarAlignment: 0,
                strNavBarColour: 'none',
                nNavBarOpacity: 1.0,
                nNavBarIconWidth: 24,
                nNavBarIconHeight: 24,
                bShowCaption: false,
                bCaptionCount: true,
                strCaptionColour: '#ffffff',
                nCaptionOpacity: 0.6,
                strCaptionTextColour: '#000000',
                nCaptionFontSize: 12,
                strCaptionFontType: 'Courier New,Arial,_sans',
                strCaptionAlign: 'center',
                strCaptionFontWeight: 'normal',
                bShowThumbnails: false,
                nThumbStyle: 1,
                nThumbPosition: 0,
                nThumbLeft: 30,
                nThumbTop: 223,
                nThumbOpacity: 0.5,
                nTotalThumbs: 5,
                nThumbSize: 40,
                nThumbSpacing: 10,
                bThumbBorder: true,
                strThumbBorderColour: '#000000',
                strThumbBorderHoverColour: '#ffffff',
                strThumbBorderActiveColour: '#ffffff',
                bShowThumbnailArrows: true,
                nThumbButtonSize: 24,
                nThumbButtonIndent: 50,
                nColBorderWidth: 2,
                nTransitionStyle: 2,
                nStaticTime: 4000,
                nTransitTime: 4000,
                bAutoplay: true,
                loadingButtonSize: 38,
                bPageCentred: true,
                nPageWidth: 1000,
                nZIndex: 100,
                loadingButtonSrc: 'wpimages/wpgallery_loading_1.gif',
                blankSrc: 'wpscripts/blank.gif',
                rewindButtonSrc: 'wpimages/wpgallery_rewind_0.png',
                prevButtonSrc: 'wpimages/wpgallery_previous_0.png',
                playButtonSrc: 'wpimages/wpgallery_play_0.png',
                pauseButtonSrc: 'wpimages/wpgallery_pause_0.png',
                nextButtonSrc: 'wpimages/wpgallery_next_0.png',
                forwardButtonSrc: 'wpimages/wpgallery_forward_0.png',
                thumbRewindButtonSrc: 'wpimages/wpgallery_rewind_0.png',
                thumbForwardButtonSrc: 'wpimages/wpgallery_forward_0.png',
                rewindoverButtonSrc: 'wpimages/wpgallery_rewind_over_0.png',
                prevoverButtonSrc: 'wpimages/wpgallery_previous_over_0.png',
                playoverButtonSrc: 'wpimages/wpgallery_play_over_0.png',
                pauseoverButtonSrc: 'wpimages/wpgallery_pause_over_0.png',
                nextoverButtonSrc: 'wpimages/wpgallery_next_over_0.png',
                forwardoverButtonSrc: 'wpimages/wpgallery_forward_over_0.png',
                thumboverRewindButtonSrc: 'wpimages/wpgallery_rewind_over_0.png',
                thumboverForwardButtonSrc: 'wpimages/wpgallery_forward_over_0.png',
                strRewindToolTip: 'Reverse',
                strPreviousToolTip: 'Previous',
                strPlayToolTip: 'Play',
                strPauseToolTip: 'Pause',
                strNextToolTip: 'Next',
                strForwardToolTip: 'Forward',
                strThumbRewindToolTip: 'Reverse',
                strThumbForwardToolTip: 'Forward'
            });

        })
    </script>

</head>

<body text="#000000" style="background-color:#16bdec; text-align:center; height:1000px;">
<div style="background-color:transparent;text-align:left;margin-left:auto;margin-right:auto;position:relative;width:1000px;height:1000px;">
    <div id="txt_93"
         style="position:absolute;left:38px;top:935px;width:925px;height:65px; background-color:#1f5b8b;overflow:hidden;">
        <p class="Wp-Body-P"><span class="Body-C"><br></span></p>
    </div>
    <div id="txt_18" style="position:absolute;left:50px;top:946px;width:902px;height:47px;overflow:hidden;">
        <p class="Wp-Body-P"><span class="Body-C-C0">Copyright 2012 © KAS Global Limited </span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <span class="Body-C-C1">Registered in England and Wales Reg no: 07829639 </span></p>
    </div>
    <img src="wpimages/wp1ea23245_06.png" width="925" height="273" border="0" id="pic_15" alt="" onload="OnLoadPngFix()"
         style="position:absolute;left:37px;top:0px;">

    <div id="nav_413" style="position:absolute;left:303px;top:219px;width:667px;height:64px;">
        <a href="index.jsp" id="nav_413_B1" class="Button1"
           style="display:block;position:absolute;left:28px;top:5px;width:122px;height:48px;"><span>Home</span></a>
        <a href="about.html" id="nav_413_B2" class="Button2"
           style="display:block;position:absolute;left:150px;top:5px;width:122px;height:48px;"><span>About Us</span></a>
        <a href="howdoesitwork.html" id="nav_413_B3" class="Button2"
           style="display:block;position:absolute;left:272px;top:5px;width:122px;height:48px;"><span>How does it work</span></a>
        <a href="products.html" id="nav_413_B4" class="Button2"
           style="display:block;position:absolute;left:394px;top:5px;width:122px;height:48px;"><span>Products</span></a>
        <a href="ContactUs.html" id="nav_413_B5" class="Button2"
           style="display:block;position:absolute;left:516px;top:5px;width:122px;height:48px;"><span>Contact Us</span></a>
    </div>
    <div id="txt_94"
         style="position:absolute;left:38px;top:916px;width:925px;height:18px; background-color:#f3a41a;overflow:hidden;">
        <p class="Wp-Body-P"><span class="Body-C-C2"><br></span></p>
    </div>
    <div id="txt_91"
         style="position:absolute;left:37px;top:273px;width:925px;height:653px; background-color:#ffffff;overflow:hidden;">
        <p class="Wp-Body-P"><span class="Body-C-C2"><br></span></p>
    </div>
    <div id="txt_3" style="position:absolute;left:59px;top:695px;width:552px;height:159px;overflow:hidden;">
        <p class="Body-P-P0"><span class="Body-C-C2">Kas Global is one of the UK’s Webpay retailer networks. We sell local and international
    mobile top ups to retailers, wholesalers and individual customers. Please see the
    list of cards that we sell on the </span><span class="Body-C-C3"><a href="products.html"
                                                                        style="color:#0000ff;text-decoration:none;">product</a></span><span
                class="Body-C-C2"> page.</span></p>

        <p class="Body-P-P0"><span class="Body-C-C2"><br></span></p>

        <p class="Body-P-P0"><span class="Body-C-C2">Started in 2012, we have already managed to establish a strong and reliable relationships
    with large number of customers. This is not the end; we aim to reach out to many
    more customers. More information about us and to know how we can cater for your need
    please visit the about us section.</span></p>
    </div>
    <img src="wpimages/wpd72ea733_06.png" width="550" height="2" border="0" id="pcrv_12" alt="" onload="OnLoadPngFix()"
         style="position:absolute;left:60px;top:918px;">
    <img src="wpimages/wp6355e252_06.png" width="80" height="28" border="0" id="qs_1" alt="" onload="OnLoadPngFix()"
         style="position:absolute;left:55px;top:869px;">

    <div id="txt_15" style="position:absolute;left:66px;top:874px;width:50px;height:18px;overflow:hidden;">
        <p class="Wp-Hyperlink-P"><span class="Hyperlink-C"><a class="Wp-Hyperlink-P-H" href="about.html"
                                                               style="text-decoration:none;">More</a></span></p>
    </div>
    <img src="wpimages/wp412173e5_06.png" width="12" height="12" border="0" id="qs_14" alt="" onload="OnLoadPngFix()"
         style="position:absolute;left:106px;top:878px;">
    <img src="wpimages/wp25f6fbb0_06.png" width="2" height="237" border="0" id="pcrv_675" alt="" onload="OnLoadPngFix()"
         style="position:absolute;left:625px;top:653px;">

    <div id="txt_108"
         style="position:absolute;left:638px;top:696px;width:305px;height:188px; background-color:#f9d667;overflow:hidden;">
        <p class="Wp-Body-P"><span class="Body-C-C2"><%=strFailed%><br></span></p>

        <p class="Wp-Body-P"><span class="Body-C-C2"><br></span></p>

        <p class="Wp-Body-P"><span class="Body-C-C2"> &nbsp;&nbsp;&nbsp;&nbsp;Login</span></p>

        <p class="Wp-Body-P"><span class="Body-C-C2"><br></span></p>

        <p class="Wp-Body-P"><span class="Body-C-C2"><br></span></p>

        <p class="Wp-Body-P"><span class="Body-C-C2"> &nbsp;&nbsp;&nbsp;&nbsp;Password</span></p>
    </div>
    <form name="the_form" method="post" action="">
        <input type="button" style="position:absolute; left:650px; top:850px; width:73px; height:22px;" id="butn_5"
               name="Login" value="Login" onClick="validate_and_submit()">
        <input type="button" style="position:absolute; left:738px; top:849px; width:76px; height:22px;" id="butn_3"
               name="Reset" value="Reset">
        <input type="text" id="edit_3" id="j_username" name="j_username" value=""
               style="position:absolute; left:721px; top:724px; width:197px;">
        <input type="password" id="edit_4" id="j_password" name="j_password" value=""
               style="position:absolute; left:720px; top:773px; width:197px;">
    </form>
    <div id="txt_106"
         style="position:absolute;left:59px;top:643px;width:335px;height:32px; background-color:#ba1f1f;overflow:hidden;padding:0px -1px 0px 1px;">
        <p class="Wp-Body-P"><span class="Body-C-C2"><br></span></p>
    </div>
    <div id="txt_2_C01" style="position:absolute;left:67px;top:649px;width:279px;height:32px;">
        <div class="Wp-Heading-1-P">
            <span class="Heading-1-C">Welcome to KAS Global</span></div>
    </div>
    <img src="wpimages/wp6a2145f3_06.png" width="305" height="1" border="0" id="pcrv_676" alt="" onload="OnLoadPngFix()"
         style="position:absolute;left:638px;top:918px;">

    <div id="txt_114"
         style="position:absolute;left:638px;top:651px;width:305px;height:32px; background-color:#ba1f1f;overflow:hidden;padding:0px -1px 0px 1px;">
        <p class="Wp-Body-P"><span class="Body-C-C2"><br></span></p>
    </div>
    <div id="txt_115" style="position:absolute;left:644px;top:657px;width:293px;height:22px;overflow:hidden;">
        <p class="Wp-Body-P"><span class="Body-C-C4">Customer login</span></p>
    </div>
    <div id="wp_gallery_pg_1"
         style="position:absolute; left:56px; top:284px; width:886px; height:333px; overflow:hidden;"></div>
</div>
</body>
</html>