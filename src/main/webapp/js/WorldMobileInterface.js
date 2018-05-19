var xmlATProducts = null;

function list_providers() {
    var element1 = document.getElementById('the_suppliers_list');
    element1.innerHTML = "";

    var element = document.getElementById('product_list_field');
    element.innerHTML = "";

    var httpObj = getHttpObject();
    if (httpObj == null) {
        alert("Can not show the interface");
        return;
    }

    httpObj.onreadystatechange = function () {
        if (httpObj.readyState == 4) {
            var element = document.getElementById('product_list_field');
            element.innerHTML = httpObj.responseText;
        }
    }

    var url = theContext + "/customer/AJAX_ShowAITProviders.jsp";
    httpObj.open("POST", url, true);
    httpObj.send(null);
}

function list_services(supplier_id) {
    var element1 = document.getElementById('the_suppliers_list');
    element1.innerHTML = "";

    var element = document.getElementById('product_list_field');
    element.innerHTML = "";

    var httpObj = getHttpObject();
    if (httpObj == null) {
        alert("Can not show the interface");
        return;
    }

    httpObj.onreadystatechange = function () {
        if (httpObj.readyState == 4) {
            var element = document.getElementById('product_list_field');
            element.innerHTML = httpObj.responseText;
        }
    };

    var url = theContext + "/customer/AJAX_DisplayAITInterface.jsp";
    httpObj.open("POST", url, true);
    httpObj.send(null);
}

function getDestinationInfo() {
    if (IsNULL(document.the_form.dest_phone.value)) return;
    if (IsNULL(document.the_form.requester_phone.value)) {
        alert("Please enter the phone number of the person requesting a topup.");
        document.the_form.requester_phone.focus();
        return;
    }

    if (!CheckPhoneNumber(document.the_form.dest_phone.value)) {
        alert("Please enter a valid destination phone number.  It should only have numbers starting with country code.");
        document.the_form.dest_phone.focus();
        return;
    }

    if (!CheckPhoneNumber(document.the_form.requester_phone.value)) {
        alert("Please enter a valid requester phone number.  It should only have numbers starting with country code.");
        document.the_form.requester_phone.focus();
        return;
    }

    var httpObj = getHttpObject();
    if (httpObj == null) {
        alert("Can not get product information");
        return;
    }

    httpObj.onreadystatechange = function () {
        if (httpObj.readyState == 4) {
            var element = document.getElementById('product_list_field');
            element.innerHTML = httpObj.responseText;
            httpObj = null;

            if (window.DOMParser) {
                var parser = new DOMParser();
                xmlATProducts = parser.parseFromString(document.the_form.complete_product_list.value, "text/xml");
            }
            else // Internet Explorer
            {
                xmlATProducts = new ActiveXObject("Microsoft.XMLDOM");
                xmlATProducts.async = false;
                xmlATProducts.loadXML(document.the_form.complete_product_list.value);
            }
        }
    }

    for (var key in requiredProducts)
        delete requiredProducts[key];

    delete xmlATProducts;
    xmlATProducts = null;

    //document.the_form.get_available_products.disabled = true;

    var url = theContext + "/customer/AJAX_GetIATProductList.jsp?dest_phone=" + document.the_form.dest_phone.value +
        "&requester_phone=" + document.the_form.requester_phone.value;
    httpObj.open("POST", url, true);
    httpObj.send(null);
}

String.prototype.equalTo = function (str) {
    return this.toLowerCase() === str.toLowerCase();
}

function change_final_price(theValue) {
    var x = xmlATProducts.getElementsByTagName("prod");
    for (i = 0; i < x.length; i++) {
        if (theValue.equalTo(x[i].getAttribute("val"))) {
            document.the_form.selected_product.value = theValue;
            document.the_form.final_price.value = x[i].getAttribute("ctc");
            document.the_form.retail_price.value = x[i].getAttribute("rp");
            break;
        }
    }
}

function validateAndSubmitMobileTopup() {
    if (document.the_form.products_list.value == 0) {
        alert("Please select a valid amount for topup.");
        return;
    }

    var warningText = "Please make sure the destination mobile number you entered is correct.  All mobile topup transactions are final and refunds are not allowed.";
    warningText += "If the number is not correct, please cancel and proceed with correct destination phone number.";

    if (!confirm(warningText))
        return;

    CheckDatabaseChars(document.the_form.sms_text);

    document.the_form.topup_mobile.disabled = true;

    document.the_form.action = theContext + "/customer/CompleteMobileTopup.jsp";
    document.the_form.submit();
}