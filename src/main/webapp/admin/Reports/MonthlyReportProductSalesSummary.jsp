<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    if (!request.isUserInRole("Group_Admin")) {
        response.getWriter().println("Permission Denied");
        return;
    }

    DecimalFormat ff = new DecimalFormat("0.00");

    String strStartMonth = request.getParameter("start_month_name");
    String strStartYear = request.getParameter("start_year_name");

    int nStartYear = 0, nStartMonth = -1;
    int nEndYear = 0, nEndMonth = -1;

    if (strStartMonth != null && !strStartMonth.isEmpty())
        nStartMonth = Integer.parseInt(strStartMonth);
    if (strStartYear != null && !strStartYear.isEmpty())
        nStartYear = Integer.parseInt(strStartYear);

    nEndYear = nStartYear;
    nEndMonth = nStartMonth;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <link rel="stylesheet" href="/css/print.css" type="text/css" media="print"/>
    <title>Monthly Product Sales Summary Report</title>
    <STYLE TYPE='text/css'>
        P.pagebreakhere {
            page-break-before: always
        }
    </STYLE>
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">
        function show_summary() {
            document.the_form.action = "/admin/Reports/MonthlyReportProductSalesSummary.jsp";
            document.the_form.submit();
        }
    </script>
</head>
<body>

<%
    String[] months = {"January", "February",
            "March", "April", "May", "June", "July",
            "August", "September", "October", "November",
            "December"};

    Calendar calNew = Calendar.getInstance();
    int nCurrentYear = calNew.get(Calendar.YEAR);
    int nPreviousYear = nCurrentYear - 1;
%>

<form name="the_form" action="" method="post">
    <div id="nav">
        Month :
        <select name="start_month_name">
            <%
                for (int nMonth = 0; nMonth < 12; nMonth++) {
            %>
            <option value="<%=nMonth%>"><%=months[nMonth]%>
            </option>
            <%
                }
            %>
        </select>
        Year :
        <select name="start_year_name">
            <option value="<%=nCurrentYear%>"><%=nCurrentYear%>
            </option>
            <option value="<%=nPreviousYear%>"><%=nPreviousYear%>
            </option>
        </select>
        <input type="button" name="generate_button" value="Generate" onClick="show_summary()">

        <a href="/admin"> Admin Main </a>
        <hr>
    </div>
</form>
<%
    if (nStartYear > 0 && nStartMonth >= 0 && nEndYear > 0 && nEndMonth >= 0) {
        Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
        GenerateGroupInvoices invoiceGen = new GenerateGroupInvoices();
        invoiceGen.setDuration(nStartYear, nStartMonth, nEndYear, nEndMonth);
        invoiceGen.setGroupID(nCustomerGroupID);
        invoiceGen.createProductSalesInvoice();
%>

<H3>
    <center><u>Product Sales Summary Report From <%=invoiceGen.m_strDisplayDurationBegin%>
        To <%=invoiceGen.m_strDisplayDurationEnd%>
    </u></center>
</H3>
<table width="100%" border="1">
    <%=invoiceGen.m_strInvoiceReport%>
</table>
<br>
</body>
</html>
<%
    }
%>
