<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ page import="com.commons.*" %>
<%
    String strCountryCode = application.getInitParameter("Country");
    String strRemoteAddress = request.getRemoteAddr();
    if (strRemoteAddress != null && !strRemoteAddress.isEmpty()) {
        String strContactName = request.getParameter("contact_name");
        String strBusinessName = request.getParameter("business_name");
        String strReferredBy = request.getParameter("referred_by");
        String strContatNumber = request.getParameter("contact_number");
        String strEMailID = request.getParameter("email_id");
        String strAdditionalInfo = request.getParameter("additional_information");

        String strQuery = "insert into t_new_contacts(Contact_Name, Contact_Business_Name, Referred_By, Contact_Number, Contact_Email, Additional_Notes, Contact_Time, Addressed_By, Remote_Address, Group_ID) " +
                " values ('" + strContactName + "', '" + strBusinessName + "', '" + strReferredBy + "', " +
                "'" + strContatNumber + "', '" + strEMailID + "', '" + strAdditionalInfo + "', now(), 'Pending', '" + strRemoteAddress + "', 4)";

        DatabaseHelper dbHelper = new DatabaseHelper();
        dbHelper.setCountry(strCountryCode);
        dbHelper.InsertNewContact(strQuery, strRemoteAddress);
    }

    response.sendRedirect("/KASApp/");
%>
