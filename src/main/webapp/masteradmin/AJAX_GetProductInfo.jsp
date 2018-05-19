<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    String strSupplier = request.getParameter("supplier_id");
    String strQuery = "from TMasterProductinfo where Product_Active_Status = 1";
    if (strSupplier != null && !strSupplier.isEmpty())
        strQuery += (" AND Supplier_ID = " + Integer.parseInt(strSupplier));
    strQuery += " order by Product_Name, Product_Active_Status";

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        String strResult = "<product_names>";

        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
            TMasterProductinfo prodInfo = (TMasterProductinfo) records.get(nIndex);
            User userInfo = prodInfo.getUser();
            TMasterProducttype prodType = prodInfo.getProductType();
            TMasterSupplierinfo suppInfo = prodInfo.getSupplier();

            strResult += "<product id=\"" + prodInfo.getId() +
                    "\" sup_name=\"" + suppInfo.getSupplierName() +
                    "\" name=\"" + prodInfo.getProductName() +
                    "\" type=\"" + prodType.getProductType() +
                    "\" value=\"" + prodInfo.getProductFaceValue() +
                    "\" desc=\"" + prodInfo.getProductDescription() +
                    "\" first_name=\"" + userInfo.getUserFirstName() +
                    "\" notes=\"" + prodInfo.getNotes() +
                    "\" active=\"" + prodInfo.getActive() +
                    "\" calcvat=\"" + prodInfo.getCalculateVat() +
                    "\" costPrice=\"" + (prodInfo.getCostPrice() == null ? 0.0 : prodInfo.getCostPrice()) +
                    "\"/>";
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
