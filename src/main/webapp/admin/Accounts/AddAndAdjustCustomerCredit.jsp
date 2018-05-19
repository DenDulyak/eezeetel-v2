<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    int nCustomerId = Integer.parseInt(request.getParameter("customer_id"));
    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

    DatabaseHelper dbHelper = new DatabaseHelper();
    if (dbHelper.GetCustomerGroupID(nCustomerId) == nCustomerGroupID) {
        int nPaymentType = Integer.parseInt(request.getParameter("payment_type"));
        String strPaymentDetails = request.getParameter("payment_details");
        float fAmount = Float.parseFloat(request.getParameter("payment_amount"));
        int nCreditOrDebit = Integer.parseInt(request.getParameter("credit_or_debit"));
        String strPayDate = request.getParameter("payment_date");
        String strCollectedBy = request.getParameter("collected_by");
        String strUserId = request.getParameter("entered_by");

        SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yyyy", Locale.ENGLISH);
        java.util.Date dtArrivalDate = dt.parse(strPayDate);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        strPayDate = sdf.format(dtArrivalDate);

        String strQuery1 = "insert into t_master_customer_credit (Customer_ID, Payment_Type, Payment_Details, " +
                "Payment_Amount, Payment_Date, Collected_By, Entered_By, Entered_Time, Credit_or_Debit)" +
                " values (" + nCustomerId + "," + nPaymentType + ",'" +
                strPaymentDetails + "'," + fAmount + ",'" + strPayDate + "','" +
                strCollectedBy + "','" + strUserId + "', now(), " + nCreditOrDebit + ")";

        String strQuery2 = "update t_master_customerinfo set Customer_Balance = Customer_Balance + " + fAmount +
                " where Customer_ID = " + nCustomerId + " and Customer_Group_ID = " + nCustomerGroupID;

        if (dbHelper.executeMultipleQuery(strQuery1, strQuery2))
            response.sendRedirect("/admin/Accounts/ManageCustomerCredit.jsp");
        else {
            String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Add and Adjust Customer Credit.</FONT></H4>" +
                    "<A HREF=\"/admin/Accounts/ManageCustomerCredit.jsp\">Manage Customer Credit</A></BODY></HTML>";
            response.getWriter().println(strError);
        }
    }
%>