<%@ page import="com.eezeetel.enums.FeatureType" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    int record_id = Integer.parseInt(request.getParameter("record_id"));
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
    String strCustomerIntroducedBy = request.getParameter("customer_introduced_by");
    String strAdditionalNotes = request.getParameter("additional_notes");
    /*String strFeaturesID = request.getParameter("Customer_Features_ID");*/

    List<FeatureType> featureTypes = new ArrayList<FeatureType>();

    for (FeatureType type : FeatureType.values()) {
        if (request.getParameter(type.name()) != null) {
            featureTypes.add(type);
        }
    }

    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

    String strAllowCredit = request.getParameter("allow_credit");
    int allowCredit = 0;
    if (strAllowCredit != null && strAllowCredit.equalsIgnoreCase("on"))
        allowCredit = 1;

    String strPrintPreview = request.getParameter("show_print_preview");
    int showPrintPreview = 0;
    if (strPrintPreview != null && strPrintPreview.equalsIgnoreCase("on"))
        showPrintPreview = 1;

    String strQuery = "update t_master_customerinfo set Customer_Company_Name = '" + strCustomerCompanyName + "',"
            + "Customer_Type_Id = " + nCustomerTypeId + ","
            + "First_Name = '" + strFirstName + "',"
            + "Last_Name = '" + strLastName + "',"
            + "Middle_Name = '" + strMiddleName + "',"
            + "Address_Line_1 = '" + strAddressLine1 + "',"
            + "Address_Line_2 = '" + strAddressLine2 + "',"
            + "Address_Line_3 = '" + strAddressLine3 + "',"
            + "City = '" + strCity + "',"
            + "State = '" + strState + "',"
            + "Postal_Code = '" + strPostCode + "',"
            + "Country = '" + strCountry + "',"
            + "Primary_Phone = '" + strPrimaryPhone + "',"
            + "Secondary_Phone = '" + strSecondaryPhone + "',"
            + "Mobile_Phone = '" + strMobilePhone + "',"
            + "Website_Address = '" + strWebsiteAddress + "',"
            + "Email_ID = '" + strEmailId + "',"
            + "Customer_Introduced_By = '" + strCustomerIntroducedBy + "',"
            + "Last_Modified_Time = now(),"
            + "Notes = '" + strAdditionalNotes + "',"
            /*+ "Customer_Feature_ID = " + strFeaturesID + ","*/
            + "Allow_Credit = " + allowCredit + ","
            + "Special_Printer_Customer = " + showPrintPreview
            + " where Customer_ID = " + record_id + " and Customer_Group_ID = " + nCustomerGroupID;

    DatabaseHelper dbHelper = new DatabaseHelper();
    if (dbHelper.executeQuery(strQuery)) {
        if (dbHelper.removeFeaturesFromCustomer(record_id)) {
            dbHelper.addFeaturesToCustomer(record_id, featureTypes);
        }
        response.sendRedirect("/admin/Customers/ManageCustomerInfo.jsp");
    } else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Update Customer Information</FONT></H4>" +
                "<A HREF='/admin/Customers/ManageCustomerInfo.jsp'>Manage Customer Information</A></BODY></HTML>";
        response.getWriter().println(strError);
    }
%>