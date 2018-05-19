function list_sim_products(supplier_id) {
    if (supplier_id == null || supplier_id <= 0) return;
    var httpObj = getHttpObject();
    if (httpObj == null) {
        alert("Can not get sim products information");
        return;
    }

    var element = document.getElementById('product_list_field');
    element.innerHTML = "";

    httpObj.onreadystatechange = function () {
        if (httpObj.readyState == 4) {
            var element = document.getElementById('product_list_field');
            element.innerHTML = httpObj.responseText;
            httpObj = null;
        }
    };

    if (xmlATProducts != null) {
        delete xmlATProducts;
        xmlATProducts = null;
    }

    var url = "/customer/sim/AJAX_GetSIMCardProductsInfo.jsp?supplier_id=" + supplier_id;
    httpObj.open("POST", url, true);
    httpObj.send(null);
}

function do_sim_transaction(product_id) {
    if (IsNULL(product_id)) return;
    if (!CheckNumbers(product_id)) return;
    var requiredProduct = document.getElementsByName(product_id).item(0).value;
    if (requiredProduct <= 0) {
        alert("Please select a new phone number to continue.");
        return false;
    }

/*    document.the_form.reset();
    document.the_form.action = "/customer/sim/CheckSelectedSimProducts.jsp?sim_id=" + requiredProduct;
    document.the_form.submit();*/

    document.location = "/customer/sim/CheckSelectedSimProducts.jsp?sim_id=" + requiredProduct;
}

function updateMobileTransaction(transaction_obj) {
    if (IsNULL(transaction_obj.value)) return;
    if (!CheckNumbers(transaction_obj.value)) return;

    if (transaction_obj.checked) {
        for (var i = 1; i <= 10; i++) {
            var ele_name = "mob_topup_" + i;
            var ele_obj = document.getElementsByName(ele_name);
            if (ele_obj) {
                if (IsNULL(ele_obj.item(0).value)) {
                    ele_obj.item(0).value = transaction_obj.value;
                    break;
                }
            }
            else
                break;
        }
    }
    else {
        for (var i = 1; i <= 10; i++) {
            var ele_name = "mob_topup_" + i;
            var ele_obj = document.getElementsByName(ele_name);
            if (ele_obj) {
                if (ele_obj.item(0).value == transaction_obj.value) {
                    ele_obj.item(0).value = "";
                    break;
                }
            }
            else
                break;
        }
    }
}

function cancel_sim_transaction() {
    document.the_form.reset();
    document.the_form.action = "/customer/products";
    document.the_form.submit();
}

function confirm_sim_transaction() {
    if (!confirm("Please check the SIM Mobile Number is correct.  ALL SIM Transactions are Final.  Are you sure you want proceed with the SIM Transaction?"))
        return;

    document.the_form.action = "/customer/sim/CompleteSimTransaction.jsp?";
    document.the_form.submit();
}