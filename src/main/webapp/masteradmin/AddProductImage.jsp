<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.utilities.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
    String strCountryCode = application.getInitParameter("Country");
    ImageUpload imageUpload = new ImageUpload();
    imageUpload.setCountry(strCountryCode);
    if (imageUpload.processData(request))
        response.sendRedirect("MasterInformation.jsp");
    else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Upload Image.</FONT></H4>" +
                "<A HREF=\"MasterInformation.jsp\">Manage Information</A></BODY></HTML>";

        response.getWriter().println(strError);
    }
%>
