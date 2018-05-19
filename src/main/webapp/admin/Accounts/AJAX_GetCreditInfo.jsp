<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>


<%
    String strCutoffDate = "2012-04-01 00:00:00";
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Calendar cal = Calendar.getInstance();
    cal.setTime(sdf.parse(strCutoffDate));
    cal.add(Calendar.SECOND, -1);
    String strPreviousYear = sdf.format(cal.getTime());

    strCutoffDate = "'" + strCutoffDate + "'";

    String strCustomerID = request.getParameter("customer_id");
    int nCustomerID = 0;
    if (strCustomerID != null && !strCustomerID.isEmpty())
        nCustomerID = Integer.parseInt(strCustomerID);
    if (nCustomerID == 0) return;

    Session theSession = null;
    DecimalFormat df = new DecimalFormat("0.##");
    Object objValue;
    try {
        theSession = HibernateUtil.openSession();

        String strQuery = "from TMasterCustomerinfo where Active_Status = 1 and Customer_ID = " + nCustomerID;
        Query query = theSession.createQuery(strQuery);
        List list = query.list();
        if (list.size() > 0) {
            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) list.get(0);
            TMasterCustomerGroups custGroup = custInfo.getGroup();
            Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
            if (custGroup.getId().intValue() != nCustomerGroupID) {
                theSession.getTransaction().commit();
                return;
            }

            strQuery = "select sum(Payment_Amount) as Payment_Amount from t_master_customer_credit where Customer_ID = " +
                    custInfo.getId() + " and Credit_or_Debit = 1 and Payment_Date >= " + strCutoffDate;

            SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addScalar("Payment_Amount", new FloatType());
            List paymentList = sqlQuery.list();
            float fTotalCredit = 0.0f;
            if (paymentList.size() > 0) {
                objValue = paymentList.get(0);
                if (objValue != null)
                    fTotalCredit = Float.parseFloat(objValue.toString());
            }

            strQuery = "select sum(Payment_Amount) as Payment_Amount from t_master_customer_credit where Customer_ID = " +
                    custInfo.getId() + " and Credit_or_Debit = 2 and Entered_Time >= " + strCutoffDate;

            sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addScalar("Payment_Amount", new FloatType());
            paymentList = sqlQuery.list();

            float fTotalDebit = 0.0f;
            if (paymentList.size() > 0) {
                objValue = paymentList.get(0);
                if (objValue != null)
                    fTotalDebit = Float.parseFloat(objValue.toString());
            }

            strQuery = "select sum(Cost_To_Customer) as total_spent from t_report_customer_profit where Customer_ID = " + custInfo.getId() + " and Customer_Group_ID = " + nCustomerGroupID +
                    " and Begin_Date >= " + strCutoffDate;

            sqlQuery = theSession.createSQLQuery(strQuery);

            sqlQuery.addScalar("total_spent", new FloatType());
            List spentList = sqlQuery.list();
            float fTotalSepnt = 0.0f;
            if (spentList.size() > 0) {
                objValue = spentList.get(0);
                if (objValue != null)
                    fTotalSepnt = Float.parseFloat(objValue.toString());
            }

            strQuery = "from TReportCustomerCredit where Customer_ID = " + custInfo.getId() +
                    " and Customer_Group_ID = " + nCustomerGroupID + " order by Begin_Date desc";

            query = theSession.createQuery(strQuery);
            query.setMaxResults(1);
            List balanceList = query.list();
            float fBeginningBalance = 0.0f;
            float fBeginningDebt = 0.0f;
            TReportCustomerCredit reportCredit = null;
            if (balanceList.size() > 0) {
                reportCredit = (TReportCustomerCredit) balanceList.get(0);
                if (reportCredit != null) {
                    fBeginningBalance = reportCredit.getBalanceOnEndDate();
                    fBeginningDebt = reportCredit.getTotalDebitOnEndDate();
                }
            }

            float fTotalPayment = fTotalCredit + fTotalDebit - fBeginningDebt;

            String strBalanceShouldHaveBeen = df.format(fTotalPayment - fTotalSepnt + fBeginningBalance);
            String strBalanceIs = df.format(custInfo.getCustomerBalance());

            int nBalanceShouldBe = (int) (fTotalPayment - fTotalSepnt + fBeginningBalance);
            int nBalanceIs = (int) (custInfo.getCustomerBalance());

            String strTallied = "YES";
            if (nBalanceShouldBe != nBalanceIs)
                strTallied = "NO";

            String strLast5Payments = "";

            strQuery = "from TMasterCustomerCredit where Customer_ID = " +
                    custInfo.getId() + " and Entered_Time >= " + strCutoffDate +
                    " order by Entered_Time desc";

            query = theSession.createQuery(strQuery);
            query.setMaxResults(5);
            List latestTransactions = query.list();

            for (int i = 0; i < latestTransactions.size(); i++) {
                TMasterCustomerCredit custCredit = (TMasterCustomerCredit) latestTransactions.get(i);
                if (custCredit.getCreditOrDebit() == 1) {
                    switch (custCredit.getPaymentType()) {
                        case 1:
                            strLast5Payments += "Cash, ";
                            break;
                        case 2:
                            strLast5Payments += "Cheque, ";
                            break;
                        case 3:
                            strLast5Payments += "Bank, ";
                            break;
                        case 4:
                            strLast5Payments += "Transfer, ";
                            break;
                        case 5:
                            strLast5Payments += "Card, ";
                            break;
                    }
                }
                if (i == 5) break;
            }

            String strResult = "<table border=\"1\">";
            strResult += "<tr> <td> Customer ID </td>";
            strResult += "<td>" + custInfo.getId() + "</td></tr>";

            strResult += "<tr> <td> Customer </td>";
            strResult += "<td>" + custInfo.getCompanyName() + "</td></tr>";

            strResult += "<tr> <td> Customer Address </td>";
            strResult += "<td>" + custInfo.getAddressLine1() + ", " + custInfo.getAddressLine2();
            strResult += ", " + custInfo.getCity() + "</td></tr>";

            strResult += "<tr> <td> Total Credits </td>";
            strResult += "<td>" + df.format(fTotalCredit) + "</td></tr>";

            strResult += "<tr> <td> Total Debits </td>";
            strResult += "<td>" + df.format(fTotalDebit) + "</td></tr>";

            strResult += "<tr> <td> Total Payment </td>";
            strResult += "<td>" + df.format(fTotalPayment) + "</td></tr>";

            strResult += "<tr> <td> Total Spending </td>";
            strResult += "<td>" + df.format(fTotalSepnt) + "</td></tr>";

            strResult += "<tr> <td> Beginning Balance (" + strCutoffDate + ")</td>";
            strResult += "<td>" + df.format(fBeginningBalance) + "</td></tr>";

            strResult += "<tr> <td> Balance Should Be </td>";
            strResult += "<td>" + strBalanceShouldHaveBeen + "</td></tr>";

            strResult += "<tr> <td> Balance Is </td>";
            strResult += "<td>" + strBalanceIs + "</td></tr>";

            strResult += "<tr> <td> Tallied </td>";
            strResult += "<td>" + strTallied + "</td></tr>";

            strResult += "<tr> <td> Last 5 Payments </td>";
            strResult += "<td>" + strLast5Payments + "</td></tr>";

            if (reportCredit != null) {
                strResult += "<tr bgcolor=yellow><td> Year End Record ( " + strPreviousYear + ")</td>";
                strResult += "<td> Credit : " + reportCredit.getTotalCreditSoFar() + "</td>";
                strResult += "<td> Debit : " + reportCredit.getTotalDebitOnEndDate() + "</td></tr>";
            }

            strResult += "<tr> <td> <font color=\"red\">Recent Debits </font></td>";
            for (int i = 0; i < latestTransactions.size(); i++) {
                TMasterCustomerCredit custCredit = (TMasterCustomerCredit) latestTransactions.get(i);
                if (custCredit.getCreditOrDebit() == 1)
                    continue;

                strResult += "<tr><td scope=\"row\">" + custCredit.getId() + "&nbsp;&nbsp; - &nbsp;&nbsp;" + custCredit.getEnteredTime() + "</td>";
                strResult += "<td>" + custCredit.getPaymentAmount() + "</td>";
                strResult += "<td><input type=\"button\" value=\"Update\" OnClick=\"UpdateDebit(this.name)\" Name=\"" + custCredit.getId() + "\"></td></tr>";
            }
            strResult += "</tr>";
            strResult += "</table>";

            response.setContentType("text/html");
            response.getWriter().println(strResult);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
