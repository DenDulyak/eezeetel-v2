<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <script language="javascript" src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script language="javascript">
        function update_customer_credit_list() {
            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Can not get customer credit information");
                return;
            }

            var customerID = 0;
            if (document.the_form.customer_list != null)
                customerID = document.the_form.customer_list.value;
            var status = document.the_form.credit_status.value;


            httpObj.onreadystatechange = function () {
                if (httpObj.readyState == 4) {
                    var element = document.getElementById('customer_credit_info');
                    element.innerHTML = "";
                    element.innerHTML = httpObj.responseText;
                    ;
                }
            }

            var url = "AJAX_GetCustomerCredit.jsp?customer_id=" + customerID + "&credit_status=" + status;
            httpObj.open("POST", url, true);
            httpObj.send(null);
        }

        function ModifyCredit() {
            var action_page = "/masteradmin/ModifyCustomerCredit.jsp?credit_id=";

            if (document.the_form.record_id != null) {
                var nItems = document.the_form.record_id.length;
                if (nItems == null || nItems <= 0) {
                    if (document.the_form.record_id.checked) {
                        action_page += document.the_form.record_id.value;
                        document.the_form.action = action_page;
                        document.the_form.submit();
                        return 1;
                    }
                    else
                        alert("Please select a record to perform the operation.");
                }
                else {
                    for (var i = 0; i < document.the_form.record_id.length; i++)
                        if (document.the_form.record_id[i].checked) {
                            action_page += document.the_form.record_id[i].value;
                            document.the_form.action = action_page;
                            document.the_form.submit();
                            return 1;
                        }

                    alert("Please select a record to perform the operation.");
                }
            }
            else
                alert("No records available to perform the operation.");
        }

    </script>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>List, Modify, Customer Credit</title>
</head>
<body>
<form name="the_form" method="post" action="">

    <%
        String strStatus = request.getParameter("credit_status");
        int nStatus = -1;
        if (strStatus != null && !strStatus.isEmpty())
            nStatus = Integer.parseInt(strStatus);

        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();

    %>

    <table width="100%">
        <tr>
            <td align="right"> Customer :</td>
            <td>

                <select name="customer_list" id="customer_list_id" onchange="update_customer_credit_list()">
                    <option value="0">Select</option>
                    <%
                        String strQuery = "from TMasterCustomerinfo where Active_Status=1 order by Customer_Company_Name";
                        Query query = theSession.createQuery(strQuery);
                        List records = query.list();
                        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) records.get(nIndex);
                    %>
                    <option value="<%=custInfo.getId()%>"><%=custInfo.getCompanyName()%>
                        - <%=custInfo.getCustomerBalance()%>
                    </option>
                    <%
                        }
                    %>
                </select>

            </td>

            <td align="right"> Status :</td>
            <td>
                <select name="credit_status" onchange="update_customer_credit_list()">
                    <option value="-1">All</option>
                    <option value="0">Just Added (DEBIT)</option>
                    <option value="1">Pending Credit Update</option>
                    <option value="2">Processed Credit Update</option>
                </select>
            </td>

            <td align="center">
                <a href="MasterInformation.jsp"> Go to Main </a>
            </td>

            <td align="center">
                <input type="button" name="add_button" value="Add"
                       OnClick="SubmitForm('NewCustomerCredit.jsp', false);">
            </td>
        </tr>
    </table>

    <div id="customer_credit_info">
        <table border="1" width="100%">
            <tr bgcolor="#99CCFF">
                <td><h5>Credit ID</h5></td>
                <td><h5>Customer</h5></td>
                <td><h5>Payment Type</h5></td>
                <td><h5>Payment Details</h5></td>
                <td><h5>Payment Amount</h5></td>
                <td><h5>Payment Received Date</h5></td>
                <td><h5>Collected By</h5></td>
                <td><h5>Entered By</h5></td>
                <td><h5>Topup Date</h5></td>
                <td><h5>Credit OR Debit</h5></td>
                <td><h5>Notes</h5></td>
            </tr>

            <%
                strQuery = "from TMasterCustomerCredit where Entered_Time > '2011-01-01 00:00:00'";
                if (nStatus != -1) {
                    if (nStatus == 0)
                        strQuery += (" and Credit_or_Debit = 2 ");
                    else
                        strQuery += (" and Credit_ID_Status = " + nStatus);
                }
                strQuery += " order by Entered_Time desc";

                query = theSession.createQuery(strQuery);
                records = query.list();

                for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                    TMasterCustomerCredit custCredit = (TMasterCustomerCredit) records.get(nIndex);
                    TMasterCustomerinfo custInfo = custCredit.getCustomer();
                    User userCollectedBy = custCredit.getCollectedBy();
                    User userEnteredBy = custCredit.getEnteredBy();

                    String strPaymentType = "Not Paid Yet";
                    switch (custCredit.getPaymentType()) {
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
                        case 5:
                            strPaymentType = "Debit/Credit Card";
                            break;
                    }

                    String strCreditOrDebit = "DEBIT";
                    if (custCredit.getCreditOrDebit() == 1) strCreditOrDebit = "Credit";
            %>
            <tr>
                <td align="right">
                    <a href="/masteradmin/ModifyCustomerCredit.jsp?credit_id=<%=custCredit.getId()%>"><%=custCredit.getId()%>
                    </a>
                    <input type="hidden" name="record_id" value="<%=custCredit.getId()%>">
                </td>

                <td align="left"><%=custInfo.getCompanyName()%>
                </td>
                <td align="left"><%=strPaymentType%>
                </td>
                <td align="left"><%=custCredit.getPaymentDetails()%>
                </td>
                <td align="left"><%=custCredit.getPaymentAmount()%>
                </td>
                <td align="left"><%=custCredit.getPaymentDate()%>
                </td>
                <td align="left"><%=userCollectedBy.getUserFirstName()%>
                </td>
                <td align="left"><%=userEnteredBy.getUserFirstName()%>
                </td>
                <td align="left"><%=custCredit.getEnteredTime()%>
                </td>
                <td align="left"><%=strCreditOrDebit%>
                </td>
                <td align="left"><%=custCredit.getNotes()%>
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
            <tr>
                <td></td>
            </tr>
        </table>
    </div>
</form>
</body>
</html>