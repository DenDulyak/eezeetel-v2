<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Expires", "-1");

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        String strUserId = request.getRemoteUser();
        String strCompanyName = "";
        int nLasthours = 24;
        List records = null, tt_records = null, sim_records = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        int nFeatureID = 0;

        if (!strUserId.isEmpty()) {

            // get customer id
            int nCustomerID = 0;

            String strQuery = "from TCustomerUsers where User_Login_ID = '" + request.getRemoteUser() + "'";
            Query query = theSession.createQuery(strQuery);
            List customer = query.list();
            if (customer.size() > 0) {
                TCustomerUsers custUsers = (TCustomerUsers) customer.get(0);
                TMasterCustomerinfo theCustomer = custUsers.getCustomer();
                nFeatureID = theCustomer.getCustomerFeatureId();
                User theUser = custUsers.getUser();
                if (theCustomer.getActive() && theUser.getUserActiveStatus()) {
                    nCustomerID = theCustomer.getId();
                    strCompanyName = theCustomer.getCompanyName();
                }
            }

            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.HOUR, -nLasthours);
            String strCurTime = sdf.format(cal.getTime());

            if (nCustomerID > 0) {
                strQuery = "select distinct(t1.Transaction_ID), t1.Transaction_Time, t2.User_First_Name, t2.User_Last_Name " +
                        " from t_transactions t1, t_master_users t2 where t1.Customer_ID = " +
                        nCustomerID + " and t1.Transaction_Time > '" + strCurTime + "' " +
                        " and t1.User_ID = t2.User_Login_ID " +
                        " and t1.Committed = 1 order by t1.Transaction_Time desc";

                SQLQuery query1 = theSession.createSQLQuery(strQuery);
                query1.addScalar("Transaction_ID", new LongType());
                query1.addScalar("Transaction_Time", new TimestampType());
                query1.addScalar("User_First_Name", new StringType());
                query1.addScalar("User_Last_Name", new StringType());
                records = query1.list();

                strQuery = "select t1.Transaction_ID, t1.Transaction_Time, t2.User_First_Name, t2.User_Last_Name " +
                        " from t_transferto_transactions t1, t_master_users t2 where t1.Customer_ID = " +
                        nCustomerID + " and t1.Transaction_Time > '" + strCurTime + "' " +
                        " and t1.User_ID = t2.User_Login_ID " +
                        " and t1.Transaction_Status = 1 order by t1.Transaction_Time desc";

                query1 = theSession.createSQLQuery(strQuery);
                query1.addScalar("Transaction_ID", new LongType());
                query1.addScalar("Transaction_Time", new TimestampType());
                query1.addScalar("User_First_Name", new StringType());
                query1.addScalar("User_Last_Name", new StringType());
                tt_records = query1.list();

                strQuery = "select distinct(t1.Transaction_ID), t1.Transaction_Time, t2.User_First_Name, t2.User_Last_Name " +
                        " from t_sim_transactions t1, t_master_users t2 where t1.Customer_ID = " +
                        nCustomerID + " and t1.Transaction_Time > '" + strCurTime + "' " +
                        " and t1.User_ID = t2.User_Login_ID " +
                        " and t1.Committed = 1 order by t1.Transaction_Time desc";

                query1 = theSession.createSQLQuery(strQuery);
                query1.addScalar("Transaction_ID", new LongType());
                query1.addScalar("Transaction_Time", new TimestampType());
                query1.addScalar("User_First_Name", new StringType());
                query1.addScalar("User_Last_Name", new StringType());
                sim_records = query1.list();
            }
        }
%>

<!DOCTYPE html>
<html>
<head>
    <c:import url="../common/libs.jsp" />
    <meta charset="UTF-8">
    <title>Transaction List</title>
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>
        function SubmitForm() {
            if (document.the_form.record_id != null) {
                var nItems = document.the_form.record_id.length;
                if (nItems == null || nItems <= 0) {
                    if (document.the_form.record_id.checked) {
                        document.the_form.transaction_number.value = document.the_form.record_id.value;
                        PrintThisTransaction();
                        return 1;
                    }
                    else
                        alert("Please select a transaction to perform the operation.");
                }
                else {
                    for (var i = 0; i < document.the_form.record_id.length; i++)
                        if (document.the_form.record_id[i].checked) {
                            document.the_form.transaction_number.value = document.the_form.record_id[i].value;
                            PrintThisTransaction();
                            return 1;
                        }

                    alert("Please select a transaction to perform the operation.");
                }
            }
            else
                alert("No records available to perform the operation.");
        }

        function updateTransactionNumber(strValue) {
            if (IsNULL(strValue)) return;
            if (!CheckNumbers(strValue)) return;

            document.the_form.transaction_number.value = "";
            document.the_form.transaction_number.value = strValue;
        }

        function PrintThisTransaction() {
            if (IsNULL(document.the_form.transaction_number.value)) return;
            if (!CheckNumbers(document.the_form.transaction_number.value)) return;

            document.the_form.print_transaction_id.value = document.the_form.transaction_number.value;
            document.the_form.action = "/customer/PrintPreviousTransaction.jsp";
            document.the_form.submit();
            document.the_form.reset();
        }

        function AttachToSIM() {
            if (IsNULL(document.the_form.mobile_number.value) || !CheckNumbers(document.the_form.mobile_number.value)) {
                alert("Please enter a proper mobile number (only digits) to attach.");
                return;
            }

            if (IsNULL(document.the_form.transaction_number.value) || !CheckNumbers(document.the_form.transaction_number.value)) {
                alert("Please enter or select a mobile topup transaction number to attach.");
                return;
            }

            document.the_form.action = "/customer/sim/AttachMobileTopup.jsp";
            document.the_form.submit();
            document.the_form.reset();
        }

    </script>
