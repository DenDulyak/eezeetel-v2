<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">

        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1">
        <title>KUPAY </title>
        <!-- Modernizr -->
        <script src="js/libs/modernizr-2.6.2.min.js"></script>
        <!-- jQuery-->
        <script type="text/javascript" src="js/libs/jquery-1.10.2.min.js"></script>
        <!-- framework css --><!--[if gt IE 9]><!-->
        <link type="text/css" rel="stylesheet" href="css/groundwork.css">

        <!--slider css-->


        <script type="text/javascript" src="js/jquery-1.9.1.min.js"></script>
        <!-- use jssor.slider.mini.js (40KB) instead for release -->
        <!-- jssor.slider.mini.js = (jssor.js + jssor.slider.js) -->
        <script type="text/javascript" src="js/jssor.js"></script>
        <script type="text/javascript" src="js/jssor.slider.js"></script>
        <!--end-->
        <!-- snippet (syntax highlighting for code examples)-->
        <script type="text/javascript" src="js/demo/jquery.snippet.min.js"></script>
        <link type="text/css" rel="stylesheet" href="css/demo/jquery.snippet.css">
        <link type="text/css" rel="stylesheet" href="css/style.css">
        <script type="text/javascript" src="js/slider.js"></script>
        <!--for slider-->
        <!--end slider -->
        <!--image gallery-->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
        <script src="http://cdnjs.cloudflare.com/ajax/libs/gsap/latest/TweenMax.min.js"></script>
        <!--Image effects-->
        <link rel="stylesheet" type="text/css" href="css/normalize.css" />
        <link rel="stylesheet" type="text/css" href="css/demo.css" />
        <link rel="stylesheet" type="text/css" href="css/component.css" />
        <script src="js/modernizr.custom.js"></script>

    </head>

    <body>
        <!--Header end here-->
        <?php include("includes/main_menu.php"); ?>
        <!--Header end here-->

        <!--body start here-->

        <div class="container pad-top">

            <article class="row">
                <section class="two small-tablet thirds padded bounceInDown animated">
                    <h1>Contact Us</h1>
                    <p>We love to hear from you and welcome your feedback. Use the form below to send us an email:</p>
                    <form name="frm" method="post" action="kupay_form.php" enctype="multipart/form-data">
                        <fieldset>
                            <legend>Contact Form</legend>
                            <div class="row">
                                <div class="one small-tablet fourth padded no-pad-bottom-mobile">
                                    <label for="name">Your Name</label>
                                </div>
                                <div class="three small-tablet fourths padded no-pad-top-mobile">
                                    <input id="name" name="name" type="text" placeholder="Your Name" required="">
                                </div>
                            </div>
                            <div class="row">
                                <div class="one small-tablet fourth padded no-pad-bottom-mobile">
                                    <label for="ename">Your Email</label>
                                </div>
                                <div class="three small-tablet fourths padded no-pad-top-mobile">
                                    <input id="email" name="ename" type="email" placeholder="you@example.com" required="required">
                                </div>
                            </div>
                            <div class="row">
                                <div class="one whole pad-left pad-right pad-top">
                                    <label for="msg">Your Message</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="one whole pad-left pad-right pad-bottom">
                                    <textarea id="message" name="msg" placeholder="Write us a message here..."></textarea>
                                </div>
                            </div>
                            <div class="row">
                                <div class="one whole padded align-right">
                                    <button type="submit" class="asphalt">Send Message</button>
                                </div>
                            </div>
                        </fieldset>
                    </form>
                </section>
                <aside class="one small-tablet third padded border-left no-border-mobile bounceInRight animated">
                    <h3>Get in Touch</h3>
                    <h5>
                        <address>
                            <span class="icon-pushpin"></span>&nbsp;Kupay</span><br/>
                        <p><a href="mailto:info@kupay.co.uk">info@kupay.co.uk</a></p>
                            <p><span class="icon-mobile-phone">&nbsp;07930 395647/ 0207 2876777</span></p>
                        </address>
                    </h5>
                    <p><img src="images/call.png"></p>
<!--                    <p class="double-gap-bottom"><a href="https://maps.google.com/maps?f=d&amp;source=s_q&amp;hl=en&amp;geocode=%3BCWTrT4dujQbzFYZxQAIdei-0-Cl7MGKmg4CFgDFQ-cEtDAGZ_Q&amp;q=SOMA+san+francisco&amp;aq=&amp;sll=37.77493,-122.419416&amp;sspn=0.292536,0.657463&amp;t=h&amp;ie=UTF8&amp;hq=&amp;hnear=South+of+Market,+San+Francisco,+California&amp;z=14&amp;vpsrc=0&amp;iwloc=A&amp;daddr=South+of+Market,+San+Francisco,+CA" role="button" target="_blank" class="green noicon"><i class="icon-map-marker gap-right"></i>Get Directions</a></p>-->
<!--                    <iframe width="100%" height="350" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="https://maps.google.com/maps?f=q&amp;source=s_q&amp;hl=en&amp;geocode=&amp;q=SOMA+san+francisco&amp;aq=&amp;sll=37.77493,-122.419416&amp;sspn=0.292536,0.657463&amp;t=h&amp;ie=UTF8&amp;hq=&amp;hnear=South+of+Market,+San+Francisco,+California&amp;z=14&amp;ll=37.777798,-122.409094&amp;output=embed"></iframe>-->
                </aside>
            </article>

        </div>

        <!--body end here-->

        <!--footer here-->

        <?php include("includes/footer.php");?>

        <!--footer end here-->
        <script type="text/javascript" src="js/groundwork.all.js"></script>
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
