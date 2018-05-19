var requiredProducts = {};

function update_required_products(product_id, quantity) {
	if (IsNULL(product_id))
		return;
	if (!CheckNumbers(product_id))
		return;
	if (IsNULL(quantity))
		return;
	if (!CheckNumbers(quantity))
		return;

	if (quantity == 0)
		delete requiredProducts[product_id];
	else
		requiredProducts[product_id] = quantity;

	var totalQuantity = 0;
	for ( var key in requiredProducts)
		totalQuantity += eval(requiredProducts[key]);

	var element = document.getElementById('total_items_id');
	element.innerText = (totalQuantity + " Items");
}

function add_required_products(product_id) {
	if (IsNULL(product_id))
		return;
	if (!CheckNumbers(product_id))
		return;

	var required_quantity = document.getElementsByName(product_id).item(0).value;
	update_required_products(product_id, required_quantity);
}

function IsProductSelected() {
	var bSelected = false;

	for ( var key in requiredProducts) {
		bSelected = true;
		break;
	}

	return bSelected;
}

function validate_and_submit_old() {
	if (!IsProductSelected())
		return;

	var strProducts = new String();
	var first_one = true;

	for ( var key in requiredProducts) {
		if (first_one == true)
			first_one = false;
		else
			strProducts += "&";
		strProducts += (key + "=" + requiredProducts[key]);
	}

	if (IsNULL(strProducts)) {
		alert('Please select a product to buy.');
		return;
	}

	for ( var key in requiredProducts)
		delete requiredProducts[key];
	delete requiredProducts;

	document.the_form.reset();
	document.the_form.action = theContext + "/customer/CheckSelectedProducts.jsp?"
			+ strProducts;
	strProducts = null;
}

function validate_and_submit() 
{
	if (!IsProductSelected())
		return;

	var strProducts = new String();
	var first_one = true;

	for ( var key in requiredProducts) {
		if (first_one == true)
			first_one = false;
		else
			strProducts += "&";
		strProducts += (key + "=" + requiredProducts[key]);
	}

	if (IsNULL(strProducts)) {
		alert('Please select a product to buy.');
		return;
	}

	for ( var key in requiredProducts)
		delete requiredProducts[key];
	delete requiredProducts;
	
	
	var httpObj = getHttpObject();
	if (httpObj == null) {
		alert("Can not get product information");
		return;
	}

	var element = document.getElementById('product_list_field');
	element.innerHTML = "";

	httpObj.onreadystatechange = function() {
		if (httpObj.readyState == 4) {
			var element = document.getElementById('product_list_field');
			element.innerHTML = httpObj.responseText;
			document.the_form.action = theContext + "/customer/ConfirmAndPrintTransaction.jsp";
			httpObj = null;
		}
	}

	delete xmlATProducts;
	xmlATProducts = null;

	var url = theContext
			+ "/customer/CheckSelectedProducts.jsp?" + strProducts;
	httpObj.open("POST", url, true);
	httpObj.send(null);
	strProducts = null;
}

function checkout_now() {
	if (!IsProductSelected())
		return;
	validate_and_submit();
	document.the_form.submit();
}

function do_transaction(product_id) {
	if (IsNULL(product_id))
		return;
	if (!CheckNumbers(product_id))
		return;
	if (!IsProductSelected())
		requiredProducts[product_id] = 1;

	validate_and_submit();
}

function list_products(supplier_id) {
	if (supplier_id == 0)
		return;

	var httpObj = getHttpObject();
	if (httpObj == null) {
		alert("Can not get product information");
		return;
	}

	var element = document.getElementById('product_list_field');
	element.innerHTML = "";

	httpObj.onreadystatechange = function() {
		if (httpObj.readyState == 4) {
			var element = document.getElementById('product_list_field');
			element.innerHTML = httpObj.responseText;
			httpObj = null;
		}
	};

	delete xmlATProducts;
	xmlATProducts = null;

	var url = theContext
			+ "/customer/AJAX_ListProductsBySupplier.jsp?supplier_id="
			+ supplier_id;
	httpObj.open("POST", url, true);
	httpObj.send(null);
}

function confirm_transaction() {
	var element = document.getElementById('product_list_field');
	element.innerHTML = "";
	
	var httpObj = getHttpObject();
	if (httpObj == null) {
		alert("Can not confirm transaction");
		return;
	}	
	
	httpObj.onreadystatechange = function() {
		if (httpObj.readyState == 4) {
			var element = document.getElementById('product_list_field');
			element.innerHTML = httpObj.responseText;
			httpObj = null;
		}
	};

	delete xmlATProducts;
	xmlATProducts = null;

	var url = theContext + "/customer/ConfirmTransaction.jsp";
	httpObj.open("POST", url, true);
	httpObj.send(null);
}

function confirm_and_print_transaction() {
	var element = document.getElementById('product_list_field');
	element.innerHTML = "";
	
	delete xmlATProducts;
	xmlATProducts = null;
	
	document.the_form.action = theContext + "/customer/ConfirmAndPrintTransaction.jsp";
	document.the_form.submit();
	
	document.the_form.action = theContext + "/customer/ConfirmAndPrintTransaction.jsp";
	document.the_form.submit();
	document.the_form.reset();
}

function cancel_transaction() {
	document.the_form.action = theContext + "/customer/CancelTransaction.jsp";
	document.the_form.submit();
	document.the_form.reset();
}

function update_suppliers(type_id, is_sim) {
	var element1 = document.getElementById('product_list_field');
	element1.innerHTML = "";
	var isSIM = 0;
	if (is_sim >= 0 && is_sim <= 1)
		isSIM = is_sim;

	var httpObj = getHttpObject();
	if (httpObj == null) {
		alert("Can not get supplier information");
		return;
	}

	var element = document.getElementById('product_list_field');
	element.innerHTML = "";

	httpObj.onreadystatechange = function() {
		if (httpObj.readyState == 4) {
			var element = document.getElementById('product_list_field');
			element.innerHTML = httpObj.responseText;
			httpObj = null;
		}
	};

	for ( var key in requiredProducts)
		delete requiredProducts[key];

	delete xmlATProducts;
	xmlATProducts = null;

	var url = "/customer/AJAX_ListSuppliersByType.jsp?supplier_type_id=" + type_id
			+ "&is_sim=" + isSIM;
	httpObj.open("POST", url, true);
	httpObj.send(null);
}

function eezeetel_pinless() {
	$('#product_list_field').load('/customer/eezeetel-pinless');
}