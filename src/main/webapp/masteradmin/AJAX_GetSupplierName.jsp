<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    int nSupplierId = Integer.parseInt(request.getParameter("supplier_id"));

    String strQuery = "from TMasterSupplierinfo where Supplier_Active_Status = 1"
            + " AND Supplier_ID = " + nSupplierId + " order by Supplier_Name";

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        String strResult = "<supplier_info>";
        if (records.size() > 0) {
            TMasterSupplierinfo supInfo = (TMasterSupplierinfo) records.get(0);
            strResult += "<supplier name=\"" + supInfo.getSupplierName() + "\"/>";
        }
        strResult += "</supplier_info>";

        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } catch (Exception e) {
        e.printStackTrace();
        String strResult = "<supplier_info></supplier_info>";
        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
