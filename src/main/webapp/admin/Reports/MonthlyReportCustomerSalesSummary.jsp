<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<%
    if (!request.isUserInRole("Group_Admin")) {
        response.getWriter().println("Permission Denied");
        return;
    }

    DecimalFormat ff = new DecimalFormat("0.00");
    Session theSession = null;

    try {
        Integer custGroupID = (Integer) session.getAttribute("GROUP_ID");
        String theMonth = request.getParameter("the_month");
        String theYear = request.getParameter("the_year");

        int nYear = 0, nMonth = -1;

        if (theMonth != null && !theMonth.isEmpty())
            nMonth = Integer.parseInt(theMonth);
        if (theYear != null && !theYear.isEmpty())
            nYear = Integer.parseInt(theYear);
%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/print.css" type="text/css" media="print"/>
    <title>VAT Report</title>
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>
        function show_summary() {
            document.the_form.action = "/admin/Reports/MonthlyReportCustomerSalesSummary.jsp";
            document.the_form.submit();
        }
    </script>
</head>
<body>

<%
    theSession = HibernateUtil.openSession();

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
        <select name="the_month">
            <%
                for (int i = 0; i < 12; i++) {
            %>
            <option value="<%=i%>"><%=months[i]%>
            </option>
            <%
                }
            %>
        </select>
        Year :
        <select name="the_year">
            <option value="<%=nCurrentYear%>" selected><%=nCurrentYear%>
            </option>
            <
            <option value="<%=nPreviousYear%>"><%=nPreviousYear%>
            </option>
        </select>

        <input type="button" name="generate_button" value="Generate" onClick="show_summary()">

        <a href="/admin"> Admin Main </a>
        <hr>
    </div>
</form>
<%
    if (nYear > 0 && nMonth != -1) {
        String strMonthAndYear = months[nMonth] + ", " + nYear;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        cal.set(nYear, nMonth, 01);
        String beginDate = sdf.format(cal.getTime());
        cal.set(nYear, nMonth + 1, 01);
        String endDate = sdf.format(cal.getTime());

        String strQuery = "call SP_VAT_Report_New('" + beginDate + "'," + custGroupID + ")";
        SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
        sqlQuery.addScalar("Sale Type", new StringType());
        sqlQuery.addScalar("Group", new StringType());
        sqlQuery.addScalar("Customer", new StringType());
        sqlQuery.addScalar("Net Sales", new FloatType());
        sqlQuery.addScalar("VAT", new FloatType());
        sqlQuery.addScalar("Total Sales", new FloatType());
        sqlQuery.addScalar("Profit", new FloatType());
        sqlQuery.addScalar("VAT On Profit", new FloatType());
        List vatReport = sqlQuery.list();
%>
<div style="text-align: center;">
    <h3>VAT Report for the month of <%=strMonthAndYear%></h3>
</div>
<table border="1" width="100%">
    <tr>
        <td><b>Sale Type</b></td>
        <td><b>Customer</b></td>
        <td><b>Net Sales</b></td>
        <td><b>VAT</b></td>
        <td><b>Total Sales</b></td>
        <td><b>Profit</b></td>
        <td><b>VAT on Profit</b></td>
    </tr>
    <%
        DecimalFormat df = new DecimalFormat("0.00");

        float fNetSalesSum = 0.0f;
        float fVATSum = 0.0f;
        float fTotalSalesSum = 0.0f;
        float fProfitSum = 0.0f;
        float fVATOnProfitSum = 0.0f;

        float fSaleTypeNetSalesSum = 0.0f;
        float fSaleTypeVATSum = 0.0f;
        float fSaleTypeTotalSalesSum = 0.0f;
        float fSaleTypeProfitSum = 0.0f;
        float fSaleTypeVATOnProfitSum = 0.0f;

        String prevSaleType = "0";
        String bgColor = "";

        for (int i = 0; i < vatReport.size(); i++) {
            Object[] oneRecord = (Object[]) vatReport.get(i);
            String strSaleType = oneRecord[0].toString();
            String strCustomerGroup = oneRecord[1].toString();
            String strCustomer = oneRecord[2].toString();
            float fNetSales = (Float) oneRecord[3];
            float fVAT = (Float) oneRecord[4];
            float fTotalSales = (Float) oneRecord[5];
            float fProfit = (Float) oneRecord[6];
            float fVATOnProfit = (Float) oneRecord[7];

            if (prevSaleType.compareToIgnoreCase(strSaleType) != 0) {
                // sale type changed

    %>
    <tr bgcolor="<%=bgColor%>">
        <td></td>
        <td><b><font color="blue">Sub Total</font></b></td>
        <td><b><font color="blue"><%=df.format(fSaleTypeNetSalesSum)%>
        </font></b></td>
        <td><b><font color="blue"><%=df.format(fSaleTypeVATSum)%>
        </font></b></td>
        <td><b><font color="blue"><%=df.format(fSaleTypeTotalSalesSum)%>
        </font></b></td>
        <td><b><font color="blue"><%=df.format(fSaleTypeProfitSum)%>
        </font></b></td>
        <td><b><font color="blue"><%=df.format(fSaleTypeVATOnProfitSum)%>
        </font></b></td>
    </tr>
    <%

            fSaleTypeNetSalesSum = 0.0f;
            fSaleTypeVATSum = 0.0f;
            fSaleTypeTotalSalesSum = 0.0f;
            fSaleTypeProfitSum = 0.0f;
            fSaleTypeVATOnProfitSum = 0.0f;
        }

        fSaleTypeNetSalesSum += fNetSales;
        fSaleTypeVATSum += fVAT;
        fSaleTypeTotalSalesSum += fTotalSales;
        fSaleTypeProfitSum += fProfit;
        fSaleTypeVATOnProfitSum += fVATOnProfit;

        fNetSalesSum += fNetSales;
        fVATSum += fVAT;
        fTotalSalesSum += fTotalSales;
        fProfitSum += fProfit;
        fVATOnProfitSum += fVATOnProfit;

        String strSaleTypeDisplay = "";
        String strVATDisplay = "";
        String strVATOnProfitDisplay = "";

        if (strSaleType.compareToIgnoreCase("0") == 0) {
            prevSaleType = strSaleType;
            bgColor = "#D8F781";
            strSaleTypeDisplay = "VAT Product";
            strVATDisplay = df.format(fVAT);
            strVATOnProfitDisplay = df.format(fVATOnProfit);
        } else if (strSaleType.compareToIgnoreCase("1") == 0) {
            prevSaleType = strSaleType;
            bgColor = "#58FAAC";
            strSaleTypeDisplay = "Non VAT Product";
            strVATDisplay = "NIL";
            strVATOnProfitDisplay = "NIL";

        } else if (strSaleType.compareToIgnoreCase("2") == 0) {
            prevSaleType = strSaleType;
            bgColor = "#00BFFF";
            strSaleTypeDisplay = "3R Product";
            strVATDisplay = "NIL";
            strVATOnProfitDisplay = "NIL";
        }

    %>
    <tr bgcolor="<%=bgColor%>">
        <td><%=strSaleTypeDisplay%>
        </td>
        <td><%=strCustomer%>
        </td>
        <td><%=df.format(fNetSales)%>
        </td>
        <td><%=strVATDisplay%>
        </td>
        <td><%=df.format(fTotalSales)%>
        </td>
        <td><%=df.format(fProfit)%>
        </td>
        <td><%=strVATOnProfitDisplay%>
        </td>
    </tr>
    <%
        }
    %>
    <tr bgcolor="<%=bgColor%>">
        <td></td>
        <td><b><font color="blue">Sub Total</font></b></td>
        <td><b><font color="blue"><%=df.format(fSaleTypeNetSalesSum)%>
        </font></b></td>
        <td><b><font color="blue"><%=df.format(fSaleTypeVATSum)%>
        </font></b></td>
        <td><b><font color="blue"><%=df.format(fSaleTypeTotalSalesSum)%>
        </font></b></td>
        <td><b><font color="blue"><%=df.format(fSaleTypeProfitSum)%>
        </font></b></td>
        <td><b><font color="blue"><%=df.format(fSaleTypeVATOnProfitSum)%>
        </font></b></td>
    </tr>

    <tr bgcolor="#FA8258">
        <td></td>
        <td><b><font color="red">Total</font></b></td>
        <td><b><font color="red"><%=df.format(fNetSalesSum)%>
        </font></b></td>
        <td><b><font color="red"><%=df.format(fVATSum)%>
        </font></b></td>
        <td><b><font color="red"><%=df.format(fTotalSalesSum)%>
        </font></b></td>
        <td><b><font color="red"><%=df.format(fProfitSum)%>
        </font></b></td>
        <td><b><font color="red"><%=df.format(fVATOnProfitSum)%>
        </font></b></td>
    </tr>
</table>
</body>
</html>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
