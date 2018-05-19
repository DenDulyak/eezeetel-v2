<%@ page import="com.eezeetel.enums.FeatureType" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%@ include file="/common/SessionCheck.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%

    Session theSession = null;
    boolean bApplyDefaultPercentages = false;
    int nDefaultCustomerID = 0;
    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
    try {
        theSession = HibernateUtil.openSession();

        String strQuery = "from TMasterCustomerGroups where Customer_Group_ID = " + nCustomerGroupID;
        Query query = theSession.createQuery(strQuery);
        List groupList = query.list();
        if (groupList.size() > 0) {
            TMasterCustomerGroups theGroup = (TMasterCustomerGroups) groupList.get(0);
            if (theGroup.getApplyDefaultCustomerPercentages()) {
                bApplyDefaultPercentages = true;
                nDefaultCustomerID = theGroup.getDefaultCustomer().getId();
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }

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
    //String strFeaturesID = request.getParameter("Customer_Features_ID");
    String strFeaturesID = "0";
    int nGroupID = Integer.parseInt(strGroupID);
    String strAllowCredit = request.getParameter("allow_credit");
    int allowCredit = 0;
    if (strAllowCredit != null && strAllowCredit.equalsIgnoreCase("on"))
        allowCredit = 1;

    String strPrintPreview = request.getParameter("show_print_preview");
    int showPrintPreview = 0;
    if (strPrintPreview != null && strPrintPreview.equalsIgnoreCase("on"))
        showPrintPreview = 1;

    List<FeatureType> featureTypes = new ArrayList<FeatureType>();

    for (FeatureType type : FeatureType.values()) {
        if (request.getParameter(type.name()) != null) {
            featureTypes.add(type);
        }
    }

    String strQuery = "insert into t_master_customerinfo (Customer_Company_Name, Customer_Type_ID," +
            "First_Name, Last_Name, Middle_Name, Address_Line_1, Address_Line_2, " +
            "Address_Line_3, City, State, Postal_Code, Country, Primary_Phone, " +
            "Secondary_Phone, Mobile_Phone, Website_Address, Email_ID, Created_By_User_ID, " +
            "Customer_Introduced_By, Active_Status, Last_Modified_Time, Creation_Time, Notes, " +
            " Customer_Group_ID, Customer_Feature_ID, Allow_Credit, Special_Printer_Customer) " +
            "values('" + strCustomerCompanyName + "'," + nCustomerTypeId +
            ", '" + strFirstName + "', '" + strLastName + "', '" + strMiddleName +
            "', '" + strAddressLine1 + "', '" + strAddressLine2 + "', '" + strAddressLine3 +
            "', '" + strCity + "', '" + strState + "', '" + strPostCode + "', '" + strCountry +
            "', '" + strPrimaryPhone + "', '" + strSecondaryPhone + "', '" + strMobilePhone +
            "', '" + strWebsiteAddress + "', '" + strEmailId + "', '" + strCustomerCreatedByUserID +
            "', '" + strCustomerIntroducedBy + "', 1, now(), now(), '" + strAdditionalNotes + "'," +
            nCustomerGroupID + "," + strFeaturesID + "," + allowCredit + "," + showPrintPreview + ")";

    DatabaseHelper dbHelper = new DatabaseHelper();
    if (dbHelper.executeQuery(strQuery)) {
        int nNewCustomerID = 0;
        try {
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();

            String customerIDQuery = "from TMasterCustomerinfo where Customer_Company_Name = '" + strCustomerCompanyName + "' and Customer_Group_ID = " + nGroupID +
                    " and Created_By_User_ID = '" + strCustomerCreatedByUserID + "' and Customer_Introduced_By = '" + strCustomerIntroducedBy + "'";

            Query query = theSession.createQuery(customerIDQuery);
            List custIDList = query.list();
            if (custIDList.size() > 0) {
                TMasterCustomerinfo custInfo = (TMasterCustomerinfo) custIDList.get(0);
                nNewCustomerID = custInfo.getId();

                if (bApplyDefaultPercentages == true && nDefaultCustomerID != 0) {
                    // obtain commissions for default existing customer

                    String obtainQuery = "select " + nNewCustomerID + ", Product_ID, CommissionType, Commission, 1, '" + request.getRemoteUser() + "', " +
                            " now(), now(), Notes, Agent_Commission from t_customer_commission where Customer_ID = " + nDefaultCustomerID;

                    // copy default customer commissions to new customer

                    String copyCommQuery = "insert into t_customer_commission (Customer_ID, Product_ID, CommissionType, Commission, Active_Status, Created_By, " +
                            " Creation_Time, Last_Modified_Time, Notes, Agent_Commission) (" + obtainQuery + ")";

                    SQLQuery query1 = theSession.createSQLQuery(copyCommQuery);
                    query1.executeUpdate();
                }

                if (dbHelper.removeFeaturesFromCustomer(nNewCustomerID)) {
                    dbHelper.addFeaturesToCustomer(nNewCustomerID, featureTypes);
                }
            }
            theSession.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            if (theSession != null)
                theSession.getTransaction().rollback();
            String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">CUSTOMER IS CREATED.  Failed to Add default percentages automatically.  Please do it manually.</FONT></H4>" +
                    "<A HREF=\"" + ksContext + "/admin/Customers/ManageCustomerInfo.jsp\">Manage Customer Information</A></BODY></HTML>";
            response.getWriter().println(strError);
            return;
        } finally {
            HibernateUtil.closeSession(theSession);
        }

        response.sendRedirect(ksContext + "/admin/Customers/ManageCustomerInfo.jsp");
    } else {
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Craete New Customer.</FONT></H4>" +
                "<A HREF=\"" + ksContext + "/admin/Customers/ManageCustomerInfo.jsp\">Manage Customer Information</A></BODY></HTML>";

        response.getWriter().println(strError);
    }
%>
