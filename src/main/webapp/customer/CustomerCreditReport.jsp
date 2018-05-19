<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer.css"/>
    <c:import url="../common/libs.jsp"/>

    <style>
        td {
            padding: 0px 2px !important;
        }
    </style>
</head>
<body>
<c:import url="headerNavbar.jsp"/>

<div class="container">
    <%
        Session theSession = null;

        try {
            int nCustomerID = 0;
            String strQuery = "from TCustomerUsers where User_Login_ID = '" + request.getRemoteUser() + "'";
            theSession = HibernateUtil.openSession();
            Query query = theSession.createQuery(strQuery);

            List customer = query.list();
            if (customer.size() > 0) {
                TCustomerUsers custUsers = (TCustomerUsers) customer.get(0);
                TMasterCustomerinfo theCustomer = custUsers.getCustomer();
                User theUser = custUsers.getUser();
                if (theCustomer.getActive() && theUser.getUserActiveStatus())
                    nCustomerID = theCustomer.getId();
            }

            if (nCustomerID == 0) {
                response.setContentType("text/plain");
                response.getWriter().println("");
                return;
            }

            strQuery = "from TMasterCustomerCredit";
            if (nCustomerID > 0)
                strQuery += " where Entered_Time >= '2012-01-01' and Customer_ID = " + nCustomerID + " order by Credit_or_Debit desc, Payment_Date desc, Entered_Time desc";
            query = theSession.createQuery(strQuery);
            List records = query.list();

            String strResult = "<table class='table table-striped table-bordered'>" +
                    "<thead>" +
                    "<tr bgcolor='#99CCFF'>" +
                    "<th>Credit ID</th>" +
                    "<th>Customer</th>" +
                    "<th>Payment Type</th>" +
                    "<th>Payment Details</th>" +
                    "<th>Payment Amount</th>" +
                    "<th>Payment Received Date</th>" +
                    "<th>Topup Date</th>" +
                    "<th>Credit OR Debit</th>" +
                    "</tr>" +
                    "</thead>";

            float fOutstandingBalance = 0.0f;
            boolean bDone = false;

            for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                TMasterCustomerCredit custCredit = (TMasterCustomerCredit) records.get(nIndex);
                TMasterCustomerinfo custInfo = custCredit.getCustomer();

                String strPaymentType = "Not Paid";
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

                String strPaymentDate = "Not Paid/Credited Yet";

                Date dtPayment = custCredit.getPaymentDate();
                if (dtPayment != null)
                    strPaymentDate = dtPayment.toString();

                String strCreditOrDebit = "DEBIT";
                String strBgColor = "danger";
                if (custCredit.getCreditOrDebit() == 1) {
                    strCreditOrDebit = "Credit";
                    strBgColor = "";
                    fOutstandingBalance += custCredit.getPaymentAmount();
                } else
                    fOutstandingBalance -= custCredit.getPaymentAmount();

                String strPaymentDetails = custCredit.getPaymentDetails();
                if (strPaymentDetails == null || strPaymentDetails.isEmpty())
                    strPaymentDetails = "";

                strResult += ("<tr class=\"" + strBgColor + "\">" +
                        "<td>" + custCredit.getId() + "</td>" +
                        "<td>" + custInfo.getCompanyName() + "</td>" +
                        "<td>" + strPaymentType + "</td>" +
                        "<td>" + strPaymentDetails + "</td>" +
                        "<td>" + custCredit.getPaymentAmount() + "</td>" +
                        "<td>" + strPaymentDate + "</td>" +
                        "<td>" + custCredit.getEnteredTime() + "</td>" +
                        "<td>" + strCreditOrDebit + "</td>" +
                        "</tr>");
            }

            strResult += "</table>";
    %>
    <%=strResult%>
    <%
    } catch (Exception e) {
        String strResult = "No records found";
        e.printStackTrace();
    %>
    <%=strResult%>
    <%
        } finally {
            HibernateUtil.closeSession(theSession);
        }
    %>

    <br>
    <a href="${pageContext.request.contextPath}/customer/products">Show Products</a>
</div>
</body>
</html>
