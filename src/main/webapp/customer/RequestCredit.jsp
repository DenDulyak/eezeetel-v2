<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer.css"/>
    <c:import url="../common/libs.jsp"/>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Credit Requests</title>
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>

        <%
        response.addHeader("Pragma", "no-cache");
        response.addHeader("Expires", "-1");

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

        function requestCredit() {
            var errString = "";

            if (!CheckNumbers(document.the_form.request_amount.value, ""))
                errString += "\r\Please enter a proper whole amount";

            if (document.the_form.request_amount.value < 50)
                errString += "\r\The minimum amount can be requested is 50";

            if (document.the_form.request_amount.value > 500)
                errString += "\r\The maximum amount can be requested is 500";

            if (!IsNULL(document.the_form.request_details.value)
                    && !CheckSpecialCharacters(document.the_form.request_details.value, " ."))
                errString += "\r\Request details must have only characters and numbers.  Please enter proper request details";
            CheckDatabaseChars(document.the_form.request_details);

            if (document.the_form.amount_deposited.value == 1 && IsNULL(document.the_form.request_details.value))
                errString += "If amount is already paid ... \r\n\r\n for cash payment - enter to whom and when you have paid \r\n for cheque payment - enter cheque number \r\n for bank payment - enter branch name and reference number\r\n\r\n If the details are missing the request may be rejected.";

            var systemDate = new Date(nCurrentYear, nCurrentMonth, nCurrentDay, nCurrentHour, 0, 0);
            var selectedDate = new Date(document.the_form.the_year.value, document.the_form.the_month.value,
                    document.the_form.the_day.value, document.the_form.the_hour.value, 0, 0);
            var difference = systemDate - selectedDate;
            difference = Math.round(difference / 1000 * 60 * 60);

            if (document.the_form.amount_deposited.value == 1)
                if (difference < 0)
                    errString += "\r\nPayment Date is in future time.  Please select a correct payment date and approximate time";

            if (errString == null || errString.length <= 0) {
                if (!confirm("Submit Topup Request for " + document.the_form.request_amount.value))
                    return;

                if (document.the_form.amount_paid[0].checked == false) {
                    document.the_form.request_details.value = "Will pay today";
                    if (document.the_form.amount_paid[2].checked == true)
                        document.the_form.request_details.value = "Will pay tomorrow";
                }

                document.the_form.action = "/customer/SubmitCreditRequest.jsp";
                document.the_form.submit();
            }
            else
                alert(errString);
        }

        function amountpaid() {
            if (document.the_form.amount_paid[0].checked == true) {
                document.the_form.amount_deposited.value = 1;
            }
            else {
                document.the_form.amount_deposited.value = 0;
            }

            var paymentTypeObj = document.getElementById("payment_type_id");

            if (document.the_form.amount_deposited.value == 1) {
                for (var i = 0; i < paymentTypeObj.length; i++)
                    if (paymentTypeObj.options[i].value == 0)
                        paymentTypeObj.remove(i);
                document.the_form.payment_type.disabled = false;
                document.the_form.payment_type.value = 3;
                payment_type_changed();
                document.the_form.the_year.disabled = false;
                document.the_form.the_month.disabled = false;
                document.the_form.the_day.disabled = false;
                document.the_form.the_hour.disabled = false;
            }
            else {
                var elOption = document.createElement('option');
                elOption.value = "0";
                elOption.innerHTML = "Select";
                elOption.selected = true;
                paymentTypeObj.appendChild(elOption);

                document.the_form.payment_type.disabled = true;
                document.the_form.bank_name.disabled = true;
                document.the_form.payment_type.value = 0;
                document.the_form.bank_name.value = 0;

                document.the_form.the_year.disabled = true;
                document.the_form.the_month.disabled = true;
                document.the_form.the_day.disabled = true;
                document.the_form.the_hour.disabled = true;
            }
        }

        function payment_type_changed() {
            if (document.the_form.payment_type.value == 1 || document.the_form.payment_type.value == 2) // cash/cheque payment
            {
                document.the_form.bank_name.disabled = true;
                return;
            }
            else if (document.the_form.payment_type.value == 3 || document.the_form.payment_type.value == 4) {
                document.the_form.bank_name.disabled = false;
                var paymentTypeObj = document.getElementById("payment_type_id");
                document.the_form.bank_name[0].selected = true;
            }
        }

        function initialLoad() {
            document.the_form.the_hour.value = nCurrentHour;
        }

    </script>
