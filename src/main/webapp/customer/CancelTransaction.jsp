<%@ page import="com.eezeetel.customerapp.ProcessTransaction" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Expires", "-1");

    long nTransactionID = 0;
    Object objTransactionID = request.getSession().getAttribute("CurrentTransactionID");
    if (objTransactionID != null) {
        String strTransactionID = objTransactionID.toString();
        if (strTransactionID != null && strTransactionID.length() > 0)
            nTransactionID = (Long.parseLong(strTransactionID));
    }

    if (nTransactionID > 0) {
        ProcessTransaction processTransaction = new ProcessTransaction();
        boolean bProcessed = processTransaction.cancel(nTransactionID);
        request.getSession().setAttribute("CurrentTransactionID", 0);
        if (bProcessed)
            response.sendRedirect("/customer/products");
        else {
            response.getWriter().printf("<font color=red>Transaction cancelation failed</font>");
            response.getWriter().printf("<a href='/customer/products'> Show Products </a>");
        }
    } else
        response.sendRedirect("/customer/products");
%>