</head>
<body>
<c:import url="headerNavbar.jsp"/>
<div class="container">
<a href="/customer/products">Show Products</a>
<hr>
<h4>List of Transactions in last <%=nLasthours%> hour by <%=strCompanyName%>
</h4>
<hr>
<form method="post" name="the_form">
    <table border=1>
        <tr>
            <td>
                Enter or Select Transaction Number from below list : &nbsp;
            </td>
            <td>
                <input type="text" name="transaction_number" size="20" maxlength="20"/>
                <input type="hidden" name="print_transaction_id"/>
            </td>
            <td>
                <input type="button" name="print_transaction" value="Print" onClick="PrintThisTransaction()">
            </td>
        </tr>
        <%
            if (nFeatureID == 1) {
        %>
        <tr>
            <td>
                Enter Mobile Phone Number to attach the Transaction : &nbsp;
            </td>
            <td>
                <input type="text" name="mobile_number" size="20" maxlength="20"/>
            </td>
            <td>
                <input type="button" name="attach_transaction" value="Attach Above Transaction To This Mobile"
                       onClick="AttachToSIM()">
            </td>
        </tr>
        <%
            }
        %>
    </table>
    <br><br>
    <table class="table">
        <tr>
            <td></td>
            <td>Transaction Number</td>
            <td>Transaction Date and Time</td>
            <td>User</td>
        </tr>
        <%
            for (int i = 0; records != null && i < records.size(); i++) {
                Object[] oneRecord = (Object[]) records.get(i);
                long nTransactionID = (Long) oneRecord[0];
                java.util.Date dtTransaction = (java.util.Date) oneRecord[1];
                String strDate = sdf.format(dtTransaction);
                String strUserFirstName = (String) oneRecord[2];
                String strUserLastName = (String) oneRecord[3];
        %>
        <tr>
            <td align="right">
                <input type="radio" name="record_id" value="<%=nTransactionID%>"
                       onClick="updateTransactionNumber(this.value)">
            </td>
            <td><%=nTransactionID%>
            </td>
            <td><%=strDate%>
            </td>
            <td><%=strUserFirstName%>   <%=strUserLastName%>
            </td>
        </tr>
        <%
            }

            if (tt_records != null && !tt_records.isEmpty()) {
        %>
        <tr>
            <td><H3> World Mobile Topup Transactions </H3></td>
        </tr>
        <%
            for (int i = 0; i < tt_records.size(); i++) {
                Object[] oneRecord = (Object[]) tt_records.get(i);
                long nTransactionID = (Long) oneRecord[0];
                java.util.Date dtTransaction = (java.util.Date) oneRecord[1];
                String strDate = sdf.format(dtTransaction);
                String strUserFirstName = (String) oneRecord[2];
                String strUserLastName = (String) oneRecord[3];
        %>
        <tr>
            <td align="right">
                <input type="radio" name="record_id" value="<%=nTransactionID%>"
                       onClick="updateTransactionNumber(this.value)">
            </td>
            <td><%=nTransactionID%>
            </td>
            <td><%=strDate%>
            </td>
            <td><%=strUserFirstName%>   <%=strUserLastName%>
            </td>
        </tr>
        <%
                }
            }

            if (sim_records != null && sim_records.size() > 0) {
        %>
        <tr>
            <td><H3> SIM Transactions </H3></td>
        </tr>
        <%
            for (int i = 0; i < sim_records.size(); i++) {
                Object[] oneRecord = (Object[]) sim_records.get(i);
                long nTransactionID = (Long) oneRecord[0];
                java.util.Date dtTransaction = (java.util.Date) oneRecord[1];
                String strDate = sdf.format(dtTransaction);
                String strUserFirstName = (String) oneRecord[2];
                String strUserLastName = (String) oneRecord[3];
        %>
        <tr>
            <td align="right">
                <input type="radio" name="record_id" value="<%=nTransactionID%>"
                       onClick="updateTransactionNumber(this.value)">
            </td>
            <td><%=nTransactionID%>
            </td>
            <td><%=strDate%>
            </td>
            <td><%=strUserFirstName%>   <%=strUserLastName%>
            </td>
        </tr>
        <%
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                HibernateUtil.closeSession(theSession);
            }
        %>
    </table>
</form>
</div>
</body>
</html>