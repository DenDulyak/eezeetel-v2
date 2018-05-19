<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>SimCards Sales Report</title>
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript" src="/js/calendarDateInput.js"></script>
    <script language="javascript">

        function generateReport() {
            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Can not get Address Details");
                return;
            }
            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    var element = document.getElementById("sim_sales_summary_report");
                    element.innerHTML = httpObj.responseText;
                }
            }
            var url = "/admin/Reports/AJAX_simReports.jsp?customer_id=" + document.the_form.customer_id.value
                    + "&product_id=" + document.the_form.product_id.value
                    + "&report_date=" + document.the_form.reportdate.value
                    + "&reportSelector=" + document.the_form.reportSelector.checked;

            httpObj.open("POST", url, true);
            httpObj.send(null);
        }
    </script>
</head>
<%
    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
%>
<body onLoad="update_customer_daily_transaction(true)">
<form name="the_form" method="post" action="">
    <table>
        <tr>
            <td align="left">
                Customer:
            </td>
            <td align="left">
                <select name="customer_id">
                    <option value="0">All</option>
                    <%
                        String strQuery = "from TMasterCustomerinfo where Customer_Group_ID = " + nCustomerGroupID + " order by Customer_Company_Name";
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
            <td align="left">
                SIM Product :
            </td>
            <td align="left">
                <select name="product_id">
                    <option value="0">All</option>
                    <%
                        strQuery = "from TMasterProductinfo where Product_Active_Status = 1 and Product_Type_ID = 17 order by Product_Name";
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
            <td>
                <script>
                    DateInput('reportdate', true, 'YYYY-mm-DD')
                    var elOptionDefault = document.createElement('option');
                    elOptionDefault.value = 0;
                    elOptionDefault.innerHTML = "All";

                    var element = document.getElementById("reportdate_Day_ID");
                </script>
            </td>
            <td>
                <input type="checkbox" name="reportSelector">Monthly Report
            </td>

            <td>
                <input type="button" name="generate_button" value="Generate" onClick="generateReport()">
            </td>
            <td><a href="/admin"> Admin Main </a></td>

        </tr>
    </table>

    <br>
    <br>

    <div id="sim_sales_summary_report"></div>
</form>
</body>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
</html>