<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
    DatabaseHelper dbHelper = new DatabaseHelper();
    String strCustomerGroupName = dbHelper.GetCustomerGroupName(nCustomerGroupID);

    boolean bShowMissingOnes = false;
    String strShowMissingMargins = request.getParameter("show_missing_margins");
    if (strShowMissingMargins != null && !strShowMissingMargins.isEmpty())
        bShowMissingOnes = true;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Copy Profit Margins</title>
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">

        var agent_list = {};
        var customer_list = {};
        var product_list = {};
        var transferToSupplier_ID = <%=TransferToServiceMain.TransferTo_SupplierID%>

                function populateCopyLists(delete_all) {
                    if (delete_all) {
                        var element = document.getElementById('copy_to_customer_id');
                        if (element != null) {
                            for (var i = 0; i < element.length; i++)
                                element.remove(i);
                            element.innerHTML = "";
                        }
                        return;
                    };

                    // setup customers

                    var element = document.getElementById('copy_to_customer_id');
                    for (var i = 0; i < element.length; i++)
                        element.remove(i);
                    element.innerHTML = "";
                    element.disabled = true;

                    if (customer_list != null) {
                        var elOptionDefault = document.createElement('option');
                        elOptionDefault.value = 0;
                        elOptionDefault.innerHTML = "All Remaining Customers";
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

        function populateLists() {
            var the_agents = document.getElementById("the_agent_id");

            for (var i = 1; i < the_agents.options.length; i++) {
                agent_list[the_agents.options[i].value] = the_agents.options[i].text;
            }
        }

        function populateCustomers() {
            populateCopyLists(true);

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

            var url = "/admin/Accounts/AJAX_GetAgentCustomers.jsp?agent_id=" + document.the_form.agent_id.value;
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
                    for (var i = 0; i < element.length; i++)
                        element.remove(i);
                    element.innerHTML = "";

                    var elOptionDefault = document.createElement('option');
                    elOptionDefault.value = 0;
                    elOptionDefault.innerHTML = "All";
                    element.appendChild(elOptionDefault);

                    var nl = httpObj.responseXML.getElementsByTagName('product');
                    product_list = new Array();
                    for (var i = 0; i < nl.length; i++) {
                        var nli = nl.item(i);
                        var id = nli.getAttribute('id');
                        var name = nli.getAttribute('name');
                        var face_value = nli.getAttribute('face_value');

                        product_list[id] = name + "-" + face_value;

                        var elOption = document.createElement('option');
                        elOption.value = id;
                        elOption.innerHTML = name + "-" + face_value;
                        element.appendChild(elOption);
                    }
                    httpObj = null;
                }
            };

            var url = "/admin/Accounts/AJAX_GetMultipleCommission.jsp?supplier_id=" + document.the_form.supplier_id.value +
                    "&customer_id=" + document.the_form.customer_id.value;
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }

        function CopyCustomerPercentages(copy_type) {
            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("can not copy.  can not initiate ajax request");
                return;
            }

            var agent_id = document.the_form.agent_id.value;
            var from_cust_id = document.the_form.customer_id.value;
            var to_cust_id = document.the_form.copy_to_customer.value;
            var supplier_id = document.the_form.supplier_id.value;
            var product_id = document.the_form.product_info.value;

            if (agent_id <= 0 || from_cust_id <= 0) {
                alert("Please select an Agent and From Customer.");
                return;
            }

            if (to_cust_id <= 0) {
                if (!confirm("WARNING :: Are you sure you want to copy the percentages to ALL Customers?  PLEASE CHECK IT OUT."))
                    return;
            }

            if (supplier_id <= 0) {
                if (!confirm("WARNING :: Are you sure you want to copy the percentages of ALL Products FROM ALL Suppliers?  PLEASE CHECK IT OUT."))
                    return;
            }

            if (product_id <= 0) {
                if (!confirm("WARNING :: Are you sure you want to copy the percentages of ALL Products?  PLEASE CHECK IT OUT."))
                    return;
            }

            if (copy_type == 1)
                if (!confirm("WARNING : You want to copy both Agent and Customer Percentages?"))
                    return;

            if (!confirm("LAST WARNING : ARE YOU SURE THE INFORMATION YOU ENTERED IS CORRECT?"))
                return;

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

            var url = "/admin/Accounts/AJAX_CopyProfitMargins.jsp?agent_id=" + agent_id +
                    "&from_customer_id=" + from_cust_id + "&to_customer_id=" + to_cust_id +
                    "&supplier_id=" + supplier_id + "&product_id=" + product_id + "&copy_type=" + copy_type;

            httpObj.open("POST", url, true);
            httpObj.send(null);
        }

        function CopyProductPercentages(only_agent_commission) {
            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("can not copy.  can not initiate ajax request");
                return;
            }

            alert(document.the_form.product_info.value);

            var supplier_id = document.the_form.supplier_id.value;
            var product_id = document.the_form.product_info.value;
            var from_cust_id = document.the_form.customer_id.value;
            var agent_id = document.the_form.agent_id.value;

            if (from_cust_id <= 0 || supplier_id <= 0 || agent_id <= 0) {
                alert("Please select a supplier, from customer to copy");
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

            var url = "/admin/Accounts/AJAX_CopyProductCommissionAllCustomers.jsp?product_id=" + product_id +
                    "&from_customer_id=" + from_cust_id + "&agent_commission_only=" + only_agent_commission +
                    "&supplier_id=" + supplier_id;

            httpObj.open("POST", url, true);
            httpObj.send(null);
        }

        function showmissingmargins() {
            var url = "/admin/Accounts/CopyProfitMargins.jsp?show_missing_margins=1";
            document.the_form.action = url;
            document.the_form.submit();
        }

    </script>