</head>
<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Expires", "-1");

    Session theSession = null;
    int nCustomerID = 0;
    boolean bNoMoreSubmission = false;
    int nCustomerGroupID = 0;
    try {
        theSession = HibernateUtil.openSession();
        String strUserId = (String) request.getRemoteUser();
        String strCompanyName = "";
        List creditRequests = null;

        if (!strUserId.isEmpty()) {
            // get customer id

            String strQuery = "from TCustomerUsers where User_Login_ID = '" + request.getRemoteUser() + "'";
            Query query = theSession.createQuery(strQuery);
            List customer = query.list();
            if (customer.size() > 0) {
                TCustomerUsers custUsers = (TCustomerUsers) customer.get(0);
                TMasterCustomerinfo theCustomer = custUsers.getCustomer();
                User theUser = custUsers.getUser();
                if (theCustomer.getActive() && theUser.getUserActiveStatus()) {
                    nCustomerID = theCustomer.getId();
                    nCustomerGroupID = theCustomer.getGroup().getId();
                }
            }

            cal = Calendar.getInstance();
            cal.add(Calendar.DAY_OF_MONTH, -30);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String strCurTime = sdf.format(cal.getTime());

            if (nCustomerID > 0) {
                strQuery = "from TCreditRequests where Request_Date > '" + strCurTime + "'" +
                        " and (Request_Status = 1 OR Request_Status = 4) " +
                        " and Customer_ID = " + nCustomerID + " order by Request_ID desc";
                query = theSession.createQuery(strQuery);

                creditRequests = query.list();
                if (creditRequests.size() > 0)
                    bNoMoreSubmission = true;

                strQuery = "from TCreditRequests where Request_Date > '" + strCurTime + "'" +
                        " and Customer_ID = " + nCustomerID + " order by Request_ID desc";
                query = theSession.createQuery(strQuery);
                creditRequests = query.list();
            }
        }
%>
<body onLoad="initialLoad()">
<c:import url="headerNavbar.jsp"/>
<a href="/customer/products">Show Products</a>
<hr>
<form method="post" name="the_form">
    <table>
        <%
            if (!bNoMoreSubmission) {
        %>
        <tr>
            <td align="right">
                Amount:
            </td>
            <td align="left">
                <input type="text" name="request_amount" size="5" maxlength="4">
            </td>
        </tr>
        <tr>
            <td align="right">
                Amount Paid:
            </td>
            <td align="left">
                <input type="radio" name="amount_paid" value="1" onclick="amountpaid()">
                <input type="hidden" name="amount_deposited" onclick="amountpaid()">
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Will Pay Today:
                <input type="radio" name="amount_paid" value="2" checked onclick="amountpaid()">
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Will Pay Tomorrow:
                <input type="radio" name="amount_paid" value="3" onclick="amountpaid()">
            </td>
        </tr>
        <tr>
            <td align="right">
                Payment Type:
            </td>
            <td align="left">
                <select disabled id="payment_type_id" name="payment_type" onchange="payment_type_changed()"
                        onblur="payment_type_changed()">
                    <option value="0" selected>Select</option>
                    <option value="1">Cash</option>
                    <option value="3">Bank Deposit</option>
                    <option value="4">Funds Transfer</option>
                </select>
                <select disabled name="bank_name">
                    <%
                        String strQuery = "from TMasterBanks where Active_Bank = 1 and Customer_Group_ID = " + nCustomerGroupID;
                        Query query = theSession.createQuery(strQuery);
                        List banks = query.list();
                        for (int i = 0; i < banks.size(); i++) {
                            TMasterBanks bankInfo = (TMasterBanks) banks.get(i);
                            if (bankInfo.getBankName().isEmpty()) continue;

                            String strBankName = bankInfo.getBankName();
                            String strSortCode = bankInfo.getSortCode();
                            String strAccountNumber = bankInfo.getAccountNumber();

                            if (strSortCode != null && !strSortCode.isEmpty()) {
                                strBankName += (", Sort Code: " + strSortCode);

                                if (strAccountNumber != null && !strAccountNumber.isEmpty())
                                    strBankName += (", Account No: " + strAccountNumber);
                            }
                    %>
                    <option value="<%=bankInfo.getId()%>"><%=strBankName%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td align="right">
                Payment Details:
            </td>
            <td align="left">
                <input type="text" name="request_details" size="50" maxlength="100">(bank reference number etc.)
            </td>
        </tr>
        <tr>
            <td align="right">
                Payment Date:
            </td>
            <td align="left">
                <select disabled name="the_year" onchange="update_days()">
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
                <select disabled name="the_month" onchange="update_days()">
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
                <select disabled name="the_day" id="the_day_id">
                    <%
                        for (int i = nCurrentDay; i > 0; i--) {
                    %>
                    <option value="<%=i%>"><%=i%>
                    </option>

                    <%
                        }
                    %>
                </select>
                <select disabled name="the_hour" onchange="validate_hour()">
                    <option value="1">1 AM</option>
                    <option value="2">2 AM</option>
                    <option value="3">3 AM</option>
                    <option value="4">4 AM</option>
                    <option value="5">5 AM</option>
                    <option value="6">6 AM</option>
                    <option value="7">7 AM</option>
                    <option value="8">8 AM</option>
                    <option value="9">9 AM</option>
                    <option value="10">10 AM</option>
                    <option value="11">11 AM</option>
                    <option value="12">12 Noon</option>
                    <option value="13">1 PM</option>
                    <option value="14">2 PM</option>
                    <option value="15">3 PM</option>
                    <option value="16">4 PM</option>
                    <option value="17">5 PM</option>
                    <option value="18">6 PM</option>
                    <option value="19">7 PM</option>
                    <option value="20">8 PM</option>
                    <option value="21">9 PM</option>
                    <option value="22">10 PM</option>
                    <option value="23">11 PM</option>

                </select>
            </td>
        </tr>
        <tr>
            <td>
                <input type="button" name="request_credit" value="Submit Request" onClick="requestCredit()">
            </td>
        </tr>
        <%
        } else {
        %>
        <tr>
            <td><font color="red">You have submitted a request earlier and can not submit any more requests until the
                previous request is addressed </font></td>
        </tr>
        <%
            }
        %>
    </table>
    <br>
    <br>
    <table border="1">
        <tr>
            <td colspan="2">
                <H2>Requests with in last 30 days</H2>
            </td>
        </tr>
        <tr>
            <td>Request Status</td>
            <td>Request Type</td>
            <td>Request Time</td>
            <td>Amount</td>
            <td>Amount Already Paid</td>
            <td>Payment Type</td>
            <td>Bank</td>
            <td>Payment Date</td>
            <td>Requested By</td>
            <td>Request Details</td>
            <td>Approved Amount</td>
            <td>Action Time</td>
            <td>Approver Comments</td>
            <td>Credit IDs</td>
        </tr>
        <%
            for (int i = 0; creditRequests != null && i < creditRequests.size(); i++) {
                TCreditRequests oneRequest = (TCreditRequests) creditRequests.get(i);
                User requestedUser = oneRequest.getUser();
                String strPaid = "NO";
                if (oneRequest.getAmountAlreadyPaid() == 1)
                    strPaid = "YES";
                String strStatus = "Submitted";
                switch (oneRequest.getRequestStatus()) {
                    case 1:
                        strStatus = "Submitted";
                        break;
                    case 2:
                        strStatus = "Approved";
                        break;
                    case 3:
                        strStatus = "Partially Approved";
                        break;
                    case 4:
                        strStatus = "Pending Payment Verification";
                        break;
                    case 5:
                        strStatus = "Rejected";
                        break;
                    case 6:
                        strStatus = "Paid Dues";
                        break;
                }

                String strRequestType = "Topup Request";
                if (oneRequest.getRequestType() == 2)
                    strRequestType = "Pay Dues";

                String strApprovedAmount = " ";
                if (oneRequest.getApprovedAmount() != null)
                    strApprovedAmount = oneRequest.getApprovedAmount().toString();

                String strApprovedTime = " ";
                if (oneRequest.getApprovalDate() != null)
                    strApprovedTime = oneRequest.getApprovalDate().toString();

                String strApproverComments = " ";
                if (oneRequest.getApproverComments() != null)
                    strApproverComments = oneRequest.getApproverComments();

                String strPaymentDate = " ";
                if (oneRequest.getPaymentDate() != null)
                    strPaymentDate = oneRequest.getPaymentDate().toString();

                String strCreditIDList = " ";
                if (oneRequest.getCreditIdList() != null)
                    strCreditIDList = oneRequest.getCreditIdList();

                String strPaymentType = " ";
                switch (oneRequest.getPaymentType()) {
                    case 1:
                        strPaymentType = "Cheque";
                        break;
                    case 2:
                        strPaymentType = "Cheque";
                        break;
                    case 3:
                        strPaymentType = "Bank Deposit";
                        break;
                    case 4:
                        strPaymentType = "Funds Transfer";
                        break;
                }

                TMasterBanks theBank = oneRequest.getBank();
        %>
        <tr>
            <td><%=strStatus%>
            </td>
            <td><%=strRequestType%>
            </td>
            <td><%=oneRequest.getRequestDate()%>
            </td>
            <td><%=oneRequest.getRequestAmount()%>
            </td>
            <td><%=strPaid%>
            </td>
            <td><%=strPaymentType%>
            </td>
            <td><%=theBank.getBankName()%>
            </td>
            <td><%=strPaymentDate%>
            </td>
            <td><%=requestedUser.getUserFirstName() + " " + requestedUser.getUserLastName()%>
            </td>
            <td><%=oneRequest.getRequestDetails()%>
            </td>
            <td><%=strApprovedAmount%>
            </td>
            <td><%=strApprovedTime%>
            </td>
            <td><%=strApproverComments%>
            </td>
            <td><%=strCreditIDList%>
            </td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                HibernateUtil.closeSession(theSession);
            }
        %>
    </table>
    <input type="hidden" name="customer_id" value="<%=nCustomerID%>">
</form>
</body>
</html>