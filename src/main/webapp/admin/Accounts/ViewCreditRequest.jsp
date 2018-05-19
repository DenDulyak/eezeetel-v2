<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<%
    Session theSession = null;
    try {
        int nRequestID = 0;
        int nCustomerID = 0;
        String strRequestID = request.getParameter("request_id");
        if (strRequestID != null && !strRequestID.isEmpty())
            nRequestID = Integer.parseInt(strRequestID);

        theSession = HibernateUtil.openSession();

        String strQuery = "from TCreditRequests where Request_ID = " + nRequestID;
        Query query = theSession.createQuery(strQuery);
        List list = query.list();
        if (list.size() > 0) {
            TCreditRequests creditRequest = (TCreditRequests) list.get(0);
            TMasterCustomerinfo custInfo = creditRequest.getCustomer();
            Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
            if (custInfo.getGroup().getId().intValue() == nCustomerGroupID) {
                nCustomerID = custInfo.getId();

                String strStatus = "";
                switch (creditRequest.getRequestStatus()) {
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
                String strAmountDeposited = "NO";
                if (creditRequest.getAmountAlreadyPaid() == 1)
                    strAmountDeposited = "YES";
                User requesterInfo = creditRequest.getUser();
                String strRequestType = "TOPUP";
                if (creditRequest.getRequestType() == 2)
                    strRequestType = "PAY DUES";

                String strPaymentType = " ";
                switch (creditRequest.getPaymentType()) {
                    case 1:
                        strPaymentType = "Cash";
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

                String strPaymentDate = " ";
                if (creditRequest.getPaymentDate() != null)
                    strPaymentDate = creditRequest.getPaymentDate().toString();

                TMasterBanks theBank = creditRequest.getBank();
%>

<!DOCTYPE html>
<html>
<head>
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>
        function initialLoad(customer_id) {
            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Cannot get cusomter credit details");
                return;
            }

            var element = document.getElementById('credit_info');
            element.innerHTML = "";

            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    element.innerHTML = httpObj.responseText;
                }
            };

            var url = "/admin/Accounts/AJAX_GetCreditInfo.jsp?customer_id=" + customer_id;
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }

        function UpdateDebit(credit_id) {
            if (!CheckNumbers(credit_id)) {
                alert("Not a valid credit ID");
                return;
            }

            var answer = confirm("Are you sure you want to update the debit to credit?");
            if (answer) {
                var httpObj = getHttpObject();
                if (httpObj == null) {
                    alert("Cannot contact server.");
                    return;
                }

                var element = document.getElementById('credit_info');
                element.innerHTML = "";

                httpObj.onreadystatechange = function () {
                    if (httpObj.readyState == 4) {
                        element.innerHTML = httpObj.responseText;
                    }
                };

                var url = "/admin/Accounts/AJAX_UpdateThisDebit.jsp?credit_id=" + credit_id + "&customer_id=" + document.the_form.customer_id.value;
                httpObj.open("POST", url, true);
                httpObj.send(null);
            }
        }

        function submit_request(submit_case) {
            if (submit_case == 2) {
                if (eval(document.the_form.approved_amount.value) <= eval(0)) {
                    alert("Approved amount is not a correct value.  Please correct it.");
                    return 1;
                }

                if (document.the_form.amount_deposited.value == 1) {
                    if (!confirm("Are you sure you don't want to ADJUST to any previous DEBTs?"))
                        return 1;
                } else {
                    if (!confirm("Are you sure you want to approve FULL amount?"))
                        return 1;
                }

                if (eval(document.the_form.approved_amount.value) != eval(document.the_form.requested_amount.value)) {
                    alert("For full amount approval, approved amount must be equal to requested amount.  Please correct it");
                    return 1;
                }
            } else if (submit_case == 3) {
                if (eval(document.the_form.approved_amount.value) < eval(0)) {
                    alert("Approved amount is not a correct value.  Please correct it.");
                    return 1;
                }

                if (eval(document.the_form.approved_amount.value) >= eval(document.the_form.requested_amount.value)) {
                    alert("For partial amount approval, approved amount must be less than requested amount.  Please correct it");
                    return 1;
                }
            } else if (submit_case == 5) {
                if (IsNULL(document.the_form.approver_comments.value)) {
                    alert("Please enter comments and specify reason for rejection.");
                    return;
                }
            }

            if (document.the_form.amount_deposited.value == 1) {
                if (document.the_form.collected_by.value == "Pending") {
                    alert("Please select who collected the amount or who verified the bank payment.");
                    return;
                }
            }

            CheckDatabaseChars(document.the_form.approver_comments);

            document.the_form.action = "/admin/Accounts/ProcessCreditRequest.jsp?action_case=" + submit_case + "&credit_request_id=" + <%=creditRequest.getId()%>;
            document.the_form.submit();
        }

        function update_payment_amount() {
            var payment_amount = 0;

            if (!document.the_form.credit_id.length || document.the_form.credit_id.length == 1) {
                if (document.the_form.credit_id.checked == true) {
                    var x = document.getElementById(document.the_form.credit_id.value);
                    payment_amount = eval(payment_amount) + eval(x.value);
                }
            } else {
                for (i = 0; i < document.the_form.credit_id.length; i++) {
                    if (document.the_form.credit_id[i].checked == true) {
                        var x = document.getElementById(document.the_form.credit_id[i].value);
                        payment_amount = eval(payment_amount) + eval(x.value);
                    }
                }
            }

            document.the_form.due_amount.value = payment_amount;
            document.the_form.approved_amount.value = eval(document.the_form.paid_amount.value) - eval(payment_amount);
        }

    </script>
    <meta charset="UTF-8">
    <title>Customer Credit Summary</title>
</head>
<body onLoad="initialLoad(<%=nCustomerID%>)">
<form name="the_form" method="post" action="">
    <a href="${pageContext.request.contextPath}/admin"> Admin Main </a>
    <input type="hidden" name="customer_id" value="<%=creditRequest.getCustomer().getId()%>">

    <h2> Customer History </h2>

    <div id="credit_info"></div>

    <br>
    <br>
    <br>

    <table border="1">

        <tr>
            <td align="right">
                Request ID:
            </td>
            <td align="left">
                <%=creditRequest.getId()%>
            </td>
        </tr>
        <tr>
            <td align="right">
                Request Type:
            </td>
            <td align="left">
                <%=strRequestType%>
                <input type="hidden" name="request_type" value="<%=creditRequest.getRequestType()%>"/>
            </td>
        </tr>
        <tr>
            <td align="right">
                Request Status:
            </td>
            <td align="left">
                <%=strStatus%>
            </td>
        </tr>
        <tr>
            <td align="right">
                Request Date:
            </td>
            <td align="left">
                <%=creditRequest.getRequestDate().toString()%>
            </td>
        </tr>
        <tr>
            <td align="right">
                Amount Already Paid:
            </td>
            <td align="left">
                <input type="hidden" name="amount_deposited" value="<%=creditRequest.getAmountAlreadyPaid()%>"/>
                <font color="blue"><%=strAmountDeposited%>
                </font>
            </td>
        </tr>
        <tr>
            <td align="right">
                <font color="blue">Amount Requested:</font>
            </td>
            <td align="left">
                <input type="text" readonly name="requested_amount" size="5" maxlength="4"
                       value="<%=creditRequest.getRequestAmount()%>"
                       style="width:100px; height:40px;font-size:28px;color:blue">
            </td>
        </tr>
        <tr>
            <td align="right">
                Requester Name:
            </td>
            <td align="left">
                <%=requesterInfo.getUserFirstName() + " " + requesterInfo.getUserLastName()%>
            </td>
        </tr>
        <tr>
            <td align="right">
                Request Details:
            </td>
            <td align="left">
                <%=creditRequest.getRequestDetails()%>
            </td>
        </tr>
        <tr>
            <td align="right">
                Payment Type:
            </td>
            <td align="left">
                <%=strPaymentType%>
            </td>
        </tr>
        <tr>
            <td align="right">
                Bank Name:
            </td>
            <td align="left">
                <%=theBank.getBankName()%>
            </td>
        </tr>
        <tr>
            <td align="right">
                Payment Date:
            </td>
            <td align="left">
                <%=strPaymentDate%>
            </td>
        </tr>
        <tr>
            <td align="right">
                <font color="red">Approver Comments:</font>
            </td>
            <%
                if (creditRequest.getRequestStatus() == 1) {
            %>
            <td align="left">
                <input type="text" name="approver_comments" size="50" maxlength="100"
                       value="<%=creditRequest.getApproverComments()%>">
            </td>
            <%
            } else {
            %>
            <td align="left"><%=creditRequest.getApproverComments()%>
            </td>
            <%
                }
            %>
        </tr>
        <tr>
            <td align="right">
                <font color="red">Amount Collected By:</font>
            </td>
            <td align="left">
                <%
                    if (creditRequest.getRequestStatus() == 1) {
                %>
                <select name="collected_by">
                    <%
                        strQuery = "from User where User_Active_Status = 1 AND Customer_Group_ID = " + nCustomerGroupID +
                                " and (User_Type_And_Privilege = 4 OR User_Type_And_Privilege = 5 OR User_Login_ID = '" + request.getRemoteUser() + "'" +
                                " OR User_Login_ID = 'Pending')  order by User_First_Name";

                        query = theSession.createQuery(strQuery);
                        list = query.list();
                        for (int i = 0; i < list.size(); i++) {
                            User theUser = (User) list.get(i);
                            String strSelected = "";
                            if (theUser.getLogin().compareToIgnoreCase("Pending") == 0)
                                strSelected = "selected";

                            String isAgent = "";
                            if (theUser.getUserType().getId() == 6)
                                isAgent = " - AGENT";
                    %>

                    <option value="<%=theUser.getLogin()%>" <%=strSelected%>><%=theUser.getUserFirstName()%><%=isAgent%>
                    </option>
                    <%
                        }
                    %>
                </select>
                <%
                } else {
                %>
                <%=creditRequest.getApprovedBy()%>
                <%
                    }
                %>
            </td>
        </tr>

        <%
            if (creditRequest.getRequestStatus() == 1) {
                if (creditRequest.getAmountAlreadyPaid() == 1) {
                    Calendar cal = Calendar.getInstance();
                    cal.add(Calendar.MONTH, -6);
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    String strCurTime = sdf.format(cal.getTime());
                    strQuery = "from TMasterCustomerCredit where Customer_ID = " + nCustomerID + " and Entered_Time > '" +
                            strCurTime + "' and Credit_Or_Debit = 2 order by Entered_Time";
                    query = theSession.createQuery(strQuery);
                    List previousDebits = query.list();
                    float fTotalPreviousDebt = 0.0f;
                    for (int i = 0; i < previousDebits.size(); i++) {
                        TMasterCustomerCredit theDebit = (TMasterCustomerCredit) previousDebits.get(i);
                        fTotalPreviousDebt += theDebit.getPaymentAmount();
        %>

        <tr>
            <td align="right">
                <%=theDebit.getId()%>
                &nbsp;&nbsp; - &nbsp;&nbsp;<%=theDebit.getEnteredTime()%>
            </td>
            <td>
                <%=theDebit.getPaymentAmount()%>
                <input type="checkbox" checked name="credit_id" value="<%=theDebit.getId()%>"
                       onclick="update_payment_amount()">
                <input type="hidden" id="<%=theDebit.getId()%>" value="<%=theDebit.getPaymentAmount()%>">
            </td>
        </tr>
        <%
            }
        %>
        <tr>
            <td align="right"><font color="red">Total Amount Due</font></td>
            <td><input readonly name="due_amount" type="text" size="4" value="<%=fTotalPreviousDebt%>"
                       style="width:100px; height:40px;font-size:28px;color:red"></td>
            <input readonly name="paid_amount" type="hidden" size="4" value="<%=creditRequest.getRequestAmount()%>">
        </tr>

        <tr>
            <td><font color="red"><b>Amount after adjusting to previous debt</b></font></td>
            <td><input readonly type="text" size="4" name="approved_amount"
                       value="<%=creditRequest.getRequestAmount() - fTotalPreviousDebt%>"
                       style="width:100px; height:40px;font-size:28px;font-weight:bold;color:red;background-color:yellow;">
            </td>
        </tr>
        <%
        } else {
        %>
        <tr>
            <td align="right">
                <b><font color="red">Approved Amount:</font></b>
            </td>
            <td align="left">
                <input type="text" name="approved_amount" size="5" maxlength="4"
                       value="<%=creditRequest.getRequestAmount()%>"
                       style="width:100px; height:40px;font-size:28px;font-weight:bold;color:red;background-color:yellow;">
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <td align="right">
            <b><font color="red">Approved Amount:</font></b>
        </td>

        <td align="left"
            style="width:100px; height:40px;font-size:28px;font-weight:bold;color:red;background-color:yellow;"><%=creditRequest.getApprovedAmount()%>
        </td>
        <%
            }
        %>
        <tr>
            <td align="right">
                Credit IDs:
            </td>
            <td align="left">
                <%=creditRequest.getCreditIdList()%>
            </td>
        </tr>
        <tr></tr>
        <tr></tr>

        <tr>

            <%
                String strDisabled = "disabled";
                if (creditRequest.getRequestStatus() == 1)
                    strDisabled = "";
            %>

            <td>
                <input type="button" <%=strDisabled%> name="Reject" value="Reject" OnClick="submit_request(5)">
            </td>

            <%
                strDisabled = "disabled";
                if (creditRequest.getRequestStatus() == 1)
                    strDisabled = "";
            %>

            <td>
                <input type="button" <%=strDisabled%> name="Approve_Full_Amount" value="Approve Full Amount"
                       OnClick="submit_request(2)">
                <input type="button" <%=strDisabled%> name="Approve_Partial_Amount" value="Approve Partial Amount"
                       OnClick="submit_request(3)">
            </td>
        </tr>
    </table>
    <a href="${pageContext.request.contextPath}/admin"> Admin Main </a>
</form>
<%
            } // end if (customer group comparison)
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
</body>
</html>

