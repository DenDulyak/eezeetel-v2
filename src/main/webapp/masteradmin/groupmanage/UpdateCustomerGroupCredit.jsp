<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="com.eezeetel.service.GroupCreditService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>

<%
    int nPaymentType = Integer.parseInt(request.getParameter("payment_type"));
    int nCreditOrDebit = Integer.parseInt(request.getParameter("credit_or_debit"));
    String strCollectedBy = request.getParameter("collected_by");
    int nCreditID = Integer.parseInt(request.getParameter("credit_id"));
    String strPaymentDetails = request.getParameter("payment_details");

    WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
    GroupCreditService groupCreditService = context.getBean(GroupCreditService.class);

    try {
        Calendar cal = Calendar.getInstance();
        Date dt = cal.getTime();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
        String strUpdateDate = "Updated to Credit on " + sdf.format(dt);

        TMasterCustomerGroupCredit custGroupCredit = groupCreditService.findOne(nCreditID);
        if (custGroupCredit != null) {
            int nPreviousStateOfCredit_or_Debit = custGroupCredit.getCreditOrDebit();
            custGroupCredit.setCreditOrDebit((byte) nCreditOrDebit);

            if (strPaymentDetails == null || strPaymentDetails.isEmpty())
                strPaymentDetails = "";

            custGroupCredit.setPaymentDetails(strPaymentDetails);

            String theNotes = "";
            if (custGroupCredit.getNotes() != null)
                theNotes = custGroupCredit.getNotes();

            if (nCreditOrDebit == 1 && nPreviousStateOfCredit_or_Debit == 2) // changing form debit to credit
            {
                custGroupCredit.setNotes(theNotes + ", " + strUpdateDate);
                if (custGroupCredit.getPaymentDate() == null)
                    custGroupCredit.setPaymentDate(dt);
                custGroupCredit.setCreditIdStatus((byte) 2);
            }

            custGroupCredit.setPaymentType((byte) nPaymentType);
            groupCreditService.save(custGroupCredit);
        }
        response.sendRedirect("ManageCustomerGroupCredit.jsp");
    } catch (Exception e) {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Update Customer Group Credit.</FONT></H4>" +
                "<A HREF=\"ManageCustomerGroupCredit.jsp\">Manage Customer Group Credit</A></BODY></HTML>";
        response.getWriter().println(strError);
    }
%>
