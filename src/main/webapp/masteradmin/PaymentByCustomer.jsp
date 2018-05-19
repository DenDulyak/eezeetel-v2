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
            document.the_form.action = "/masteradmin/PaymentByCustomer.jsp";
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
    String selectedDay = request.getParameter("start_day_name");
    String strPaymentType = request.getParameter("payment_type");

    int nSelectedYear = 0;
    int nSelectedMonth = -1;
    int nSelectedDay = 0;
    int nPaymentType = 3;
    String strType = "Bank Payment";

    if (selectedYear != null && !selectedYear.isEmpty())
        nSelectedYear = Integer.parseInt(selectedYear);

    if (selectedMonth != null && !selectedMonth.isEmpty())
        nSelectedMonth = Integer.parseInt(selectedMonth);

    if (selectedDay != null && !selectedDay.isEmpty())
        nSelectedDay = Integer.parseInt(selectedDay);

    if (strPaymentType != null && !strPaymentType.isEmpty())
        nPaymentType = Integer.parseInt(strPaymentType);
%>

<form method="post" name="the_form" action="">

    <table border="1" width="100%">
        <tr bgcolor="#99CCFF">
            <td> Year</td>
            <td>
                <select name="start_year_name">
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
                <select name="start_month_name">
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
            <td> Day</td>
            <td>
                <select name="start_day_name">
                    <%
                        for (int nDay = 1; nDay <= 31; nDay++) {
                            strSelected = "";
                            if (nSelectedDay == nDay) strSelected = "selected";
                    %>
                    <option value="<%=nDay%>" <%=strSelected%>><%=nDay%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
            <td> Payment Type</td>
            <td>
                <select name="payment_type">
                    <%
                        for (int nType = 0; nType <= 3; nType++) {
                            if (nType == 2) continue;
                            strSelected = "";
                            if (nPaymentType == nType) strSelected = "selected";

                            String strDisplayType = "Bank Payment";
                            if (nType == 0) strDisplayType = "Credit Given";
                            if (nType == 1) strDisplayType = "Cash Payment";
                            if (nPaymentType == 0) strType = "Credit Given";
                            if (nPaymentType == 1) strType = "Cash Payment";

                    %>
                    <option value="<%=nType%>" <%=strSelected%>><%=strDisplayType%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
            <td align="center">
                <input type="button" name="generate" value="Get Details" onClick="get_payment_info()"/>
            </td>
            <td align="center">
                <a href=MasterInformation.jsp> Go to Main </a>
            </td>
        </tr>
    </table>

    <table border="1" width="100%">
        <tr>
            <td align="center"><b>Customer</b></td>
            <td align="center"><b><%=strType%>
            </b></td>
            <%
                if (nPaymentType == 0) {
            %>
            <td align="center"><b>Credit ID List</b></td>
            <%
                }
            %>
        </tr>

        <%
            Float fSumPayment = 0.0f;

            if (nSelectedMonth >= 0 && nSelectedYear > 0 && nSelectedDay > 0) {
                Session theSession = null;
                try {
                    theSession = HibernateUtil.openSession();

                    Calendar cal = Calendar.getInstance();
                    cal.set(Calendar.YEAR, nSelectedYear);
                    cal.set(Calendar.MONTH, nSelectedMonth);
                    int nTotalDays = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
                    if (nSelectedDay > 0 && nSelectedDay <= nTotalDays) {
                        cal.set(Calendar.DAY_OF_MONTH, nSelectedDay);
                        nSelectedMonth++;
                        String strDurationBegin = nSelectedYear + "-" + nSelectedMonth + "-" + nSelectedDay + " 00:00:00";
                        String strDurationEnd = nSelectedYear + "-" + nSelectedMonth + "-" + nSelectedDay + " 23:59:59";

                        String strQuery = "from TMasterCustomerinfo where Active_Status = 1 and Customer_ID not in (186, 28, 45) order by Customer_Company_Name";
                        Query query = theSession.createQuery(strQuery);
                        List customers = query.list();

                        for (int nCustomer = 0; nCustomer < customers.size(); nCustomer++) {
                            Float fPayment = 0f;
                            String strCreditIDs = "";

                            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) customers.get(nCustomer);

                            if (nPaymentType != 0) {
                                strQuery = "select sum(Payment_Amount) as Payment from t_master_customer_credit where Customer_ID = " + custInfo.getId() +
                                        " and Payment_Date >= '" + strDurationBegin + "'" +
                                        " and Payment_Date <= '" + strDurationEnd + "'" +
                                        " and Payment_Type = " + nPaymentType + " and Credit_or_Debit = 1";

                                SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
                                sqlQuery.addScalar("Payment", new FloatType());
                                List paymentList = sqlQuery.list();
                                if (paymentList.size() > 0)
                                    if (paymentList.get(0) != null)
                                        fPayment = (Float) paymentList.get(0);
                            } else {
                                // debit

                                strQuery = "select sum(Payment_Amount) as Payment from t_master_customer_credit where Customer_ID = " + custInfo.getId() +
                                        " and Payment_Date >= '" + strDurationBegin + "'" +
                                        " and Payment_Date <= '" + strDurationEnd + "'" +
                                        " and Credit_or_Debit = 2";

                                SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
                                sqlQuery.addScalar("Payment", new FloatType());
                                List paymentList = sqlQuery.list();
                                if (paymentList.size() > 0)
                                    if (paymentList.get(0) != null)
                                        fPayment = (Float) paymentList.get(0);

                                if (fPayment != null && fPayment > 0) {

                                    strQuery = "select group_concat(Credit_ID) as creditlist from t_master_customer_credit where Customer_ID = " + custInfo.getId() +
                                            " and Payment_Date >= '" + strDurationBegin + "'" +
                                            " and Payment_Date <= '" + strDurationEnd + "'" +
                                            " and Credit_or_Debit = 2";

                                    sqlQuery.addScalar("creditlist", new StringType());
                                    paymentList = sqlQuery.list();
                                    if (paymentList.size() > 0)
                                        if (paymentList.get(0) != null)
                                            strCreditIDs = (String) paymentList.get(0);
                                }
                            }


                            if (fPayment == null)
                                fPayment = 0.0f;
                            if (strCreditIDs == null)
                                strCreditIDs = "";

                            if (fPayment > 0) {
                                fSumPayment += fPayment;
        %>
        <tr>
            <td><%=custInfo.getCompanyName()%>
            </td>
            <td><%=fPayment%>
            </td>
            <%
                if (nPaymentType == 0) {
            %>
            <td><%=strCreditIDs%>
            </td>
            <%
                }
            %>
        </tr>
        <%
                    }
                }
            }
        %>

        <tr>
            <td bgcolor="red"> Total</td>
            <td bgcolor="red"><%=fSumPayment%>
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