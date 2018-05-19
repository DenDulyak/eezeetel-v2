<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Expires", "-1");

    Session theSession = null;
    int nForYear = 0;
    int nForMonth = 0;
    int nCustomerID = 0;
    try {
        String strHowManyMonthsBack = request.getParameter("previous_month");
        int nPrevMonth = 0;
        if (strHowManyMonthsBack != null && !strHowManyMonthsBack.isEmpty()) {
            try {
                nPrevMonth = Integer.parseInt(strHowManyMonthsBack);
            } catch (NumberFormatException nfe) {
                nPrevMonth = 0;
            }
        }

        if (nPrevMonth > 4 || nPrevMonth < 0) nPrevMonth = 0;

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

        // duration
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MONTH, -1 * nPrevMonth);

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
    <c:import url="../../common/libs.jsp"/>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/print.css" type="text/css" media="print"/>
    <style type="text/css">
        table {
            font-weight: bold
        }
    </style>
    <title>Commission Report</title>
</head>
<body>
<c:import url="../headerNavbar.jsp"/>
<%
    String[] months = {"January", "February",
            "March", "April", "May", "June", "July",
            "August", "September", "October", "November",
            "December"};

    Calendar calNew = Calendar.getInstance();
    String currentMonth = months[calNew.get(Calendar.MONTH)] + ", " + calNew.get(Calendar.YEAR);
    calNew.add(Calendar.MONTH, -1);
    String firstPreviousMonth = months[calNew.get(Calendar.MONTH)] + ", " + calNew.get(Calendar.YEAR);
    calNew.add(Calendar.MONTH, -1);
    String secondPreviousMonth = months[calNew.get(Calendar.MONTH)] + ", " + calNew.get(Calendar.YEAR);
    calNew.add(Calendar.MONTH, -1);
    String thirdPreviousMonth = months[calNew.get(Calendar.MONTH)] + ", " + calNew.get(Calendar.YEAR);
    calNew.add(Calendar.MONTH, -1);
    String fourthPreviousMonth = months[calNew.get(Calendar.MONTH)] + ", " + calNew.get(Calendar.YEAR);
%>

<div class="container">

    <div id="nav">
        <a href="/customer/sim-commision-report"><%=currentMonth%>
        </a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="/customer/sim-commision-report?previous_month=1"><%=firstPreviousMonth%>
        </a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="/customer/sim-commision-report?previous_month=2"><%=secondPreviousMonth%>
        </a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="/customer/sim-commision-report?previous_month=3"><%=thirdPreviousMonth%>
        </a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="/customer/sim-commision-report?previous_month=4"><%=fourthPreviousMonth%>
        </a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="/customer/products">Show Products</a>
        <hr>
    </div>

    <%
        GenerateOldInvoices invoices = new GenerateOldInvoices();
        invoices.setCountry("UK");
        invoices.setDuration(nForYear, nForMonth, nForYear, nForMonth);
        invoices.setCustomerID(nCustomerID);
        invoices.setGenerateHTMLOutput(true);
        invoices.createSIMInvoiceReport();
    %>

    <%=invoices.m_strInvoiceReport%>
</div>

</body>
</html>