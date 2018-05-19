<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%@ include file="AgentSessionCheck.jsp" %>

<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Expires", "-1");

    Session theSession = null;
    int nForYear = 0;
    int nForMonth = 0;

    try {
        // Define duration

        String strHowManyMonthsBack = request.getParameter("previous_month");
        int nPrevMonth = 0;
        if (strHowManyMonthsBack != null && !strHowManyMonthsBack.isEmpty()) {
            try {
                nPrevMonth = Integer.parseInt(strHowManyMonthsBack);
            } catch (NumberFormatException nfe) {
                nPrevMonth = 0;
            }
        }

        if (nPrevMonth > 3 || nPrevMonth < 0) nPrevMonth = 0;

        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MONTH, -1 * nPrevMonth);

        nForYear = cal.get(Calendar.YEAR);
        nForMonth = cal.get(Calendar.MONTH);

        // Get Agent customers

        theSession = HibernateUtil.openSession();

        String strQuery = "from User where User_Login_ID = '" + request.getRemoteUser() + "' ";

        Query query = theSession.createQuery(strQuery);
        List userList = query.list();

        int nCustomerGroupID = 0;
        if (userList.size() > 0) {
            User theUser = (User) userList.get(0);
            nCustomerGroupID = theUser.getGroup().getId();
        }

        GenerateAgentInvoices invoiceGen = new GenerateAgentInvoices();
        invoiceGen.setDuration(nForYear, nForMonth, nForYear, nForMonth);
        invoiceGen.setGroupAndAgentID(nCustomerGroupID, request.getRemoteUser());
        invoiceGen.createInvoice();

        // Setup Links to previous months

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
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <link rel="stylesheet" href="<%=ksContext%>/css/print.css" type="text/css" media="print"/>
    <STYLE TYPE='text/css'>
        P.pagebreakhere {
            page-break-before: always
        }
    </STYLE>
    <title>Customer Business Report</title>
</head>
<body>
<div id="nav">
    <a href="<%=ksContext%>/AgentInformation/CustomerBusiness.jsp?previous_month=0"><%=currentMonth%>
    </a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="<%=ksContext%>/AgentInformation/CustomerBusiness.jsp?previous_month=1"><%=firstPreviousMonth%>
    </a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="<%=ksContext%>/AgentInformation/CustomerBusiness.jsp?previous_month=2"><%=secondPreviousMonth%>
    </a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="<%=ksContext%>/AgentInformation/CustomerBusiness.jsp?previous_month=3"><%=thirdPreviousMonth%>
    </a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="<%=ksContext%>/AgentInformation/AgentInformation.jsp"> Go to Main </a>
    <hr>
</div>

<H3>
    <center>
        <u>Customer Business Summary Report From <%=invoiceGen.m_strDisplayDurationBegin%>
            To <%=invoiceGen.m_strDisplayDurationEnd%>
        </u>
    </center>
</H3>
<br>
<br>
<table border=1 width="100%">
    <%=invoiceGen.m_strInvoiceReport%>
</table>
<br>

<P CLASS="pagebreakhere"></P>
<br><br>
<table border=1 width="100%">
    <%=invoiceGen.m_strInActiveCustomersReport%>
</table>
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>