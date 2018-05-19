<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    String strSupplier = request.getParameter("supplier_id");
    String strAgent = request.getParameter("agent_id");
    String strQuery = "from TMasterProductinfo where Product_Active_Status = 1";
    if (strSupplier != null && !strSupplier.isEmpty())
        strQuery += (" AND Supplier_ID = " + Integer.parseInt(strSupplier));
    strQuery += " order by Product_Active_Status";

    String strQuery_age = "from User where User_Type_And_Privilege = 6 and User_Active_Status = 1 and User_login_ID != '" + strAgent + "'";

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();

        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        Query query_age = theSession.createQuery(strQuery_age);
        List records_age = query_age.list();

        String strResult = "<product_names>";

        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
            TMasterProductinfo prodInfo = (TMasterProductinfo) records.get(nIndex);
            TMasterSupplierinfo suppInfo = prodInfo.getSupplier();


            int var_new = prodInfo.getId();

            String strQuery_new = "from TAgentCommission where Product_ID = " + var_new;
            strQuery_new += (" AND Agent_ID = '" + (strAgent) + "'");

            Query query_new = theSession.createQuery(strQuery_new);
            List records_new = query_new.list();

            float commission_n = 0;
            byte commissiontype_n = 0;
            String notes_n = null;

            if (records_new.size() == 1) {
                TAgentCommission agecomm = (TAgentCommission) records_new.get(0);
                commission_n = agecomm.getCommission();
                commissiontype_n = agecomm.getCommissionType();
                notes_n = agecomm.getNotes();
            }
            strResult += "<product id=\"" + prodInfo.getId() +
                    "\" sup_name=\"" + suppInfo.getSupplierName() +
                    "\" name=\"" + prodInfo.getProductName() +
                    "\" value=\"" + prodInfo.getProductFaceValue() +
                    "\" commission=\"" + commission_n +
                    "\" commission_type=\"" + commissiontype_n +
                    "\" notes=\"" + notes_n +
                    "\" active=\"" + prodInfo.getActive() + "\"/>";
        }

        for (int nIndex = 0; nIndex < records_age.size(); nIndex++) {
            User ageInfo = (User) records_age.get(nIndex);
            strResult += "<agent_values agent_id=\"" + ageInfo.getLogin() +
                    "\" agent_first_name=\"" + ageInfo.getUserFirstName() + "\"/>";
        }

        strResult += "</product_names>";

        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } catch (Exception e) {
        e.printStackTrace();
        String strResult = "<product_names></product_names>";
        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
