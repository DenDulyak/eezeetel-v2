<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Expires", "-1");

    Session theSession = null;
    int nForYear = 0;
    int nForMonth = 0;
    int nCustomerID = 0;
    Date dateFrom = new Date();
    String date = "";
    try {
        Calendar cal = Calendar.getInstance();
        date = request.getParameter("date");
        SimpleDateFormat df = new SimpleDateFormat("MM-yyyy");
        if (!StringUtils.isEmpty(date)) {
            dateFrom = df.parse(date);
            date = df.format(dateFrom);
        } else {
            date = df.format(cal.getTime());
        }

        theSession = HibernateUtil.openSession();
        String strUserId = request.getRemoteUser();

        if (!strUserId.isEmpty()) {
            String strQuery = "from TCustomerUsers where User_Login_ID = '" + request.getRemoteUser() + "'";
            Query query = theSession.createQuery(strQuery);
            List customer = query.list();
            if (customer.size() > 0) {
                TCustomerUsers custUsers = (TCustomerUsers) customer.get(0);
                TMasterCustomerinfo custInfo = custUsers.getCustomer();
                User theUser = custUsers.getUser();
                if (custInfo.getActive() && theUser.getUserActiveStatus())
                    nCustomerID = custInfo.getId();
                else
                    custInfo = null;
            }
        }

        if (nCustomerID <= 0) {
            response.sendRedirect("/customer/products");
            return;
        }

        cal.setTime(dateFrom);
        nForYear = cal.get(Calendar.YEAR);
        nForMonth = cal.get(Calendar.MONTH);
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer.css"/>
    <c:import url="../common/libs.jsp"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/print.css" type="text/css" media="print"/>
    <style type="text/css">
        table {
            font-weight: bold
        }
    </style>

    <script>
        $(function () {
            $('#month').datepicker({
                format: "mm-yyyy",
                viewMode: "months",
                minViewMode: "months",
                startDate: new Date(2012, 1, 1)
            });

            $("#showTheReport").click(function (e) {
                e.preventDefault();
                var href = $(this).attr('href');
                var date = $('#month').val();
                window.location = href + '?date=' + date;
            });
        });
    </script>
    <title>Commission Report</title>
</head>
<body>
<c:import url="headerNavbar.jsp"/>

<%
    GenerateOldInvoices invoices = new GenerateOldInvoices();
    invoices.setCountry("UK");
    invoices.setDuration(nForYear, nForMonth, nForYear, nForMonth);
    invoices.setCustomerID(nCustomerID);
    invoices.setGenerateHTMLOutput(true);
    invoices.createInvoice();
%>

<div class="container">
    <div class="row">
        <div class="form-inline col-sm-12">
            <div class="form-group">
                <label for="month" class="control-label">Select the month: </label>
                <input id="month" type="text" class="form-control" value="<%=date%>"/>
                <a id="showTheReport" href="${pageContext.request.contextPath}/customer/monthly-invoice">Show the report for selected month</a>
            </div>
        </div>
    </div>

    <%=invoices.m_strInvoiceReport%>
</div>

</body>
</html>