<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%@ page import="org.apache.catalina.realm.JDBCRealm" %>

<%
    String strLoginID = request.getParameter("login_id");
    String strCompanyName = request.getParameter("company_name");
    int nCustomerID = 0;
    String strFirstName = request.getParameter("first_name");
    String strLastName = request.getParameter("last_name");
    String strMiddleName = request.getParameter("middle_name");
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
    String strUserCreatedBy = request.getParameter("user_created_by");
    String strPassword_1 = request.getParameter("password_1");
    /*String strPassword_2 = request.getParameter("password_2");*/
    String strNotes = request.getParameter("notes");
    String strEncryptedPassword = JDBCRealm.Digest(strPassword_1, "MD5", "utf8");

    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

    String strQuery = "";
    Session theSession = null;
    SQLQuery sqlQuery = null;

    try {
        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        if (nUserTypeID == 7 || nUserTypeID == 8) {
            nCustomerID = Integer.parseInt(strCompanyName);

            strQuery = "from TMasterCustomerinfo where Customer_ID = " + nCustomerID + " and Customer_Group_ID = " + nCustomerGroupID;
            Query query = theSession.createQuery(strQuery);
            List listCompanyName = query.list();

            if (listCompanyName.size() > 0) {
                TMasterCustomerinfo custInfo = (TMasterCustomerinfo) listCompanyName.get(0);
                strCompanyName = custInfo.getCompanyName();
            }
        }

        strQuery = "insert into t_master_users (User_Login_ID, User_First_Name, User_Last_Name, User_Middle_Name," +
                "User_Company_Name, Address_Line_1, Address_Line_2, Address_Line_3, City, State, Postal_Code," +
                "Country, Primary_Phone, Secondary_Phone, Mobile_Phone, EMail_ID, User_Type_And_Privilege, " +
                "Password, Password_2, User_Active_Status, User_Created_By, User_Creation_Time, User_Modified_Time, Notes, Customer_Group_ID)" +
                "values ('" + strLoginID + "','" + strFirstName + "', '" + strLastName + "', '" +
                strMiddleName + "', '" + strCompanyName + "','" +
                strAddressLine1 + "', '" + strAddressLine2 + "', '" + strAddressLine3 + "', '" +
                strCity + "', '" + strState + "', '" + strPostalCode + "', '" + strCountry + "', '" +
                strPrimaryPhone + "', '" + strSecondaryPhone + "', '" + strMobilePhone + "', '" +
                strEMailID + "'," + nUserTypeID + ",'" + strEncryptedPassword + "','" + strPassword_1 + "', 1, '" +
                strUserCreatedBy + "', now(), now(), '" + strNotes + "', " + nCustomerGroupID + ")";

        sqlQuery = theSession.createSQLQuery(strQuery);
        sqlQuery.executeUpdate();

        if (nUserTypeID == 7 || nUserTypeID == 8) {
            strQuery = "insert into t_customer_users (Customer_ID, User_Login_ID) values (" +
                    nCustomerID + ", '" + strLoginID + "')";

            sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.executeUpdate();
        }

        theSession.getTransaction().commit();
        response.sendRedirect("/admin/Users/ManageUser.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        if (theSession != null) {
            theSession.getTransaction().rollback();
        }
        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Craete User.</FONT></H4>" +
                "<A HREF='/admin/Users/ManageUser.jsp'>Manage User Information</A></BODY></HTML>";
        response.getWriter().println(strError);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>

