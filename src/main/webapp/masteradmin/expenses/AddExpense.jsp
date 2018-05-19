<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Add Expense</title>
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">

        <%
        Calendar cal = Calendar.getInstance();
        String[] months = {"January", "February",
                  "March", "April", "May", "June", "July",
                  "August", "September", "October", "November",
                  "December"};
        %>

        function daysInMonth(month, year) {
            month = eval(month) + 1;
            return new Date(year, month, 0).getDate();
        }

        var nCurrentYear = <%=cal.get(Calendar.YEAR)%>;
        var nCurrentMonth = <%=cal.get(Calendar.MONTH)%>;
        var nCurrentDay = <%=cal.get(Calendar.DAY_OF_MONTH)%>;
        var nCurrentHour = <%=cal.get(Calendar.HOUR_OF_DAY)%>;

        function validate_hour() {
            if (document.the_form.the_month.value == nCurrentMonth && document.the_form.the_year.value == nCurrentYear
                    && document.the_form.the_day.value == nCurrentDay) {
                if (document.the_form.the_hour.value > nCurrentHour) {
                    alert("The payment time (hour) is beyond the present time (is in future time).  Please select what time you made the payment");
                    document.the_form.the_hour.focus();
                    return;
                }
            }

            if (document.the_form.payment_type.value == 3) {
                if (document.the_form.the_hour.value > 17 || document.the_form.the_hour.value < 9) {
                    alert("Bank hours are generally from 9 AM to 5 PM.  Please select the correct time if it is a bank deposit.");
                    document.the_form.the_hour.focus();
                    return;
                }
            }
        }

        function update_days() {
            var nUpdateDays = nCurrentDay;
            if (document.the_form.the_month.value != nCurrentMonth || document.the_form.the_year.value != nCurrentYear)
                nUpdateDays = daysInMonth(document.the_form.the_month.value, document.the_form.the_year.value);


            var element = document.getElementById('the_day_id');
            for (var i = 0; i < element.length; i++)
                element.remove(i);
            element.innerHTML = "";

            for (var i = nUpdateDays; i > 0; i--) {
                var elOption1 = document.createElement('option');
                elOption1.value = i;
                elOption1.innerHTML = i;
                element.appendChild(elOption1);
            }
        }

        function cofirmAddExpense() {
            var errString = "";

            if (!CheckNumbers(document.the_form.expense_amount.value, "."))
                errString += "\r\Please enter a proper whole amount";

            if (IsNULL(document.the_form.expense_purpose.value))
                errString += "\r\Expense Purpose must have only characters and numbers.  Please enter proper purpose";
            CheckDatabaseChars(document.the_form.expense_purpose);

            if (document.the_form.expense_type.value == 0)
                errString += "\rPlease select an expense type";

            var systemDate = new Date(nCurrentYear, nCurrentMonth, nCurrentDay, nCurrentHour, 0, 0);
            var selectedDate = new Date(document.the_form.the_year.value, document.the_form.the_month.value,
                    document.the_form.the_day.value, 0, 0, 0);
            var difference = systemDate - selectedDate;
            difference = Math.round(difference / 1000 * 60 * 60);

            if (difference < 0)
                errString += "\r\Expense Date is in future time.  Please select a correct expense date";

            if (errString == null || errString.length <= 0) {
                if (!confirm("Are you sure to Add the Expense " + document.the_form.expense_amount.value))
                    return;

                document.the_form.action = "/masteradmin/expenses/ConfirmAddExpense.jsp";
                document.the_form.submit();
            }
            else
                alert(errString);
        }

    </script>
</head>
<body>
<form ENCTYPE="multipart/form-data" name="the_form" method="post" action="">

    <table>
        <tr>
            <td>Expense Purpose</td>
            <td>
                <input type="text" name="expense_purpose" maxlength="50"/>
            </td>
        </tr>
        <tr>
            <td>Expense Type</td>
            <td>
                <select name="expense_type">
                    <option value="0">Select</option>
                    <%
                        Session theSession = null;
                        try {
                            theSession = HibernateUtil.openSession();

                            String strQuery = "from TExpenseTypes where IsActive = 1 order by Expense_Type_ID";
                            Query query = theSession.createQuery(strQuery);
                            List expense_types = query.list();

                            for (int nIndex = 0; nIndex < expense_types.size(); nIndex++) {
                                TExpenseTypes oneExpenseType = (TExpenseTypes) expense_types.get(nIndex);
                    %>
                    <option value="<%=oneExpenseType.getId()%>"><%=oneExpenseType.getExpenseType()%>
                    </option>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            HibernateUtil.closeSession(theSession);
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td align="right">Expense Date:</td>
            <td align="left">
                <select name="the_year" onchange="update_days()">
                    <option value="<%=cal.get(Calendar.YEAR)%>"><%=cal.get(Calendar.YEAR)%>
                    </option>
                    <%
                        cal = Calendar.getInstance();
                        int nCurrentMonth = cal.get(Calendar.MONTH);
                        int nCurrentDay = cal.get(Calendar.DAY_OF_MONTH);

                        if (nCurrentMonth == 0) {
                            int nPreviousYear = cal.get(Calendar.YEAR);
                            nPreviousYear--;
                    %>
                    <option value="<%=nPreviousYear%>"><%=nPreviousYear%>
                    </option>
                    <%
                        }
                    %>
                </select>
                <select name="the_month" onchange="update_days()">
                    <option value="<%=nCurrentMonth%>"><%=months[nCurrentMonth]%>
                    </option>
                    <%
                        if (nCurrentMonth == 0) {
                            nCurrentMonth = 11;
                    %>
                    <option value="<%=nCurrentMonth%>"><%=months[nCurrentMonth]%>
                    </option>
                    <%
                    } else {
                        nCurrentMonth--;
                    %>
                    <option value="<%=nCurrentMonth%>"><%=months[nCurrentMonth]%>
                    </option>
                    <%
                        }
                    %>
                </select>
                <select name="the_day" id="the_day_id">
                    <%
                        for (int i = nCurrentDay; i > 0; i--) {
                    %>
                    <option value="<%=i%>"><%=i%>
                    </option>

                    <%
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td>Expense Amount</td>
            <td>
                <input type="text" name="expense_amount" maxlength="7" size="7"/>
            </td>
        </tr>
        <tr>
            <td align="right">Receipt</td>
            <td align="left">
                <input type="file" name="file_to_upload">
            </td>
        </tr>
        <tr>
            <td>
                <input type="button" name="add_expense" OnClick="cofirmAddExpense()" value="Add Expense"/>
            </td>
        </tr>
    </table>
    <br>
    <a href="../MasterInformation.jsp"> Go to Main </a>
</form>
</body>
</html>