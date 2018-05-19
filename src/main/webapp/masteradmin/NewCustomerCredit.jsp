<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <script language="javascript" src="/GenericApp/Scripts/Validate.js"></script>
    <script language="javascript">

        function CheckDatesValidtiy() {
            if (!CheckDate(document.the_form.payment_date.value)) return false;

            var temp = new Array();
            temp = document.the_form.payment_date.value.split('-');
            var month_no = getMonthNumber(temp[1]);
            var the_payment_date = new Date(temp[2], month_no, temp[0]);

            var todays_date = new Date();
            var last_month_date = new Date();
            last_month_date.setDate(last_month_date.getDate() - 32);

            if (the_payment_date > todays_date) {
                alert("Payment date can not be future date.  Please check it");
                return false;
            }

            if (the_payment_date < last_month_date) {
                alert("Payment date is older than a month.  Please check it");
                return false;
            }

            return true;
        }

        function ValidateInput() {
            var errString = "";

            if (!CheckNumbers(document.the_form.payment_amount.value, "."))
                errString += "\r\nPlease enter proper amount";

            if (document.the_form.payment_amount.value < 10)
                errString += "\r\nPayment amount can not be less than 10.";

            if (document.the_form.payment_amount.value > 500)
                errString += "\r\nPayment amount can not be more than 500.";

            if (!CheckDate(document.the_form.payment_date.value))
                errString += "\r\nPlease enter a proper date";

            if (!CheckDatesValidtiy())
                errString = "\r\nPlease select proper date";

            if (errString == null || errString.length <= 0) {
                for (i = 0; i < document.the_form.elements.length; i++)
                    if (document.the_form.elements[i].type == "text")
                        CheckDatabaseChars(document.the_form.elements[i]);
            }
            else {
                alert(errString);
                return false;
            }

            return true;
        }

        function AddOnly() {
            if (!ValidateInput()) return;

            if (document.the_form.credit_or_debit.value == 2) // DEBIT transaction
            {
                alert("For DEBIT transactions, only Add & Adjust can be done.  Please click on Add & Adjust button");
                return;
            }

            if (!confirm("Are you sure customer balance will NOT be updated?"))
                return;

            document.the_form.action = "AddCustomerCredit.jsp";
            document.the_form.submit();
        }

        function AddAndAdjust() {
            if (!ValidateInput()) return;
            document.the_form.action = "AddAndAdjustCustomerCredit.jsp";
            document.the_form.submit();
        }

        function onInitialLoad() {
            var dt = new Date();
            var day = dt.getDate();
            var month = dt.getMonth();
            var year = dt.getFullYear();

            month = getShortNameMonth(month);
            var finalDate = day + "-" + month + "-" + year;
            document.the_form.payment_date.value = finalDate;
        }

    </script>
    <title>New Customer Credit</title>
</head>
<body>
<form method="post" name="the_form" action="">
    <table width="100%">
        <tr>
            <td align="right">
                Customer :
            </td>
            <td align="left">
                <genericappdb:CustomerList name="customer_id" active_records_only="1" initial_option="Select"
                                           onChange=""/>
            </td>
        </tr>
        <tr>
            <td align="right">
                Payment Type :
            </td>
            <td align="left">
                <select name="payment_type">
                    <option value="1">Cash</option>
                    <option value="2">Cheque</option>
                    <option value="3">Bank Deposit</option>
                    <option value="4">Funds Transfer</option>
                    <option value="5">Debit/Credit Card"</option>
                </select>
            </td>
        </tr>
        <tr>
            <td align="right">
                Payment Details :
            </td>

            <td align="left">
                <input type="text" name="payment_details" size="50" maxlength="200">
            </td>
        </tr>
        <tr>
            <td align="right">
                Payment Amount :
            </td>

            <td align="left">
                <input type="text" name="payment_amount" size="5" maxlength="8">
            </td>
        </tr>
        <tr>
            <td align="right">
                <font color="red">Credit/Debit :</font>
            </td>
            <td align="left">

                <select name="credit_or_debit">
                    <option value="1">Credit</option>
                    <option value="2" selected>DEBIT</option>
                </select>
            </td>
            <td>
                <font color="red">Credit means - customer credited money into our account or by cash gave money</font>
                <BR>
                <font color="red">DEBIT means - customer did not give money, but we are allowing temporarily by giving
                    credit</font>
            </td>
        </tr>
        <%
            Session theSession = null;
            try {
                Calendar cal = Calendar.getInstance();
                SimpleDateFormat sf = new SimpleDateFormat("dd-MMM-yyyy");
                String strPaymentDate = sf.format(cal.getTime());

                theSession = HibernateUtil.openSession();
        %>
        <tr>
            <td align="right">
                Payment Date :
            </td>

            <td align="left">
                <input type="text" name="payment_date" size="11" maxlength="11" value="<%=strPaymentDate%>">
                (dd-mmm-yyyy)
                <input type="hidden" name="entered_by" value="<%=request.getRemoteUser()%>">
            </td>
        </tr>

        <tr>
            <td align="right">
                Collected By :
            </td>
            <td align="left">
                <select name="collected_by">
                    <%
                        String strQuery = "from User where User_Active_Status=1 AND " +
                                "(User_Type_And_Privilege > 1 AND User_Type_And_Privilege <= 6)";

                        Query query = theSession.createQuery(strQuery);
                        List records = query.list();

                        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                            User userInfo = (User) records.get(nIndex);
                    %>
                    <option value="<%=userInfo.getLogin()%>"><%=userInfo.getUserFirstName()%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>

        <tr>
            <td align="center">
                <a href="MasterInformation.jsp"> Go to Main </a>
            </td>

            <!-- <td align="center">
                <input type="button" name="add_button" value="Add" onClick="AddOnly()">
            </td> -->

            <td align="center">
                <input type="button" name="add_and_adjust_button" value="Add & Adjust" onClick="AddAndAdjust()">
            </td>

            <td align="center">
                <input type="reset" name="clear_button" value="Clear">
            </td>
        </tr>
    </table>

    <%
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
    %>
</form>
</body>
</html>