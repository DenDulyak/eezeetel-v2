<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%@ include file="AgentSessionCheck.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <script language="javascript" src="<%=ksContext%>/js/validate.js"></script>
    <script language="javascript">

        function show_margins() {
            var element = document.getElementById('commission_info_id');
            element.innerHTML = "";

            if (Number(document.the_form.supplier_id.value) == 0)
                return;

            if (Number(document.the_form.customer_id.value) == 0)
                return;

            if (Number(document.the_form.supplier_id.value) == 22)
                return;

            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Can not get commission information");
                return;
            }

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    var element = document.getElementById('commission_info_id');
                    element.innerHTML = httpObj.responseText;
                }
            }

            var url = "AJAX_GetProfitMargin.jsp?supplier_id=" + document.the_form.supplier_id.value +
                    "&customer_id=" + document.the_form.customer_id.value;
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }
    </script>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Profit Margin</title>
</head>
<body>
<form name="the_form" method="post" action="">
    <table>
        <tr>
            <td>
                Customer : <select name="customer_id" onChange="show_margins()">
                <option value="0" selected>Select</option>
                <%
                    String strQuery = "from TMasterCustomerinfo where Customer_Introduced_By = '" + request.getRemoteUser() + "' "
                            + " and Active_Status = 1 order by Customer_Company_Name";

                    Session theSession = null;
                    try {
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
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        HibernateUtil.closeSession(theSession);
                    }
                %>
            </select>
            </td>
            <td align="right">
                Supplier :
                <genericappdb:SupplierList name="supplier_id" active_records_only="1" secondary_also="0"
                                           initial_option="Select" onChange="show_margins()" default_select="0"/>
            </td>
            <td>
                <a href="<%=ksContext%>/AgentInformation/AgentInformation.jsp"> Go to Main </a>
            </td>
        </tr>
    </table>
    <br>
    <br>

    <div id="commission_info_id"></div>
</form>
</body>
</html>