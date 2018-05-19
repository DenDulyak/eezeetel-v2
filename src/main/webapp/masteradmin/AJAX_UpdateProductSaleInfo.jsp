<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    String strSaleInfoID = request.getParameter("sale_info_id");
    if (strSaleInfoID != null && !strSaleInfoID.isEmpty()) {
        String strQuery = "from TMasterProductsaleinfo where IsActive = 1";
        strQuery += (" AND Sale_Info_ID = " + Integer.parseInt(strSaleInfoID));

        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
            Query query = theSession.createQuery(strQuery);
            List records = query.list();
            String strResult = "";

            if (records.size() > 0) {
                TMasterProductsaleinfo prodSaleInfo = (TMasterProductsaleinfo) records.get(0);

                strResult = "<font color=green><table border=1>" +
                        "<tr><td align=right>Sale Info ID : </td><td align=left>" +
                        prodSaleInfo.getId() +
                        "<tr><td align=right>Print Info : </td><td align=left><p>" +
                        "<textarea name=\"sale_info\" rows=\"20\" cols=\"64\" WRAP=\"PHYSICAL\" readonly>" +
                        prodSaleInfo.getPrintInfo() + "</textarea></p></td></tr>" +
                        "<tr><td align=right>Notes : </td><td align=left>" + prodSaleInfo.getNotes() + "</td></tr>" +
                        "<tr><td align=right>Image : </td><td align=left><IMG  width=300 height=200 SRC=\"" +
                        prodSaleInfo.getProductImageFile() + "\"/></td></tr></table></font>";
            }

            response.setContentType("text/plain");
            response.getWriter().println(strResult);
        } catch (Exception e) {
            e.printStackTrace();
            String strResult = "";
            response.setContentType("text/plain");
            response.getWriter().println(strResult);
        } finally {
            HibernateUtil.closeSession(theSession);
        }
    }
%>
