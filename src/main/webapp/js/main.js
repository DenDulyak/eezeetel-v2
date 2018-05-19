(function($, window) {
	window.ezt = window.ezt || {};
	var ezt = window.ezt;
	
	ezt.validateEmail = function(email) {
		if (email == null || email === '' || typeof email !== 'string') {
			return false;
		} else {
			return email.match(/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,6}$/i);
		}
	}
	
	/* Handles window resizing on fixed menu pages by resetting link offsets
	 * and other things.
	 */
	ezt.onresize = function(event) {
		var width = $(window).width(), form;
		console.log('ezt.onresize: Called.');
		
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
	
	ezt.login = {};
	ezt.login.onsubmit = function(event) {
		var username, password;
		console.log('ezt.contact.onsubmit: Called.');
		username = $('#username').val();
		password = $('#password').val();
		
		// Validate form
		$('.error-message-container').removeClass('show');
		if (username == null || username === '') {
			$('.username .error-message').html('Please enter a username');
			$('.username.error-message-container').addClass('show');
			$('#username').focus();
			return false;
		}
		if (password == null || password === '') {
			$('.password .error-message').html('Please enter a password');
			$('.password.error-message-container').addClass('show');
			$('#password').focus();
			return false;
		}
		
		// @Todo Do ajax login submission
		
		return true;
	}
	ezt.login.ontoggle = function(event) {
		if (!$('html').hasClass('form-desktop')) {
			$('#login-form-container').toggleClass('expanded');
		}
	}
	
	ezt.contact = {};
	ezt.contact.onsubmit = function(event) {
		var name, email, phone, message, scrollTo;
		console.log('ezt.contact.onsubmit: Called.');
		name = $('#name').val();
		email = $('#email').val();
		phone = $('#phone').val();
		message = $('#message').val();
		
		// Validate form
		$('.error-message-container').removeClass('show');
		if (name == null || name === '') {
			$('.name .error-message').html('Please enter a name');
			$('.name.error-message-container').addClass('show');
			$('#name').focus();
			$('a[href="#contact-us"]').trigger('click', true);
			$('.fixed-menu').toggleClass('expanded');
			return false;
		}
		if (!ezt.validateEmail(email)) {
			$('.email .error-message').html('Please enter a valid email address');
			$('.email.error-message-container').addClass('show');
			$('#email').focus();
			$('a[href="#contact-us"]').trigger('click', true);
			$('.fixed-menu').toggleClass('expanded');
			return false;
		}
		
		// @Todo Do ajax form submission
		
		// Success message
		$('#thank-you-message').removeClass('hidden');
		event.preventDefault();
		scrollTo = $('#thank-you-message').prop('offsetTop') - ($('.stuck-header').height() + 12);
		//console.log('ezt.contact.onsubmit: .stuck-header height and #thank-you-message offsetTop:', $('.stuck-header').height(), $('#thank-you-message').prop('offsetTop'), scrollTo);
		$('html, body').animate({
			scrollTop: scrollTo
		}, 500);
		return false;
	}
	
	
	/* General */
	
	$(function() {
		console.log('ezt[onload]: Called.');
		
		ezt.init();
	});
	
	ezt.init = function() {
		var width = $(window).width(), form;
		console.log('ezt.init: Called.');
		
		$('form.login').on('submit', ezt.login.onsubmit);
		$('form.contact').on('submit', ezt.contact.onsubmit);
		$('#login-form-toggle').on('click', ezt.login.ontoggle);
		
		$(window).resize(ezt.onresize);
		ezt.onresize();
	}
	
})(jQuery, window);