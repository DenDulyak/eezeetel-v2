<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    String strSupplier = request.getParameter("supplier_id");
    String strCustomer = request.getParameter("customer_id");
    String strQuery = "from TMasterProductinfo where Product_Active_Status = 1";
    if (strSupplier != null && !strSupplier.isEmpty())
        strQuery += (" AND Supplier_ID = " + Integer.parseInt(strSupplier));
    strQuery += " order by Product_Name, Product_Active_Status";

    String strQuery_cust = "from TMasterCustomerinfo where Active_Status=1 and Customer_ID !=" + Integer.parseInt(strCustomer);

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        Query query = theSession.createQuery(strQuery);
        List records = query.list();


        Query query_cust = theSession.createQuery(strQuery_cust);
        List records_cust = query_cust.list();


        String strResult = "<product_names>";

        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
            TMasterProductinfo prodInfo = (TMasterProductinfo) records.get(nIndex);
            TMasterSupplierinfo suppInfo = prodInfo.getSupplier();


            int var_new = prodInfo.getId();

            String strQuery_new = "from TCustomerCommission where Product_ID = " + var_new;
            strQuery_new += (" AND Customer_ID = " + Integer.parseInt(strCustomer));

            Query query_new = theSession.createQuery(strQuery_new);
            List records_new = query_new.list();

            float commission_n = 0;
            byte commissiontype_n = 1;
            String notes_n = null;

            if (records_new.size() == 1) {
                TCustomerCommission custcomm = (TCustomerCommission) records_new.get(0);
                commission_n = custcomm.getCommission();
                commissiontype_n = custcomm.getCommissionType();
                notes_n = custcomm.getNotes();
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

        for (int nIndex = 0; nIndex < records_cust.size(); nIndex++) {
            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) records_cust.get(nIndex);
            strResult += "<customer_values customer_id=\"" + custInfo.getId() +
                    "\" customer_company_name=\"" + custInfo.getCompanyName() + "\"/>";
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
