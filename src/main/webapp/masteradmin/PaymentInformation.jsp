<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Payment Information for a given day</title>
    <script language="javascript" src="/GenericApp/Scripts/Validate.js"></script>
    <script language="javascript">
        function get_payment_info() {
            document.the_form.action = "/masteradmin/PaymentInformation.jsp";
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

<%

    String selectedYear = request.getParameter("start_year_name");
    String selectedMonth = request.getParameter("start_month_name");

    int nSelectedYear = 0;
    int nSelectedMonth = -1;

    if (selectedYear != null && !selectedYear.isEmpty())
        nSelectedYear = Integer.parseInt(selectedYear);

    if (selectedMonth != null && !selectedMonth.isEmpty())
        nSelectedMonth = Integer.parseInt(selectedMonth);
%>

<form method="post" name="the_form" action="">

    <table border="1" width="100%">
        <tr bgcolor="#99CCFF">
            <td> Year</td>
            <td>
                <select name="start_year_name" onchange="get_payment_info()">
                    <%
                        String strSelected = "";
                        if (nSelectedYear == nCurrentYear) strSelected = "selected";
                    %>
                    <option value="<%=nCurrentYear%>" <%=strSelected%>><%=nCurrentYear%>
                    </option>
                    <%
                        strSelected = "";
                        if (nSelectedYear == nPreviousYear) strSelected = "selected";
                    %>
                    <option value="<%=nPreviousYear%>" <%=strSelected%>><%=nPreviousYear%>
                    </option>
                </select>
            </td>
            <td> Month</td>
            <td>
                <select name="start_month_name" onchange="get_payment_info()">
                    <%
                        for (int nMonth = 0; nMonth < 12; nMonth++) {
                            strSelected = "";
                            if (nSelectedMonth == nMonth) strSelected = "selected";
                    %>
                    <option value="<%=nMonth%>" <%=strSelected%>><%=months[nMonth]%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
            <td align="center">
                <a href=MasterInformation.jsp> Go to Main </a>
            </td>
        </tr>
    </table>

    <table border="1" width="100%">
        <tr>
            <td> Date</td>
            <td> Cash Payment</td>
            <td> Bank Payment</td>
            <td> Credit Given (Receivables)</td>
            <td> Credit ID List</td>
        </tr>

        <%
            Float fSumCashPayment = 0.0f;
            Float fSumBankPayment = 0.0f;
            Float fSumCreditGiven = 0.0f;

            if (nSelectedMonth >= 0 && nSelectedYear > 0) {
                Session theSession = null;
                try {
                    theSession = HibernateUtil.openSession();

                    Calendar cal = Calendar.getInstance();
                    cal.set(Calendar.YEAR, nSelectedYear);
                    cal.set(Calendar.MONTH, nSelectedMonth);
                    int nTotalDays = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
                    nSelectedMonth++;

                    for (int nDay = 1; nDay <= nTotalDays; nDay++) {
                        String strDurationBegin = nSelectedYear + "-" + nSelectedMonth + "-" + nDay + " 00:00:00";
                        String strDurationEnd = nSelectedYear + "-";
                        if (nDay == nTotalDays) {
                            if (nSelectedMonth == 12) {
                                nSelectedMonth = 0;
                                nSelectedYear++;
                                strDurationEnd = nSelectedYear + "-";
                            }

                            strDurationEnd += (nSelectedMonth + 1) + "-1 00:00:00";
                        } else
                            strDurationEnd += nSelectedMonth + "-" + (nDay + 1) + " 00:00:00";

                        String strQuery = "call SP_Cash_Balance_Report ('" + strDurationBegin + "', '" + strDurationEnd + "')";

                        SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
                        sqlQuery.addScalar("the_date", new DateType());
                        sqlQuery.addScalar("cash_payment", new FloatType());
                        sqlQuery.addScalar("bank_payment", new FloatType());
                        sqlQuery.addScalar("credit_given", new FloatType());
                        sqlQuery.addScalar("CreditIDs", new StringType());
                        List records = sqlQuery.list();

                        for (int nRecord = 0; nRecord < records.size(); nRecord++) {
                            Object[] oneRecord = (Object[]) records.get(nRecord);
                            Date theDate = (Date) oneRecord[0];
                            Float fCashPayment = (Float) oneRecord[1];
                            Float fBankPayment = (Float) oneRecord[2];
                            Float fCreditGiven = (Float) oneRecord[3];
                            String strCreditIDs = (String) oneRecord[4];

                            if (fCashPayment == null)
                                fCashPayment = 0.0f;
                            if (fBankPayment == null)
                                fBankPayment = 0.0f;
                            if (fCreditGiven == null)
                                fCreditGiven = 0.0f;
                            if (strCreditIDs == null)
                                strCreditIDs = "";

                            fSumCashPayment += fCashPayment;
                            fSumBankPayment += fBankPayment;
                            fSumCreditGiven += fCreditGiven;
        %>
        <tr>
            <td><%=theDate%>
            </td>
            <td><%=fCashPayment%>
            </td>
            <td><%=fBankPayment%>
            </td>
            <td><%=fCreditGiven%>
            </td>
            <td><%=strCreditIDs%>
            </td>
        </tr>
        <%
                }
            }
        %>

        <tr>
            <td bgcolor="red"> Total</td>
            <td bgcolor="red"><%=fSumCashPayment%>
            </td>
            <td bgcolor="red"><%=fSumBankPayment%>
            </td>
            <td bgcolor="red"><%=fSumCreditGiven%>
            </td>
        </tr>
        <%
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    HibernateUtil.closeSession(theSession);
                }
            }
        %>
    </table>
</form>
</body>
</html>