<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <script language="javascript" src="/GenericApp/Scripts/Validate.js"></script>
    <script language="javascript">

        function ChangeReportData() {
            document.the_form.action = "ManageCreditRequests.jsp?required_status=" + document.the_form.statusFilter.value;
            document.the_form.submit();
        }
    </script>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <meta http-equiv="refresh" content="300"/>
    <title>List, Modify, Customer Credit Requests</title>
</head>
<body>
<form name="the_form" method="post" action="">

    <%
        Session theSession = null;
        try {
            int nRequestStatus = 0;
            String strRequiredStatus = request.getParameter("required_status");
            if (strRequiredStatus == null || strRequiredStatus.isEmpty() || Integer.parseInt(strRequiredStatus) <= 0)
                strRequiredStatus = "";
            else {
                nRequestStatus = Integer.parseInt(strRequiredStatus);
                strRequiredStatus = " and Request_Status = " + nRequestStatus + " ";
            }

            theSession = HibernateUtil.openSession();

            Calendar now = Calendar.getInstance();
            now.add(Calendar.DAY_OF_MONTH, -7);

            SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
            String strRequestDate = sf.format(now.getTime());

            String strQuery = "from TCreditRequests where Request_Date > '" + strRequestDate + "'" +
                    strRequiredStatus + " order by Request_Status, Request_Date desc";
            Query query = theSession.createQuery(strQuery);
            List list = query.list();
    %>

    <select name="statusFilter" onchange="ChangeReportData()">
        <option value="-1">Select</option>
        <option value="0">All</option>
        <option value="1">Submitted</option>
        <option value="2">Approved</option>
        <option value="3">Partially Approved</option>
        <option value="5">Rejected</option>
    </select>

    <a href="MasterInformation.jsp"> Go to Main </a>

    <table width="100%" border="1">
        <tr>
            <th>
                Request ID
            </th>
            <th>
                Request Status
            </th>
            <th>
                Request Type
            </th>
            <th>
                Request Date
            </th>
            <th>
                Customer
            </th>
            <th>
                Customer Group
            </th>
            <th>
                Request Amount
            </th>
            <th>
                Amount Deposited
            </th>
            <th>
                Payment Type
            </th>
            <th>
                Bank Name
            </th>
            <th>
                Payment Date
            </th>
            <th>
                Requested By
            </th>
            <th>
                Request Details
            </th>
            <th>
                Action Date
            </th>
            <th>
                Approved Amount
            </th>
            <th>
                Approved By
            </th>
            <th>
                Approver Comments
            </th>
            <th>
                Credit IDs
            </th>
        </tr>
        <%
            for (int i = 0; i < list.size(); i++) {
                TCreditRequests creditRequest = (TCreditRequests) list.get(i);
                String strStatus = "";
                String strBgColor = "white";
                switch (creditRequest.getRequestStatus()) {
                    case 1:
                        strStatus = "Submitted";
                        strBgColor = "red";
                        break;
                    case 2:
                        strStatus = "Approved";
                        strBgColor = "green";
                        break;
                    case 3:
                        strStatus = "Partially Approved";
                        strBgColor = "blue";
                        break;
                    case 4:
                        strStatus = "Pending Payment Verification";
                        strBgColor = "blue";
                        break;
                    case 5:
                        strStatus = "Rejected";
                        strBgColor = "gray";
                        break;
                    case 6:
                        strStatus = "Paid Dues";
                        strBgColor = "green";
                        break;
                }

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

                TMasterCustomerinfo custInfo = creditRequest.getCustomer();
                String strAmountDeposited = "NO";
                if (creditRequest.getAmountAlreadyPaid() == 1)
                    strAmountDeposited = "YES";
                User requesterInfo = creditRequest.getUser();
                String approverInfo = creditRequest.getApprovedBy();
                Date dtApprovalDate = creditRequest.getApprovalDate();
                String strApprovalDate = "";
                if (dtApprovalDate != null)
                    strApprovalDate = dtApprovalDate.toString();
                String strRequestType = "TOPUP";
                if (creditRequest.getRequestType() == 2)
                    strRequestType = "PAY DUES";

                TMasterBanks theBank = creditRequest.getBank();
                String strGroupName = custInfo.getGroup().getName();
                String strGroupColor = "";
                if (custInfo.getGroup().getId() == 2)
                    strGroupColor = "yellow";
        %>
        <tr>
            <td>
                <a href="ViewCreditRequest.jsp?request_id=<%=creditRequest.getId()%>"><%=creditRequest.getId()%>
                </a>
            </td>
            <td bgcolor="<%=strBgColor%>">
                <%=strStatus%>
            </td>
            <td>
                <%=strRequestType%>
            </td>
            <td>
                <%=creditRequest.getRequestDate().toString()%>
            </td>
            <td>
                <a href="ViewCreditRequest.jsp?request_id=<%=creditRequest.getId()%>"><%=custInfo.getCompanyName()%>
                </a>
            </td>
            <td bgcolor="<%=strGroupColor%>">
                <%=strGroupName%>
            </td>
            <td>
                <%=creditRequest.getRequestAmount()%>
            </td>
            <td>
                <%=strAmountDeposited%>
            </td>
            <td>
                <%=strPaymentType%>
            </td>
            <td>
                <%=theBank.getBankName()%>
            </td>
            <td>
                <%=creditRequest.getPaymentDate()%>
            </td>
            <td>
                <%=requesterInfo.getUserFirstName() + " " + requesterInfo.getUserLastName()%>
            </td>
            <td>
                <%=creditRequest.getRequestDetails()%>
            </td>
            <td>
                <%=strApprovalDate%>
            </td>
            <td>
                <%=creditRequest.getApprovedAmount()%>
            </td>
            <td>
                <%=approverInfo%>
            </td>
            <td>
                <%=creditRequest.getApproverComments()%>
            </td>
            <td>
                <%=creditRequest.getCreditIdList()%>
            </td>
        </tr>
        <%
            }
        %>
        <tr>
            <td align="center">
                <a href="MasterInformation.jsp"> Go to Main </a>
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