<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    Session theSession = null;
    try {
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Assign SIMS to Customers</title>
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">

        function ValidateAndSubmit() {
            if (document.the_form.customer_id.value <= 0) {
                alert("Please select a customer.");
                return;
            }

            if (document.the_form.product_id.value <= 0) {
                alert("Please select a product.");
                return;
            }

            document.the_form.action = "/admin/Products/AllocateSIMs.jsp";
            document.the_form.submit();
        }

        function UnAssignSubmit() {
            if (document.the_form.customer_id.value <= 0) {
                alert("Please select a customer.");
                return;
            }

            if (document.the_form.product_id.value <= 0) {
                alert("Please select a product.");
                return;
            }

            document.the_form.action = "/admin/Products/UnAssignSIMs.jsp";
            document.the_form.submit();
        }

        function getAvailableQuantity() {
            if (document.the_form.product_id.value <= 0)
                document.the_form.available_quantity.value = "";

            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Cannot get available SIMs information");
                return;
            }

            httpObj.onreadystatechange = function () {
                document.the_form.available_quantity.value = "";

                if (httpObj.readyState == 4) {
                    document.the_form.available_quantity.value = httpObj.responseText;
                    httpObj = null;
                }
            };

            var url = "/admin/Products/AJAX_GetAvailableSIMQuantity.jsp?product_id=" + document.the_form.product_id.value;

            httpObj.open("POST", url, true);
            httpObj.send(null);
            getAvailableSims();
        }

        function getAvailableSims() {
            if (document.the_form.product_id.value <= 0)
                return;

            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Cannot get available SIMs information");
                return;
            }

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    var element = document.getElementById('availableSims');
                    element.innerHTML = httpObj.responseText;

                    httpObj = null;
                }
            };

            var url = "/admin/Products/AJAX_GetAvailableSIMs.jsp?product_id=" + document.the_form.product_id.value;

            httpObj.open("POST", url, true);
            httpObj.send(null);
        }

        function AssignSelectedSIMs() {
            document.the_form.assigned_sims.value = "";

            var contents = "";

            if (document.the_form.assigned_sims[0]) {
                for (var i = 0, j = 0; i < document.the_form.assigned_sims.length; i++)
                    if (document.the_form.assigned_sims[i].checked == true) {
                        if (j > 0) contents += (",");
                        contents += (document.the_form.assigned_sims[i].value);
                        j++;
                    }
            }
            else {
                contents = document.the_form.assigned_sims.value;
            }

            document.the_form.final_assign_list.value = contents;

            document.the_form.action = "/admin/Products/AllocateSIMs.jsp";
            document.the_form.submit();
        }

        function SelectAllSIMs() {
            for (var i = 0; i < document.the_form.assigned_sims.length; i++) {
                var checked = document.the_form.assigned_sims[i].checked;
                document.the_form.assigned_sims[i].checked = !checked;
            }
        }
    </script>
</head>
<body>
<a href="/admin"> Admin Main </a>

<form name="the_form" method="post" action="">
    <input type="hidden" name="final_assign_list" vale="">
    <table width="50%">
        <tr>
            <td align="right">
                Customer:
            </td>
            <td align="left">
                <select name="customer_id">
                    <option value="0">Select</option>
                    <%
                        Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
                        String strCustomerGroups = "" + nCustomerGroupID;
                        if (nCustomerGroupID == 5)
                            strCustomerGroups += ", 1";
                        String strQuery = "from TMasterCustomerinfo where Customer_Group_ID in (" + strCustomerGroups + ")" +
                                " and Active_Status = 1 and Customer_Feature_ID = 1 order by Customer_Company_Name";

                        theSession = HibernateUtil.openSession();

                        Query query = theSession.createQuery(strQuery);
                        List records = query.list();

                        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) records.get(nIndex);
                    %>
                    <option value="<%=custInfo.getId()%>"><%=custInfo.getCompanyName()%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td align="right">
                Product:
            </td>
            <td align="left">
                <select name="product_id">
                    <option value="0">Select</option>
                    <%
                        strQuery = "from TMasterProductinfo where Product_Type_ID = 17 and Product_Active_Status = 1 " +
                                " order by Product_Name";
                        query = theSession.createQuery(strQuery);
                        records = query.list();

                        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                            TMasterProductinfo prodInfo = (TMasterProductinfo) records.get(nIndex);


                    %>
                    <option value="<%=prodInfo.getId()%>"><%=prodInfo.getProductName()%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td>
                <input type="button" name="show_sims_button" value="Show Availability" onClick="getAvailableSims()">
            </td>
            <td>
                <input type="button" name="assign_button" value="Assign New SIMs" onClick="AssignSelectedSIMs()">
            </td>
            <td>
                <input type="button" name="un_assign_button" value="Un Assign SIMs" onClick="UnAssignSubmit()">
            </td>
        </tr>
    </table>

    <div id="availableSims"></div>

</form>
<a href="/admin">Admin Main</a>
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>