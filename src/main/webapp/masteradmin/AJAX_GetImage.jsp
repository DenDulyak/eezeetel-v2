<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    String strSaleInfoId = request.getParameter("sale_info_id");
    String strQuery = "from TMasterProductsaleinfo where Sale_Info_ID = " + strSaleInfoId;

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        String strResult = "<product_image_info>";
        if (records.size() > 0) {
            TMasterProductsaleinfo prodSaleInfo = (TMasterProductsaleinfo) records.get(0);
            strResult += "<image_file filename=\"" + prodSaleInfo.getProductImageFile() + "\" />";
        }
        strResult += "</product_image_info>";

        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } catch (Exception e) {
        String strResult = "<product_image_info></product_image_info>";
        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
