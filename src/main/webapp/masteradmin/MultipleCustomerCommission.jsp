<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <script language="javascript" src="/GenericApp/Scripts/Validate.js"></script>
    <script language="javascript">

        var agent_list = {};
        var customer_list = {};
        var product_list = {};

        function changing_customer() {
            if (document.the_form.copy_to_customer.value == 0)
                document.the_form.customer_copy.disabled = true;
            else
                document.the_form.customer_copy.disabled = false;
        }

        function populateCopyLists(delete_all) {
            if (delete_all) {
                var element = document.getElementById('copy_to_customer_id');
                if (element != null) {
                    for (var i = 0; i < element.length; i++)
                        element.remove(i);
                    element.innerHTML = "";
                }

                return;
            }

            // setup customers

            var element = document.getElementById('copy_to_customer_id');
            for (var i = 0; i < element.length; i++)
                element.remove(i);
            element.innerHTML = "";
            element.disabled = true;

            if (customer_list != null) {
                var elOptionDefault = document.createElement('option');
                elOptionDefault.value = 0;
                elOptionDefault.innerHTML = "Select";
                element.appendChild(elOptionDefault);

                for (var key in customer_list) {
                    if (key != document.the_form.customer_id.value) {
                        var value = customer_list[key];
                        var elOption = document.createElement('option');
                        elOption.value = key;
                        elOption.innerHTML = value;
                        element.appendChild(elOption);
                    }
                }
                element.disabled = false;
            }
        }

        function statusCheck(do_real_check) {
            if (do_real_check == false || product_list == null) {
                document.the_form.save_button.disabled = true;
                document.the_form.customer_copy.disabled = true;
                document.the_form.copy_to_customer.disabled = true;

                populateCopyLists(true);

                return;
            }

            var changed = false;
            for (var key in product_list) {
                var theObj = product_list[key];
                if (Number(theObj.modified_eezeetel_commission) != Number(theObj.eezeetel_commission))
                    changed = true;
                else if (Number(theObj.modified_agent_commission) != Number(theObj.agent_commission))
                    changed = true;
                else if (theObj.modified_notes != theObj.notes)
                    changed = true;

                if (changed == true)
                    break;
            }

            if (changed == true) {
                populateCopyLists(true);
                document.the_form.save_button.disabled = false;
                document.the_form.customer_copy.disabled = true;
                document.the_form.copy_to_customer.disabled = true;
            }
            else {
                populateCopyLists(false);
                document.the_form.save_button.disabled = true;
                document.the_form.customer_copy.disabled = true;
            }
        }

        function commission_changed(type, element, id) {
            var theObj = product_list[id];

            if (type == 'ee') {
                if (isNaN(element.value)) {
                    alert("please enter a number");
                    element.focus();
                    return;
                }

                if (Number(theObj.modified_agent_commission) > Number(element.value)) {
                    if (!confirm("Agent Commission is more than EezeeTel Commission.  Is this Correct?")) {
                        element.value = theObj.modified_eezeetel_commission;
                        element.focus();
                        return;
                    }
                }

                theObj.modified_eezeetel_commission = element.value;
                if (Number(theObj.modified_eezeetel_commission) != Number(theObj.eezeetel_commission))
                    element.style.background = "#33CC00";
                else
                    element.style.background = "#FFFFFF";
            }
            else if (type == 'ag') {
                if (isNaN(element.value)) {
                    alert("please enter a number");
                    element.focus();
                    return;
                }

                if (Number(theObj.modified_eezeetel_commission) < Number(element.value)) {
                    if (!confirm("Agent Commission is more than EezeeTel Commission.  Is this Correct?")) {
                        element.value = theObj.modified_agent_commission;
                        element.focus();
                        return;
                    }
                }

                theObj.modified_agent_commission = element.value;
                if (Number(theObj.modified_agent_commission) != Number(theObj.agent_commission))
                    element.style.background = "#33CC00";
                else
                    element.style.background = "#FFFFFF";
            }
            else if (type == 'notes') {
                theObj.modified_notes = element.value;
                if (theObj.modified_notes != theObj.notes)
                    element.style.background = "#33CC00";
                else
                    element.style.background = "#FFFFFF";
            }

            var element_name = "pae_" + theObj.id;
            var the_element = document.getElementById(element_name);
            var the_value = eval(theObj.unit_price) + eval(theObj.modified_eezeetel_commission);
            the_element.value = the_value.toFixed(2);
            if (Number(the_element.value) >= Number(theObj.face_value))
                the_element.style.background = "#FF0000";
            else
                the_element.style.background = "#FFFFFF";

            element_name = "paa_" + theObj.id;
            the_element = document.getElementById(element_name);
            the_value = eval(theObj.unit_price) + eval(theObj.modified_eezeetel_commission) + eval(theObj.modified_agent_commission);
            the_element.value = the_value.toFixed(2);
            if (Number(the_element.value) >= Number(theObj.face_value))
                the_element.style.background = "#FF0000";
            else
                the_element.style.background = "#FFFFFF";

            product_list[id] = theObj;
            statusCheck(true);
        }

        function populateLists() {
            var the_agents = document.getElementById("the_agent_id");

            for (var i = 1; i < the_agents.options.length; i++) {
                agent_list[the_agents.options[i].value] = the_agents.options[i].text;
            }
        }

        function populateCustomers() {
            if (document.the_form.agent_id.value <= 0) {
                var element = document.getElementById('the_customer_id');
                for (var i = 0; i < element.length; i++)
                    element.remove(i);
                element.innerHTML = "";
                customer_list = null;
                product_list = null;
                statusCheck(false);

                return 0;
            }

            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Cannot get customers.");
                return;
            }

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    var element = document.getElementById('the_customer_id');
                    for (var i = 0; i < element.length; i++)
                        element.remove(i);
                    element.innerHTML = "";

                    var elOptionDefault = document.createElement('option');
                    elOptionDefault.value = 0;
                    elOptionDefault.innerHTML = "Select";
                    element.appendChild(elOptionDefault);

                    var nl = httpObj.responseXML.getElementsByTagName('customer');

                    for (var i = 0; i < nl.length; i++) {
                        var nli = nl.item(i);
                        var id = nli.getAttribute('id');
                        var name = nli.getAttribute('name');

                        customer_list[id] = name;

                        var elOption = document.createElement('option');
                        elOption.value = id;
                        elOption.innerHTML = name;
                        element.appendChild(elOption);
                    }
                    httpObj = null;
                }
            };

            var url = "AJAX_GetAgentCustomers.jsp?agent_id=" + document.the_form.agent_id.value;
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }

        function update_products() {
            if (document.the_form.supplier_id.value <= 0) return;
            if (document.the_form.agent_id.value <= 0) return;
            if (document.the_form.customer_id.value <= 0) return;
            product_list = null;

            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("can not get product and commission information");
                return;
            }

            var element = document.getElementById('product_detailed_info_id');
            element.innerHTML = "";

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    var element = document.getElementById('product_detailed_info_id');
                    element.innerHTML = "";

                    var theHtml = "";
                    if (document.the_form.supplier_id.value == <%=TransferToServiceMain.TransferTo_SupplierID%>)
                        theHtml += "<center><H1><font color=\"red\">Transfer To Profit Margins are on Percentage Basis</font></H1></center><BR><BR>";
                    theHtml += "<table border=1 width=100%>";
                    theHtml += ("<tr bgcolor=FFFF00><td align=center><b>Product Name</b></td><td align=center><b>EezeeTel Commission</b></td>");
                    theHtml += ("<td align=center><b>Agent Commission</b></td><td align=center><b>Notes</b></td><td align=center><b>Latest Batch Unit Purchase Price</b></td>");
                    theHtml += ("<td align=center><b>Price After EezeeTel Commission</b></td><td align=center><b>Price After Agent Commission</b></td></tr>");

                    var nl = httpObj.responseXML.getElementsByTagName('product');
                    product_list = new Array();

                    for (var i = 0; i < nl.length; i++) {
                        var nli = nl.item(i);

                        var id = nli.getAttribute('id');
                        var name = nli.getAttribute('name');
                        var face_value = nli.getAttribute('face_value');
                        var eezeetel_commission = nli.getAttribute('eezeetel_commission');
                        var agent_commission = nli.getAttribute('agent_commission');
                        var notes = nli.getAttribute('notes');
                        var active = nli.getAttribute('active');
                        var unit_price = nli.getAttribute('unit_price');
                        var price_after_eezeetel_commission = eval(unit_price) + eval(eezeetel_commission);
                        var price_after_agent_commission = eval(price_after_eezeetel_commission) + eval(agent_commission);

                        theHtml += ("<tr>");
                        theHtml += ("<td>" + name + " - " + face_value + "</td>");
                        theHtml += ("<td align=center><input type=text size=4 maxlength=4 name=ee_" + id + " value=\"" + eezeetel_commission + "\" onChange=\"commission_changed('ee', this, " + id + ")\"></td>");
                        theHtml += ("<td align=center><input type=text size=4 maxlength=4 name=ag_" + id + " value=\"" + agent_commission + "\" onChange=\"commission_changed('ag', this, " + id + ")\"></td>");
                        theHtml += ("<td align=center><input type=text name=notes_" + id + " value=\"" + notes + "\" onChange=\"commission_changed('notes', this, " + id + ")\"></td>");
                        theHtml += ("<td align=center><input type=text size=4 readonly id=up_" + id + " value=\"" + unit_price + "\"></td>");
                        theHtml += ("<td align=center><input type=text size=4 readonly id=pae_" + id + " value=\"" + price_after_eezeetel_commission.toFixed(2) + "\"></td>");
                        theHtml += ("<td align=center><input type=text size=4 readonly id=paa_" + id + " value=\"" + price_after_agent_commission.toFixed(2) + "\"></td>");
                        theHtml += ("</tr>");

                        var prodObj = new Object();
                        prodObj.id = id;
                        prodObj.name = name;
                        prodObj.face_value = face_value;
                        prodObj.eezeetel_commission = eezeetel_commission;
                        prodObj.agent_commission = agent_commission;
                        prodObj.notes = notes;
                        prodObj.active = active;
                        prodObj.unit_price = unit_price;
                        prodObj.modified_eezeetel_commission = eezeetel_commission;
                        prodObj.modified_agent_commission = agent_commission;
                        prodObj.modified_notes = notes;
                        prodObj.modified_active = active;

                        product_list[id] = prodObj;
                    }

                    theHtml += ("</table>");
                    element.innerHTML = theHtml;
                    theHtml = null;
                    httpObj = null;
                    statusCheck(true);
                }
            };

            var url = "AJAX_GetMultipleCommission.jsp?supplier_id=" + document.the_form.supplier_id.value +
                    "&customer_id=" + document.the_form.customer_id.value;
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }

        function makeUpChangedProductsList() {
            if (product_list == null)
                return "";

            var changed_objects = "<changed>";

            for (var key in product_list) {
                var theObj = product_list[key];
                if (Number(theObj.modified_eezeetel_commission) != Number(theObj.eezeetel_commission) ||
                        Number(theObj.modified_agent_commission) != Number(theObj.agent_commission) ||
                        theObj.modified_notes != theObj.notes) {
                    changed_objects += ("<product id=\"" + theObj.id) + "\"";
                    changed_objects += (" ee_comm=\"" + theObj.modified_eezeetel_commission) + "\"";
                    changed_objects += (" ag_comm=\"" + theObj.modified_agent_commission) + "\"";
                    changed_objects += (" notes=\"" + theObj.modified_notes) + "\"";
                    changed_objects += ("/>");
                }
            }

            changed_objects += "</changed>";
            return changed_objects;
        }

        function SaveInformation() {
            var modified_values = makeUpChangedProductsList();
            if (modified_values == "") {
                alert("No Modifications to Save.");
                return;
            }

            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("can not save.  can not initiate ajax request");
                return;
            }

            var from_cust_id = document.the_form.customer_id.value;
            var supplier_id = document.the_form.supplier_id.value;

            if (from_cust_id <= 0 || supplier_id <= 0) {
                alert("Please select a valid supplier, customer and modify commissions to save.");
                return;
            }

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    var nl = httpObj.responseXML.getElementsByTagName('the_result');
                    var nli = nl.item(0);
                    var code = nli.getAttribute('code');
                    if (code == 1) {
                        alert("Modifications have been saved.");
                        update_products();
                    }
                    else
                        alert("FAILED TO SAVE MODIFICATIONS.");
                }
            }

            var url = "AJAX_AddMultipleCustomerCommission.jsp?" +
                    "customer_id=" + from_cust_id + "&supplier_id=" + supplier_id;

            httpObj.open("POST", url, true);
            httpObj.setRequestHeader("Content-type", "text/xml");
            httpObj.send(modified_values);
        }

        function CopyToCustomer() {
            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("can not copy.  can not initiate ajax request");
                return;
            }

            var to_cust_id = document.the_form.copy_to_customer.value;
            var from_cust_id = document.the_form.customer_id.value;
            var supplier_id = document.the_form.supplier_id.value;
            if (!document.the_form.copy_agent_only.checked) {
                if (!confirm("Are you sure, you want to copy the eezeetel commission also to this customer."))
                    return;
            }

            if (to_cust_id <= 0 || from_cust_id <= 0 || supplier_id <= 0) {
                alert("Please select a valid supplier, customer and another customer to copy.");
                return;
            }

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    var nl = httpObj.responseXML.getElementsByTagName('the_result');
                    var nli = nl.item(0);
                    var code = nli.getAttribute('code');
                    if (code == 1)
                        alert("Copied successfully.");
                    else
                        alert("FAILED TO COPY.");
                }
            }

            var url = "AJAX_CopyCustomerCommission.jsp?to_customer_id=" + to_cust_id +
                    "&from_customer_id=" + from_cust_id + "&supplier_id=" + supplier_id +
                    "&agent_commission_only=" + document.the_form.copy_agent_only.checked;

            httpObj.open("POST", url, true);
            httpObj.send(null);
        }

    </script>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>List, Modify, Delete or Activate Commission Information</title>
