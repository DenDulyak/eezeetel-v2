<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    if (!request.isUserInRole("Employee_Master_Admin")) {
        response.getWriter().println("Permission Denied");
        return;
    }

    DecimalFormat ff = new DecimalFormat("0.00");
    Session theSession = null;

    try {
        String strStartMonth = request.getParameter("start_month_name");
        String strStartYear = request.getParameter("start_year_name");
        String strEndMonth = request.getParameter("end_month_name");
        String strEndYear = request.getParameter("end_year_name");
        String strAgent = request.getParameter("agent_id");

        int nStartYear = 0, nStartMonth = -1;
        int nEndYear = 0, nEndMonth = -1;

        if (strStartMonth != null && !strStartMonth.isEmpty())
            nStartMonth = Integer.parseInt(strStartMonth);
        if (strStartYear != null && !strStartYear.isEmpty())
            nStartYear = Integer.parseInt(strStartYear);

        if (strEndMonth != null && !strEndMonth.isEmpty())
            nEndMonth = Integer.parseInt(strEndMonth);
        if (strEndYear != null && !strEndYear.isEmpty())
            nEndYear = Integer.parseInt(strEndYear);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <link rel="stylesheet" href="/GenericApp/Scripts/Print.css" type="text/css" media="print"/>
    <title>Monthly Customer Sales Summary Report</title>
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">
        function show_summary() {
            if (document.the_form.start_year_name.value > document.the_form.end_year_name.value) {
                alert("Start Year is greater than End Year");
                return;
            }

            document.the_form.action = "/masteradmin/MonthlyReportCustomerSalesSummary.jsp";
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
        Start Month :
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
        Start Year :
        <select name="start_year_name">
            <option value="<%=nCurrentYear%>"><%=nCurrentYear%>
            </option>
            <option value="<%=nPreviousYear%>"><%=nPreviousYear%>
            </option>
        </select>

        End Month :
        <select name="end_month_name">
            <%
                String strCountryCode = application.getInitParameter("Country");
                for (int nMonth = 0; nMonth < 12; nMonth++) {
            %>
            <option value="<%=nMonth%>"><%=months[nMonth]%>
            </option>
            <%
                }
            %>
        </select>
        End Year :
        <select name="end_year_name">
            <option value="<%=nCurrentYear%>"><%=nCurrentYear%>
            </option>
            <option value="<%=nPreviousYear%>"><%=nPreviousYear%>
            </option>
        </select>

        Agent :
        <select name="agent_id">
            <option value="All" selected>All</option>
            <%
                theSession = HibernateUtil.openSession();

                String strAgentsQuery = "from User where User_Type_And_Privilege = 6 and User_Login_ID != 'Pending' and User_Active_Status = 1 order by User_First_Name";
                Query query = theSession.createQuery(strAgentsQuery);
                List agents = query.list();

                for (int nIndex = 0; nIndex < agents.size(); nIndex++) {
                    User oneUserInfo = (User) agents.get(nIndex);
            %>
            <option value="<%=oneUserInfo.getLogin()%>"><%=oneUserInfo.getUserFirstName()%>
            </option>
            <%
                }
            %>
        </select>

        <input type="button" name="generate_button" value="Generate" onClick="show_summary()">

        <a href="/masteradmin/MasterInformation.jsp">Go to Main</a>
        <hr>
    </div>
</form>
<%
    if (nStartYear > 0 && nStartMonth >= 0 && nEndYear > 0 && nEndMonth >= 0) {
        int nTheGrandTotalCards = 0;
        float fTheGrandTotal = 0.0f;
        float fTheGrandVAT = 0.0f;
        float fTheGrandNonVAT = 0.0f;
        float fTheGrandTotalCommission = 0.0f;
        float fTheGrandTotalAgentCommission = 0.0f;

        String strAgentClause = "";
        if (strAgent != null && !strAgent.isEmpty() && strAgent.compareToIgnoreCase("All") != 0) {
            strAgentClause = " where Customer_Introduced_By = '" + strAgent + "' ";
        }

        String strQuery = "from TMasterCustomerinfo " + strAgentClause + "order by Customer_Group_ID, Customer_Company_Name";
        query = theSession.createQuery(strQuery);
        List custList = query.list();

        GenerateInvoices invoiceGen = new GenerateInvoices();
        invoiceGen.setCountry(strCountryCode);
        invoiceGen.setDuration(nStartYear, nStartMonth, nEndYear, nEndMonth);
%>

<H3>
    <center><u>Sales Summary Report From <%=invoiceGen.m_strDisplayDurationBegin%>
        To <%=invoiceGen.m_strDisplayDurationEnd%>
        <div id="nav">for Agent(s) - <%=strAgent%>
        </div>
    </u></center>
</H3>
<table width="100%" border="1">
    <tr>
        <td align="left">Number</td>
        <td align="left">Customer</td>
        <td align="center">Total Cards</td>
        <td align="center">Total Amount</td>
        <td align="center">Total VAT</td>
        <td align="center">Total NON VAT</td>
        <td align="center">Total Commission</td>
        <td align="center">Total Agent Commission</td>
    </tr>

    <%

        int nSequence = 0;
        for (int nCustomer = 0; nCustomer < custList.size(); nCustomer++) {
            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) custList.get(nCustomer);
            if (custInfo.getId() == 28) continue;
            if (custInfo.getId() == 45) continue;
            invoiceGen.setCustomerID(custInfo.getId());
            invoiceGen.setGenerateGroupInvoices(true);
            invoiceGen.createInvoice();
            invoiceGen.setGenerateGroupInvoices(false);

            if (invoiceGen.m_nCustomerTotalCards <= 0 && invoiceGen.m_fCustomerTotal <= 0)
                continue;
            nSequence++;

            nTheGrandTotalCards += invoiceGen.m_nCustomerTotalCards;
            fTheGrandTotal += invoiceGen.m_fCustomerTotal;
            fTheGrandVAT += invoiceGen.m_fCustomerTotalVAT;
            fTheGrandNonVAT += invoiceGen.m_fCustomerTotalNonVAT;
            fTheGrandTotalCommission += invoiceGen.m_fCustomerTotalCommission;
            fTheGrandTotalAgentCommission += invoiceGen.m_fAgentTotalCommission;
    %>
    <tr>
        <td align="left"><%=nSequence%>
        </td>
        <td align="left"><%=custInfo.getCompanyName()%>
        </td>
        <td align="left"><%=invoiceGen.m_nCustomerTotalCards%>
        </td>
        <td align="left"><%=ff.format(invoiceGen.m_fCustomerTotal)%>
        </td>
        <td align="left"><%=ff.format(invoiceGen.m_fCustomerTotalVAT)%>
        </td>
        <td align="left"><%=ff.format(invoiceGen.m_fCustomerTotalNonVAT)%>
        </td>
        <td align="left"><%=ff.format(invoiceGen.m_fCustomerTotalCommission)%>
        </td>
        <td align="left"><%=ff.format(invoiceGen.m_fAgentTotalCommission)%>
        </td>
    </tr>
    <%
        }
    %>
    <tr>
        <td align="left"></td>
        <td align="left"><b>Total</b></td>
        <td align="left"><b><%=nTheGrandTotalCards%>
        </b></td>
        <td align="left"><b><%=ff.format(fTheGrandTotal)%>
        </b></td>
        <td align="left"><b><%=ff.format(fTheGrandVAT)%>
        </b></td>
        <td align="left"><b><%=ff.format(fTheGrandNonVAT)%>
        </b></td>
        <td align="left"><b><%=ff.format(fTheGrandTotalCommission)%>
        </b></td>
        <td align="left"><b><%=ff.format(fTheGrandTotalAgentCommission)%>
        </b></td>
    </tr>
    <%
        }
    %>
</table>
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }
    HibernateUtil.closeSession(theSession);
%>