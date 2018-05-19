<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.utilities.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
    String strCountryCode = application.getInitParameter("Country");
    BatchUpload batchUpload = new BatchUpload();
    if (batchUpload.processData(request))
        response.sendRedirect("ManageBatchInfo.jsp");
    else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to add new batch.</FONT></H4>" +
                "<A HREF=\"ManageBatchInfo.jsp\">Manage Batch Information</A></BODY></HTML>";

        response.getWriter().println(strError);
    }
%>