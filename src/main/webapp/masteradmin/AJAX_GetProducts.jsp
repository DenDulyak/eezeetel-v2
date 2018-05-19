<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    String strSupplier = request.getParameter("supplier_id");
    String strQuery = "from TMasterProductinfo where Product_Active_Status = 1";
    if (strSupplier != null && !strSupplier.isEmpty())
        strQuery += (" AND Supplier_ID = " + Integer.parseInt(strSupplier));

    strQuery += " order by Product_Name";

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        String strResult = "<product_names>";

        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
            TMasterProductinfo prodInfo = (TMasterProductinfo) records.get(nIndex);
            strResult += "<product id=\"" + prodInfo.getId() + "\" name=\"" + prodInfo.getProductName() + "\" faceValue=\"" + prodInfo.getProductFaceValue() + "\"/>";
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