</head>
<body>

<form name="the_form" method="post" action="">
    <input type="hidden" name="product_id_list"></input>
    <input type="hidden" name="total_products_list"></input>
    <table>
        <tr>
            <td align="left">
                Supplier :
            </td>
            <td align="left">
                <genericappdb:SupplierList name="supplier_id" active_records_only="1" secondary_also="0"
                                           initial_option="Select" onChange="update_products()" default_select="0"/>
            </td>
            <td align="left">
                Agent:
            </td>
            <td align="left">
                <select name="agent_id" id="the_agent_id" onchange="populateCustomers()">
                    <option value="0">Select</option>
                    <%
                        Session theSession = null;
                        try {
                            theSession = HibernateUtil.openSession();

                            String strQuery = "from User where User_Type_And_Privilege = 6 and User_Login_ID != 'Pending' and User_Active_Status = 1 order by User_First_Name";
                            Query query = theSession.createQuery(strQuery);
                            List agents = query.list();

                            for (int nIndex = 0; nIndex < agents.size(); nIndex++) {
                                User oneUserInfo = (User) agents.get(nIndex);
                    %>
                    <option value="<%=oneUserInfo.getLogin()%>"><%=oneUserInfo.getUserFirstName()%>
                    </option>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            HibernateUtil.closeSession(theSession);
                        }
                    %>
                </select>
            </td>
            <td align="left">
                Customer:
            </td>
            <td align="left">
                <select name="customer_id" id="the_customer_id" onChange="update_products()">
                </select>
            </td>
            <td>
                <a href="MasterInformation.jsp"> Go to Main </a>
            </td>
        </tr>
    </table>
    <br>

    <div id="product_detailed_info_id"></div>
    <table width="100%">
        <tr>


        </tr>
        <tr>
            <td align="left">
                <a href="MasterInformation.jsp"> Go to Main </a>
            </td>
            <td align="left">
                <input type="button" disabled name="save_button" value="Save" onClick="SaveInformation()">
            </td>
            <td align="right">
                Copy only Agent Commission
            </td>
            <td align="left">
                <input type="checkbox" name="copy_agent_only" checked>
            </td>
            <td align="left">
                <input type="button" disabled name="customer_copy" value="Copy To Customer" onClick="CopyToCustomer()">
                <select id="copy_to_customer_id" name="copy_to_customer" disabled onChange="changing_customer()">
                </select>
            </td>
        </tr>
    </table>
</form>
<script>
    window.onload = populateLists();
</script>
</body>
</html>