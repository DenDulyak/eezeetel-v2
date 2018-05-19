<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Day Transaction</title>
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>
        function update_customer_daily_transaction() {
            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Cannot get cusomter daily transaction");
                return;
            }

            var element = document.getElementById('customer_daily_transaction');
            element.innerHTML = "";

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    element.innerHTML = httpObj.responseText;
                }
            };

            var url = "/admin/Reports/AJAX_GetCustomerDailySummary.jsp?customer_id=" +
                    document.the_form.customer_id.value +
                    "&year=" + document.the_form.the_year.value +
                    "&month=" + document.the_form.the_month.value +
                    "&day=" + document.the_form.the_day.value;
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }

        <%
        Calendar cal = Calendar.getInstance();
        %>

        var nCurrentYear = <%=cal.get(Calendar.YEAR)%>;
        var nCurrentMonth = <%=cal.get(Calendar.MONTH)%>;
        var nCurrentDay = <%=cal.get(Calendar.DAY_OF_MONTH)%>;
        var nCurrentHour = <%=cal.get(Calendar.HOUR_OF_DAY)%>;

        function daysInMonth(month, year) {
            month = eval(month) + 1;
            var d = new Date(year, month, 0).getDate();
            return d;
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
    </script>
</head>
<%
    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();

        Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
%>
<body>
<form name="the_form" method="post" action="">
    <table>
        <tr>
            <td align="left">Customer:</td>
            <td align="left">
                <select name="customer_id">
                    <option value="0">Select</option>
                    <%
                        String strQuery = "from TMasterCustomerinfo where Customer_Group_ID = " + nCustomerGroupID + " and Active_Status = 1 order by Customer_Company_Name";
                        Query query = theSession.createQuery(strQuery);
                        List records = query.list();
                        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) records.get(nIndex);
                    %>
                    <option value="<%=custInfo.getId()%>"><%=custInfo.getCompanyName()%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
            <%
                cal = Calendar.getInstance();
                int nCurrentMonth = cal.get(Calendar.MONTH);
                int nCurrentDay = cal.get(Calendar.DAY_OF_MONTH);

                if (nCurrentMonth <= 4) {
                    int nPreviousYear = cal.get(Calendar.YEAR);
                    nPreviousYear--;
                }
                int nCurrentYear = cal.get(Calendar.YEAR);
                int startYear = 2014;
                String[] months = {"January", "February",
                        "March", "April", "May", "June", "July",
                        "August", "September", "October", "November",
                        "December"};
            %>
            <td>Year</td>
            <td align="left">
                <select name="the_year" onchange="update_days()">
                    <%
                        for (int i = nCurrentYear; i >= startYear; i--) {
                    %>
                    <option value="<%=i%>"><%=i%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
            <td>Month</td>
            <td>
                <select name="the_month" onchange="update_days()">
                    <%
                        for (int i = 11; i >= 0; i--) {
                    %>
                    <option value="<%=i%>"><%=months[i]%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
            <td>Day</td>
            <td>
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
            <td><input type="button" name="generate_button" value="Generate"
                       onClick="update_customer_daily_transaction()"></td>
            <td><a href="${pageContext.request.contextPath}/admin"> Admin Main </a></td>
        </tr>
    </table>
    <div id="customer_daily_transaction"></div>
</form>
</body>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
</html>