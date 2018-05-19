<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    String strCountryCode = application.getInitParameter("Country");
    int record_id = Integer.parseInt(request.getParameter("record_id"));
    String strQuery = "update t_batch_information set IsBatchActive = 1"
            + ", LastModifiedTime = now()"
            + " where SequenceID = " + record_id
            + " and IsBatchActive = 0";

    DatabaseHelper dbHelper = new DatabaseHelper();
    dbHelper.setCountry(strCountryCode);
    dbHelper.executeQuery(strQuery);

    if (dbHelper.executeQuery(strQuery))
        response.sendRedirect("ManageBatchInfo.jsp");
    else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Activate Batch Information.</FONT></H4>" +
                "<A HREF=\"ManageBatchInfo.jsp\">Manage Batch Information</A></BODY></HTML>";

        response.getWriter().println(strError);
    }

%>
