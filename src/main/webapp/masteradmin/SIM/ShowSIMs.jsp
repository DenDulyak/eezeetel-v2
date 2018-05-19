<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <link rel="stylesheet" href="/css/print.css" type="text/css" media="print"/>
    <script language="javascript" src="/js/validate.js"></script>
    <title>Show SIMS</title>
    <script language="javascript">
        function validate_and_show() {
            if (document.the_form.customer_group.value <= 0) {
                alert("Please select a customer group.");
                return;
            }

            var element = document.getElementById('assigned_sim_products');
            element.innerHTML = "";

            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Cannot get assigned sim products information.");
                return;
            }
            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    var element = document.getElementById('assigned_sim_products');
                    element.innerHTML = httpObj.responseText;
                    httpObj = null;
                }
            };

            var url = "AJAX_GetAssignedSIMs.jsp?group_id=" + document.the_form.customer_group.value +
                    "&product_id=" + document.the_form.product_id.value + "&sold_or_unsold=" +
                    document.the_form.sold_or_unsold.value;

            httpObj.open("POST", url, true);
            httpObj.send(null);
        }
    </script>
</head>
<body>
<form name="the_form" method="post">
    <div id="nav">
        <table>
            <tr>
                <td>
                    Customer Group :
                    <select name="customer_group">
                        <option value="0">Select</option>
                        <%
                            String strQuery = "from TMasterCustomerGroups where IsActive = 1";
                            Session theSession = null;
                            try {
                                theSession = HibernateUtil.openSession();

                                Query query = theSession.createQuery(strQuery);
                                List records = query.list();
                                for (int i = 0; i < records.size(); i++) {
                                    TMasterCustomerGroups custGroup = (TMasterCustomerGroups) records.get(i);
                        %>
                        <option value="<%=custGroup.getId()%>"><%=custGroup.getName()%>
                        </option>
                        <%
                            }
                        %>
                    </select>
                </td>
                <td>
                    Product :
                    <select name="product_id">
                        <option value="0">All</option>
                        <%
                            strQuery = "from TMasterProductinfo where Product_Type_ID in (17) and Product_Active_Status = 1";
                            query = theSession.createQuery(strQuery);
                            records = query.list();
                            for (int i = 0; i < records.size(); i++) {
                                TMasterProductinfo prodInfo = (TMasterProductinfo) records.get(i);
                        %>
                        <option value="<%=prodInfo.getId()%>"><%=prodInfo.getProductName()%>
                        </option>
                        <%
                            }
                        %>
                    </select>
                </td>
                <td>
                    Sold / Un-sold :
                    <select name="sold_or_unsold">
                        <option value="0">Un-Sold</option>
                        <option value="1">Sold</option>
                        <option value="2">All</option>
                    </select>
                </td>
                <td>
                    <input type="button" name="show_button" value="Show" onClick="validate_and_show()"/>
                </td>
                <td>
                    <a href="/masteradmin/MasterInformation.jsp"> Go to Main </a>
                </td>
            </tr>
        </table>
    </div>
    <div id="assigned_sim_products"></div>
    <div id="nav">
        <br>
        <a href="/masteradmin/MasterInformation.jsp"> Go to Main </a>
    </div>
    <%
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
    %>
</form>
</body>
</html>