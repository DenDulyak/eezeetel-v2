<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    String strCustomerCompanyName = request.getParameter("customer_company_name");
    int nCustomerTypeId = Integer.parseInt(request.getParameter("customer_type_id"));
    String strFirstName = request.getParameter("first_name");
    String strLastName = request.getParameter("last_name");
    String strMiddleName = request.getParameter("middle_name");
    String strAddressLine1 = request.getParameter("address_line_1");
    String strAddressLine2 = request.getParameter("address_line_2");
    String strAddressLine3 = request.getParameter("address_line_3");
    String strCity = request.getParameter("city");
    String strState = request.getParameter("state");
    String strPostCode = request.getParameter("postal_code");
    String strCountry = request.getParameter("country");
    String strPrimaryPhone = request.getParameter("primary_phone");
    String strSecondaryPhone = request.getParameter("secondary_phone");
    String strMobilePhone = request.getParameter("mobile_phone");
    String strWebsiteAddress = request.getParameter("website_address");
    String strEmailId = request.getParameter("email_id");
    String strCustomerCreatedByUserID = request.getParameter("customer_created_by");
    String strCustomerIntroducedBy = request.getParameter("customer_introduced_by");
    String strAdditionalNotes = request.getParameter("additional_notes");
    String strGroupID = request.getParameter("Customer_Group_ID");
    String strFeaturesID = request.getParameter("Customer_Features_ID");
    int nGroupID = Integer.parseInt(strGroupID);

    String strQuery = "insert into t_master_customerinfo (Customer_Company_Name, Customer_Type_ID," +
            "First_Name, Last_Name, Middle_Name, Address_Line_1, Address_Line_2, " +
            "Address_Line_3, City, State, Postal_Code, Country, Primary_Phone, " +
            "Secondary_Phone, Mobile_Phone, Website_Address, Email_ID, Created_By_User_ID, " +
            "Customer_Introduced_By, Active_Status, Last_Modified_Time, Creation_Time, Notes, " +
            " Customer_Group_ID, Customer_Feature_ID) " +
            "values('" + strCustomerCompanyName + "'," + nCustomerTypeId +
            ", '" + strFirstName + "', '" + strLastName + "', '" + strMiddleName +
            "', '" + strAddressLine1 + "', '" + strAddressLine2 + "', '" + strAddressLine3 +
            "', '" + strCity + "', '" + strState + "', '" + strPostCode + "', '" + strCountry +
            "', '" + strPrimaryPhone + "', '" + strSecondaryPhone + "', '" + strMobilePhone +
            "', '" + strWebsiteAddress + "', '" + strEmailId + "', '" + strCustomerCreatedByUserID +
            "', '" + strCustomerIntroducedBy + "', 1, now(), now(), '" + strAdditionalNotes + "'," +
            nGroupID + "," + strFeaturesID + ")";

    DatabaseHelper dbHelper = new DatabaseHelper();
    if (dbHelper.executeQuery(strQuery))
        response.sendRedirect("ManageCustomerInfo.jsp");
    else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Craete New Customer.</FONT></H4>" +
                "<A HREF=\"ManageCustomerInfo.jsp\">Manage Customers</A></BODY></HTML>";

        response.getWriter().println(strError);
    }
%>
