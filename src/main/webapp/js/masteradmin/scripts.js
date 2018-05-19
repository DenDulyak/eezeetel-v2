function initializeJS() {
    jQuery('.tooltips').tooltip();
    jQuery('.popovers').popover();

    /*jQuery("html").niceScroll({
        styler: "fb",
        cursorcolor: "#007AFF",
        cursorwidth: '7',
        cursorborderradius: '10px',
        background: '#F7F7F7',
        cursorborder: '',
        autohidemode: 'false',
        zindex: '9999'
    });*/

    /*jQuery("#sidebar").niceScroll({
        styler: "fb",
        cursorcolor: "#007AFF",
        cursorwidth: '5',
        cursorborderradius: '10px',
        background: '#F7F7F7',
        autohidemode: 'false',
        cursorborder: ''
    });*/

    jQuery('#sidebar .sub-menu > a').click(function () {
        var last = jQuery('.sub-menu.open', jQuery('#sidebar'));
        var elem = $(this).find('span.menu-arrow');
        jQuery('.sub', last).slideUp(200);
        var sub = jQuery(this).next();
        if (sub.is(":visible")) {
            elem.removeClass('glyphicon-menu-down');
            elem.addClass('glyphicon-menu-right');
            sub.slideUp(200);
        } else {
            elem.removeClass('glyphicon-menu-right');
            elem.addClass('glyphicon-menu-down');
            sub.slideDown(200);
        }
        var o = (jQuery(this).offset());
        diff = 200 - o.top;
        if (diff > 0)
            jQuery("#sidebar").scrollTo("-=" + Math.abs(diff), 500);
        else
            jQuery("#sidebar").scrollTo("+=" + Math.abs(diff), 500);
    });

    jQuery(function () {
        function responsiveView() {
            var wSize = jQuery(window).width();
            if (wSize <= 768) {
                jQuery('#container').addClass('sidebar-close');
                jQuery('#sidebar > ul').hide();
            }

            if (wSize > 768) {
                jQuery('#container').removeClass('sidebar-close');
                jQuery('#sidebar > ul').show();
            }
        }

        jQuery(window).on('load', responsiveView);
        jQuery(window).on('resize', responsiveView);
    });

    jQuery('.toggle-nav').click(function () {
        if (jQuery('#sidebar > ul').is(":visible") === true) {
            jQuery('#main-content').css({
                'margin-left': '10px'
            });
            jQuery('#sidebar').css({
                'margin-left': '-180px'
            });
            jQuery('#sidebar > ul').hide();
            jQuery("#container").addClass("sidebar-closed");
        } else {
            jQuery('#main-content').css({
                'margin-left': '220px'
            });
            jQuery('#sidebar > ul').show();
            jQuery('#sidebar').css({
                'margin-left': '0'
            });
            jQuery("#container").removeClass("sidebar-closed");
        }
    });
}

jQuery(document).ready(function () {
    initializeJS();
});