<%@ page import="com.eezeetel.service.CustomerCreditService" %>
<%@ page import="org.springframework.data.domain.Page" %>
<%@ page import="org.springframework.data.domain.PageRequest" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
    CustomerCreditService customerCreditService = context.getBean(CustomerCreditService.class);

    String strCustomerID = request.getParameter("customer_id");
    int nCustomerID = 0;
    if (strCustomerID != null && !strCustomerID.isEmpty())
        nCustomerID = Integer.parseInt(strCustomerID);

    String strStatus = request.getParameter("credit_status");
    int nStatus = 0;
    if (strStatus != null && !strStatus.isEmpty())
        nStatus = Integer.parseInt(strStatus);

    int pageNumber = 0;
    String pageStr = request.getParameter("page");
    if (pageStr != null && !pageStr.isEmpty()) {
        pageNumber = Integer.parseInt(pageStr);
        pageNumber--;
    }


    try {
        Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.YEAR, 2011);
        calendar.set(Calendar.DAY_OF_YEAR, 1);

        Page<TMasterCustomerCredit> customerCredits = customerCreditService.findByGroupAndEnteredTime(nCustomerGroupID, nCustomerID, calendar.getTime(), nStatus, new PageRequest(pageNumber, 100));
        List records = customerCredits.getContent();

        String strResult = "<table class='table table-bordered'" +
                "<tr>" +
                "<th>Credit ID</th>" +
                "<th>Customer</th>" +
                "<th>Payment Type</th>" +
                "<th>Payment Details</th>" +
                "<th>Payment Amount</th>" +
                "<th>Payment Received Date</th>" +
                "<th>Collected By</th>" +
                "<th>Entered By</th>" +
                "<th>Topup Date</th>" +
                "<th>Credit OR Debit</th>" +
                "<th>Notes</th>" +
                "</tr>";

        float fTotalAmountSoFar = 0.0f;
        boolean bDone = false;

        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
            TMasterCustomerCredit custCredit = (TMasterCustomerCredit) records.get(nIndex);
            TMasterCustomerinfo custInfo = custCredit.getCustomer();
            User userCollectedBy = custCredit.getCollectedBy();
            User userEnteredBy = custCredit.getEnteredBy();

            if (custInfo.getGroup().getId().intValue() == nCustomerGroupID) {
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

                String strCreditOrDebit = "DEBIT";
                String strBgColor = "danger";
                if (custCredit.getCreditOrDebit() == 1) {
                    strCreditOrDebit = "Credit";
                    strBgColor = "";
                }

                String tr = "";

                tr += ("<tr class='" + strBgColor + "'><td align=\"right\">" +
                        "<a href=\"/admin/Accounts/ModifyCustomerCredit.jsp?credit_id=" + custCredit.getId() + "\">" + custCredit.getId() + "</a>" +
                        "</td>	<td align=\"left\">" + custInfo.getCompanyName() + "</td>" +
                        "<td align=\"left\">" + strPaymentType + "</td>" +
                        "<td align=\"left\">" + custCredit.getPaymentDetails() + "</td>" +
                        "<td align=\"left\">" + custCredit.getPaymentAmount() + "</td>" +
                        "<td align=\"left\">" + custCredit.getPaymentDate() + "</td>" +
                        "<td align=\"left\">" + userCollectedBy.getUserFirstName() + "</td>" +
                        "<td align=\"left\">" + userEnteredBy.getUserFirstName() + "</td>" +
                        "<td align=\"left\">" + custCredit.getEnteredTime() + "</td>" +
                        "<td align=\"left\">" + strCreditOrDebit + "</td>" +
                        "<td align=\"left\">" + custCredit.getNotes() + "</td>" + "</tr>");

                fTotalAmountSoFar += custCredit.getPaymentAmount();
                if (fTotalAmountSoFar > custInfo.getCustomerBalance() && bDone == false && nCustomerID > 0) {
                    bDone = true;
                }

                strResult += tr;
            }
        }

        strResult += "</table>";

        int begin = Math.max(1, customerCredits.getNumber() - 5);
        long end = Math.min(begin + 10, Math.max(1, customerCredits.getTotalElements() / 100));

        String pagination = "<ul class='pagination'>";
        for (int i = begin; i <= end; i++) {
            pagination += "<li class='";
            if ((pageNumber + 1) == i) {
                pagination += "active";
            }
            pagination += "'><a onclick='update_customer_credit_list(" + i + ")'>" + i + "</a>";
            pagination += "</li>";
        }
        pagination += "</ul>";

        strResult += pagination;

        response.setContentType("text/html");
        response.getWriter().println(strResult);
    } catch (Exception e) {
        e.printStackTrace();
        String strResult = "No records found";
        response.setContentType("text/plain");
        response.getWriter().println(strResult);
    }
%>
