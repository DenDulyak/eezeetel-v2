<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    String record_id = request.getParameter("record_id");
    String strFirstName = request.getParameter("first_name");
    String strLastName = request.getParameter("last_name");
    String strMiddleName = request.getParameter("middle_name");
    String strCompany = request.getParameter("company_name");
    String strAddressLine1 = request.getParameter("address_line_1");
    String strAddressLine2 = request.getParameter("address_line_2");
    String strAddressLine3 = request.getParameter("address_line_3");
    String strCity = request.getParameter("city");
    String strState = request.getParameter("state");
    String strPostalCode = request.getParameter("postal_code");
    String strCountry = request.getParameter("country");
    String strPrimaryPhone = request.getParameter("primary_phone");
    String strSecondaryPhone = request.getParameter("secondary_phone");
    String strMobilePhone = request.getParameter("mobile_phone");
    String strEMailID = request.getParameter("email_id");
    int nUserTypeID = Integer.parseInt(request.getParameter("user_type"));
    String strAdditionalNotes = request.getParameter("notes");

    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

    String strQuery = "update t_master_users set User_First_Name = '" + strFirstName + "',"
            + "User_Last_Name = '" + strLastName + "',"
            + "User_Middle_Name = '" + strMiddleName + "',"
            + "User_Company_Name = '" + strCompany + "',"
            + "Address_Line_1 = '" + strAddressLine1 + "',"
            + "Address_Line_2 = '" + strAddressLine2 + "',"
            + "Address_Line_3 = '" + strAddressLine3 + "',"
            + "City = '" + strCity + "',"
            + "State = '" + strState + "',"
            + "Postal_Code = '" + strPostalCode + "',"
            + "Country = '" + strCountry + "',"
            + "Primary_Phone = '" + strPrimaryPhone + "',"
            + "Secondary_Phone = '" + strSecondaryPhone + "',"
            + "Mobile_Phone = '" + strMobilePhone + "',"
            + "EMail_ID = '" + strEMailID + "',"
            + "User_Type_And_Privilege = " + nUserTypeID + ","
            + "User_Modified_Time = now(),"
            + "Notes = '" + strAdditionalNotes + "'"
            + " where User_Login_ID = '" + record_id + "'"
            + " and Customer_Group_ID = " + nCustomerGroupID;

    DatabaseHelper dbHelper = new DatabaseHelper();
    if (dbHelper.executeQuery(strQuery)) {
        response.sendRedirect("/admin/Users/ManageUser.jsp");
    } else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Update User</FONT></H4>" +
                "<A HREF='/admin/Users/ManageUser.jsp'>Manage User Information</A></BODY></HTML>";
        response.getWriter().println(strError);
    }
%>
