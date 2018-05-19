<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    String strCountryCode = application.getInitParameter("Country");
    int nCustomerId = Integer.parseInt(request.getParameter("customer_id"));
    int nPaymentType = Integer.parseInt(request.getParameter("payment_type"));
    float fAmount = Float.parseFloat(request.getParameter("payment_amount"));
    int nCreditOrDebit = Integer.parseInt(request.getParameter("credit_or_debit"));
    String strPaymentDetails = request.getParameter("payment_details");
    String strPayDate = "now()";
    String strCollectedBy = request.getParameter("collected_by");
    String strUserId = strCollectedBy;

    String strQuery = "insert into t_master_customer_credit (Customer_ID, Payment_Type, Payment_Details, " +
            "Payment_Amount, Payment_Date, Collected_By, Entered_By, Entered_Time, Credit_or_Debit)" +
            "values (" + nCustomerId + "," + nPaymentType + ",'" +
            strPaymentDetails + "'," + fAmount + "," + strPayDate + ",'" +
            strCollectedBy + "','" + strUserId + "', now(), " + nCreditOrDebit + ")";

    String strQuery1 = "update t_master_customerinfo set Customer_Balance = Customer_Balance + " + fAmount +
            " where Customer_ID = " + nCustomerId;

    DatabaseHelper dbHelper = new DatabaseHelper();
    if (dbHelper.executeMultipleQuery(strQuery, strQuery1))
        response.sendRedirect("AJAX_GetCreditInfo.jsp?customer_id=" + nCustomerId);
    else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Add Customer Credit.</FONT></H4>" +
                "<A HREF=\"QuickCredit.jsp\">Manage Customer Credit</A></BODY></HTML>";

        response.getWriter().println(strError);
    }
%>
