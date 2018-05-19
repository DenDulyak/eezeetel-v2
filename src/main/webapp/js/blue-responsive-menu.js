/**
 * Blue Responsive Menu widget code. Simply drop this file into the page and
 * it will initialize itself. There are three types of menu supported:
 * - Fixed Menu (plus Stuck Header)
 * - Sticky Menu
 * - Compact Menu
 *
 * @author Jonathan Darrer
 * @url http://jondarrer.com/html-widgets/blue-responsive-menu
 * @version 0.8.1, 15-Jan-2014
 */

(function ($, window) {
	
	window.brm = window.brm || {};
	var brm = window.brm;
	brm.menus = [];
	
	/* Fixed Menu */
	brm.fixed = {};
	brm.fixed.menus = [];
	
	/* Initializes fixed menus by adding event handlers for window resizing,
	 * clicking and scrolling.
	 */
	brm.fixed.init = function() {
		var menu;
		brm.fixed.menus = [];
		console.log('brm.fixed.init: Called.');
			
		$('.fixed-menu').each(function(index) {
			menu = {"type": "fixed-menu", "item": this, "container": $('.stuck-header'), "children": [], "current": null};
			
			brm.fixed.onresize({"menu": menu});
			brm.fixed.menus.push(menu);
			brm.menus.push(menu);
			
			$(window).resize(function(event) {
				event.menu = menu;
				brm.fixed.onresize(event);
			});
		});
		$('.fixed-menu').on('click', function(event) {
			event.stopPropagation();
			$('.fixed-menu').toggleClass('expanded');
		});
		$('a[href^="#"]').on('click', brm.fixed.onclick);
		if (brm.fixed.menus.length > 0) {
			brm.fixed.onscroll();
			$(document).on('scroll', brm.fixed.onscroll);
			//document.onscroll = brm.fixed.onscroll;
		}
	}
	
	/* Handles fixed menu item clicks by scrolling to the item within the
	 * page.
	 */
	brm.fixed.onclick = function(event, bypass) {
		var i, menu, extra = -12, y = 0, parents, okay = true;
		console.log('brm.fixed.onlick: Called.', this, bypass);
		event.preventDefault();
		
		parents = $(this).parents('.fixed-menu');
		if (parents.length > 0) {
			//($('html.touch').length != 0) && 
			if (!$('html').hasClass('form-desktop') && !parents.hasClass('expanded') && !bypass) {
				//console.log('brm.fixed.onclick(a#[click]): Parents is .fixed-menu, but not .expanded', parents);
				okay = false;
			}
		}
		if (okay === true) {
			for (i = 0; i < brm.fixed.menus.length; i += 1) {
				menu = brm.fixed.menus[i];
				extra -= menu.height;
			}
			//parnets.addClass('manual-selection');
			//$(this).parent();
			
			//$('.fixed-menu li').removeClass('current-menu-item');
			//$(child.parent).addClass('current-menu-item');
			//menu.current = child;
			//return true;
			
			y = $($(this).attr('href')).offset().top + extra + 2;
			console.log('brm.fixed.onclick(a#[click]): Scroll to', y);
			setTimeout(function() {parents.removeClass('manual-selection'); brm.fixed.onscroll();}, 520);
			$('html, body').animate({
				scrollTop: y
			}, 500);
		}
	}
	
	/* Handles scrolling on fixed menu pages by setting the menu item as current-menu-item
	 * when necessary.
	 */
	brm.fixed.onscroll = function(event) {
		var menu, child, i, j, scrollTop = $(window).scrollTop(), scrollTo = 0;
		//console.log('brm.fixed.onscroll: Called.');
		
		for (i = 0; i < brm.fixed.menus.length; i += 1) {
			menu = brm.fixed.menus[i];
			if ($('.fixed-menu').hasClass('manual-selection')) {
				return true;
			}
			scrollTo = scrollTop + menu.height + 12;
			for (j = 0; j < menu.children.length; j += 1) {
				child = menu.children[j];
				if (scrollTo > child.offsetY && scrollTo < child.offsetZ && child != menu.current) {
					console.log('brm.fixed.onscroll: Change current-menu-item item to', scrollTo, child);
					$('.fixed-menu li').removeClass('current-menu-item');
					$(child.parent).addClass('current-menu-item');
					menu.current = child;
					return true;
				}
			}
			/*if (menu.children.length > 0) {
				if (scrollTo < menu.children[0].offsetY) {
					$('.fixed-menu li').removeClass('current-menu-item');
					$(menu.children[0].parent).addClass('current-menu-item');
					menu.current = menu.children[0];
					return true;	
				} else if ((scrollTo + $(window).height()) > child.offsetZ) {
					$('.fixed-menu li').removeClass('current-menu-item');
					$(child.parent).addClass('current-menu-item');
					menu.current = child;
					return true;	
				}
			}*/
		}
	}
	
	/* Handles window resizing on fixed menu pages by resetting link offsets
	 * and other things.
	 */
	brm.fixed.onresize = function(event) {
		var width = $(window).width(), form;
		console.log('brm.fixed.onresize: Called.');
		
		event.menu.height = $(event.menu.container).height();
		$('.fixed-menu-filler').css('height', event.menu.height + 'px');
		brm.fixed.links(event.menu);
		
		if (ezt.onresize == null) {
			if (width < 768) {
				form = 'form-mobile';
			} else if (width < 980) {
				form = 'form-tablet';
			} else {
				form = 'form-desktop';
			}
			$('html').removeClass('form-mobile form-tablet form-desktop');
			$('html').addClass(form);
		}
	}
	
	brm.fixed.links = function(menu) {
		var offsetTop;
		
		menu.children = [];
		$('a[href^="#"]', menu.item).each(function(x) {
			target = $($(this).attr('href'));
			offsetTop = $(target).prop('offsetTop');
			menu.children.push({"item": this, "parent": $(this).parent(), "offsetY": offsetTop, "offsetZ": offsetTop + $(target).height()});
		});
	}
	
	
	/* Sticky Menu */
	
	brm.sticky = {};
	brm.sticky.menus = [];
	
	brm.sticky.init = function() {
		var menu;
		console.log('brm.sticky.init: Called.');
		brm.sticky.menus = [];
			
		$('.sticky-menu').each(function(index) {
			menu = {"type": "sticky-menu", "item": this, "offsetY": $(this).offset().top};
			brm.sticky.menus.push(menu);
			brm.menus.push(menu);
			//brm.offsetY = $(this).prop('offsetTop');
			//console.log('brm.run[.sticky-menu]', this, index);
		});
		
		// Add the onscroll handler and call it now
		if (brm.sticky.menus.length > 0) {
			brm.sticky.onscroll();
			$(document).on('scroll', brm.sticky.onscroll);
			//document.onscroll = brm.sticky.onscroll;
		}
	}
	
	brm.sticky.onscroll = function() {
		var menu, child, i, scrollTop = $(window).scrollTop();
		//console.log('brm.sticky.onscroll: Called.');
		
		for (i = 0; i < brm.sticky.menus.length; i += 1) {
			menu = brm.sticky.menus[i];
			if (scrollTop > menu.offsetY) {
				console.log('brm.onScroll[sticky-menu]: scrollTop, menu.offsetY', scrollTop, menu.offsetY);
				$(menu.item).addClass('stuck');
			} else {
				$(menu.item).removeClass('stuck');
			}
		}
	}
	
	
	/* Compact Menu */
	
	brm.compact = {};
	brm.compact.init = function() {
		console.log('brm.compact.init: Called.');
		
		$('.compact-menu').on('click', function(e) {
			e.stopPropagation();
			$('.compact-menu').toggleClass('expanded');
		});
		/*$('.compact-menu a').on('click', function(e) {
			e.stopPropagation();
			$('.compact-menu').toggleClass('expanded');
		});*/
	}
	
	
	/* Unveil */
	brm.unveil = {};
	brm.unveil.init = function() {
		console.log('brm.unveil.init: Called.');
		
		brm.unveil.items = $('.unveil');
		if (brm.unveil.items.length > 0) {
			brm.unveil.onscroll();
			$(document).on('scroll', brm.unveil.onscroll);
		}
	}
	
	brm.unveil.inviewport = function(item) {
		var rect = item.getBoundingClientRect();
		
		return (rect.top >= 0 && rect.left >= 0 && rect.top <= (window.innerHeight || document.documentElement.clientHeight));
	}
	
	brm.unveil.onscroll = function(e) {
		var i, items = brm.unveil.items;
		for (i = 0; i < items.length; i += 1) {
			if (brm.unveil.inviewport(items[i]) === true) {
				$(items[i]).addClass('unveiled');
				items.splice(i, 1);
				i -= 1;
			}
		}
	}
	
	
	/* General */
	
	$(function() {
		console.log('brm[onload]: Called.');
		
		setTimeout(brm.run, 500);
	});
	
	brm.run = function() {
		console.log('brm.run: Called.');
		
		brm.fixed.init();
		brm.sticky.init();
		brm.compact.init();
		brm.unveil.init();
	}
})(jQuery, window);