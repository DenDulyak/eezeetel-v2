<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    String strCreditID = request.getParameter("credit_id");
    int nCreditID = 0;
    if (strCreditID != null && !strCreditID.isEmpty())
        nCreditID = Integer.parseInt(strCreditID);

    String strQuery = "from TMasterCustomerCredit where Credit_ID = " + nCreditID;

    int nCustomerID = 0;
    int nPaymentType = 0;
    String strPaymentDetails = "";
    Float fPaymentAmount = 0.00f;
    int nCreditOrDebit = 0;
    String strPaymentDate = "";
    String strUserCollected = "";
    String strCompanyName = "";

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

        Query theQuery = theSession.createQuery(strQuery);
        List records = theQuery.list();
        if (records.size() > 0) {
            TMasterCustomerCredit custCredit = (TMasterCustomerCredit) records.get(0);
            TMasterCustomerinfo custInfo = custCredit.getCustomer();
            if (custInfo.getGroup().getId().intValue() == nCustomerGroupID) {
                User userCollected = custCredit.getCollectedBy();
                strUserCollected = userCollected.getUserFirstName();
                nCustomerID = custInfo.getId();
                strCompanyName = custInfo.getCompanyName();
                nPaymentType = custCredit.getPaymentType();
                strPaymentDetails = custCredit.getPaymentDetails();
                fPaymentAmount = custCredit.getPaymentAmount();
                nCreditOrDebit = custCredit.getCreditOrDebit();
                Date dtPaymentDate = custCredit.getPaymentDate();
                SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yyyy", Locale.ENGLISH);
                if (dtPaymentDate != null)
                    strPaymentDate = dt.format(dtPaymentDate);
                else {
                    Calendar cal = Calendar.getInstance();
                    strPaymentDate = dt.format(cal.getTime());
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta lang="en">
    <script src="/js/libs/jquery.min.js"></script>
    <script language="javascript" src="/js/validate.js"></script>
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

        function hasCreditLimit() {
            var customerId = <%=nCustomerID%>;
            var result = false;
            if (customerId > 0) {
                $.ajax({
                    type: 'GET',
                    async: false,
                    url: '/admin/customer/has-credit-limit',
                    data: {
                        customerId: customerId
                    },
                    dataType: 'json',
                    success: function (data) {
                        result = data;
                    }
                });
            }
            return result;
        }

        var isCreditLimit = hasCreditLimit();

        function ValidateInput() {
            var errString = "";

            if (!CheckNumbers(document.the_form.payment_amount.value, "."))
                errString += "\r\nPlease enter proper amount";

            if (document.the_form.payment_amount.value < 10)
                errString += "\r\nPayment amount can not be less than 10.";

            if (document.the_form.payment_amount.value > 500 && !isCreditLimit)
                errString += "\r\nPayment amount can not be more than 5000.";

            if (document.the_form.payment_amount.value > 20000 && isCreditLimit)
                errString += "\r\nPayment amount can not be more than 20000.";

            if (!CheckDate(document.the_form.payment_date.value))
                errString += "\r\nPlease enter a proper date";

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

        function UpdateRecord() {
            if (!ValidateInput()) return;

            document.the_form.action = "/admin/Accounts/UpdateCustomerCredit.jsp";
            document.the_form.submit();
        }

    </script>
    <title>Modify Customer Credit</title>
</head>
<body>
<form method="post" name="the_form" action="">
    <table width="100%">
        <tr>
            <td align="right">
                Customer :
            </td>
            <td align="left">
                <input type="text" name="customer_id" value="<%=strCompanyName%>" readonly>
            </td>
        </tr>
        <tr>
            <td align="right">
                Payment Details :
            </td>

            <td align="left">
                <input type="text" name="payment_details" size="50" maxlength="200" value="<%=strPaymentDetails%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Payment Amount :
            </td>

            <td align="left">
                <input type="text" name="payment_amount" size="5" maxlength="8" value="<%=fPaymentAmount%>" readonly>
            </td>
        </tr>
        <tr>
            <td align="right">
                Payment Date :
            </td>

            <td align="left">
                <input type="text" name="payment_date" size="11" maxlength="11" value="<%=strPaymentDate%>" readonly>
                (dd-mmm-yyyy)
                <input type="hidden" name="credit_id" value="<%=nCreditID%>">
            </td>
        </tr>
        <tr>
            <td align="right">
                Payment Type :
            </td>
            <td align="left">
                <select name="payment_type">
                    <%
                        String strSelectedOne = "";
                        String strSelectedTwo = "";
                        String strSelectedThree = "";
                        String strSelectedFour = "";
                        String strSelectedFive = "";
                        if (nPaymentType == 1)
                            strSelectedOne = "selected";
                        if (nPaymentType == 2)
                            strSelectedTwo = "selected";
                        if (nPaymentType == 3)
                            strSelectedThree = "selected";
                        if (nPaymentType == 4)
                            strSelectedFour = "selected";
                        if (nPaymentType == 5)
                            strSelectedFive = "selected";
                    %>

                    <option value="1" <%=strSelectedOne%>>Cash</option>
                    <option value="2" <%=strSelectedTwo%>>Cheque</option>
                    <option value="3" <%=strSelectedThree%>>Bank Deposit</option>
                    <option value="4" <%=strSelectedFour%>>Funds Transfer</option>
                    <option value="5" <%=strSelectedFive%>>Debit/Credit Card"</option>
                </select>
            </td>
        </tr>
        <tr>
            <td align="right">
                <font color="red">Credit/Debit :</font>
            </td>
            <td align="left">

                <%
                    strSelectedOne = "";
                    strSelectedTwo = "";
                    if (nCreditOrDebit == 1)
                        strSelectedOne = "selected";
                    else if (nCreditOrDebit == 2)
                        strSelectedTwo = "selected";
                %>

                <select name="credit_or_debit">
                    <option value="1" <%=strSelectedOne%>>Credit</option>
                    <option value="2" <%=strSelectedTwo%>>DEBIT</option>
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

            try {
                theSession = HibernateUtil.openSession();

                Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
        %>
        <tr>
            <td align="right">
                Collected By :
            </td>
            <td align="left">
                <select name="collected_by">
                    <%
                        strQuery = "from User where User_Active_Status = 1 AND Customer_Group_ID = " + nCustomerGroupID +
                                " and (User_Type_And_Privilege = 4 OR User_Type_And_Privilege = 5 OR User_Login_ID = '" + request.getRemoteUser() + "'" +
                                " OR User_Login_ID = 'Pending') order by User_First_Name";

                        Query query = theSession.createQuery(strQuery);
                        List records = query.list();

                        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                            User userInfo = (User) records.get(nIndex);
                            String strSelected = "";
                            if (userInfo.getUserFirstName().compareToIgnoreCase(strUserCollected) == 0)
                                strSelected = "selected";
                            String isAgent = "";
                            if (userInfo.getUserType().getId() == 6)
                                isAgent = " - AGENT";
                    %>
                    <option value="<%=userInfo.getLogin()%>" <%=strSelected%>><%=userInfo.getUserFirstName()%><%=isAgent%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>

        <tr>
            <td align="center">
                <a href="/admin"> Admin Main </a>
            </td>

            <td align="center">
                <input type="button" name="update_button" value="Update" onClick="UpdateRecord()">
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