</head>
<body>
<form name="the_form" method="post" action="">
    <a href="/admin"> Admin Main </a>
    <table>
        <tr>
            <td align="right">
                Agent:
            </td>
            <td align="left">
                <select name="agent_id" id="the_agent_id" onchange="populateCustomers()">
                    <option value="0">Select</option>
                    <%
                        Session theSession = null;
                        try {
                            theSession = HibernateUtil.openSession();

                            String strQuery = "from User where User_Login_ID = '" + request.getRemoteUser() + "'" +
                                    " OR (User_Type_And_Privilege = 6 and User_Login_ID != 'Pending' and User_Active_Status = 1" +
                                    " and Customer_Group_ID = " + nCustomerGroupID + ") order by User_First_Name";

                            Query query = theSession.createQuery(strQuery);
                            List agents = query.list();

                            for (int nIndex = 0; nIndex < agents.size(); nIndex++) {
                                User oneUserInfo = (User) agents.get(nIndex);
                                String isAgent = "";
                                if (oneUserInfo.getUserType().getId() == 6)
                                    isAgent = " - AGENT";
                    %>
                    <option value="<%=oneUserInfo.getLogin()%>"><%=oneUserInfo.getUserFirstName()%><%=isAgent%>
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
        </tr>
        <tr>
            <td align="right">
                From Customer:
            </td>
            <td align="left">
                <select name="customer_id" id="the_customer_id" onchange="populateCopyLists(false)">
                </select>
            </td>
        </tr>
        <tr>
            <td align="right">
                To Customer:
            </td>
            <td align="left">
                <select name="copy_to_customer" id="copy_to_customer_id">
                </select>
            </td>
        <tr>
        <tr>
            <td align="right">
                Supplier :
            </td>
            <td align="left">
                <genericappdb:SupplierList name="supplier_id" active_records_only="1" secondary_also="0"
                                           initial_option="All" onChange="update_products()" default_select="0"/>
            </td>
        </tr>
        <tr>
            <td align="right">
                Product :
            </td>
            <td align="left">
                <select name="product_info" id="product_detailed_info_id"></select>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <input type="button" name="copy_all" value="Copy All Percentages" onClick="CopyCustomerPercentages(1)">
            </td>
            <td>
                <input type="button" name="copy_customer_percentages" value="Copy Customer Percentages Only"
                       onClick="CopyCustomerPercentages(2)">
            </td>
            <td>
                <input type="button" name="copy_agent_percengaes" value="Copy Agent Percentages Only"
                       onClick="CopyCustomerPercentages(3)">
            </td>
            <td>

            </td>
        </tr>
    </table>
</form>

<br><br><br><br>

<%
    if (bShowMissingOnes) {
        try {
            theSession = HibernateUtil.openSession();

            boolean bFirstOne = true;
            String strQuery = "from TMasterProductinfo where Product_Active_Status = 1";
            Query query = theSession.createQuery(strQuery);
            List theProducts = query.list();
            for (int nProduct = 0; nProduct < theProducts.size(); nProduct++) {
                TMasterProductinfo prodInfo = (TMasterProductinfo) theProducts.get(nProduct);

                strQuery = " from TMasterCustomerinfo where Customer_Group_ID = " + nCustomerGroupID;

                query = theSession.createQuery(strQuery);
                List custList = query.list();

                for (int nCustomer = 0; nCustomer < custList.size(); nCustomer++) {
                    TMasterCustomerinfo custInfo = (TMasterCustomerinfo) custList.get(nCustomer);
                    User agentInfo = custInfo.getIntroducedBy();

                    strQuery = " from TCustomerCommission where Product_ID = " + prodInfo.getId() +
                            " and Customer_ID = " + custInfo.getId();

                    boolean bBothMissing = false;
                    boolean bCustomerMissing = false;
                    boolean bAgentMissing = false;

                    query = theSession.createQuery(strQuery);
                    List theRecord = query.list();
                    if (theRecord.size() <= 0)
                        bBothMissing = true;
                    else {
                        TCustomerCommission custTocomm = (TCustomerCommission) theRecord.get(0);

                        if (custTocomm.getCommission() <= 0.00)
                            bCustomerMissing = true;

                        if (custTocomm.getAgentCommission() <= 0.00 && agentInfo.getUserType().getId() == 6 &&
                                agentInfo.getLogin().compareToIgnoreCase("First") != 0) {
                            bAgentMissing = true;
                        }
                    }

                    String strMissingCommissions = "";
                    if (bBothMissing || bCustomerMissing || bAgentMissing) {
                        if (bFirstOne) {
                            bFirstOne = false;
                            strMissingCommissions = "<table>";
                            strMissingCommissions += "<tr><td>Product Name</td><td>Customer Name</td><td>Agent Name</td><td>Missing Profit Margin</td></tr>";
                        }

                        strMissingCommissions += "<tr><td>" + prodInfo.getProductName() + "-" + prodInfo.getProductFaceValue() + "</td>";
                        strMissingCommissions += "<td>" + custInfo.getCompanyName() + "</td>";
                        strMissingCommissions += "<td>" + custInfo.getIntroducedBy().getLogin() + "</td>";

                        if (bBothMissing || (bAgentMissing && bCustomerMissing))
                            strMissingCommissions += "<td>BOTH</td>";
                        else {
                            if (bCustomerMissing)
                                strMissingCommissions += "<td>CUSTOMER</td>";
                            else if (bAgentMissing)
                                strMissingCommissions += "<td>AGENT</td>";
                        }
%>
<%=strMissingCommissions%>
<%
            }
        }
    }
    if (!bFirstOne) {
%>
</table>
<%
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
    }
%>

</body>
</html>