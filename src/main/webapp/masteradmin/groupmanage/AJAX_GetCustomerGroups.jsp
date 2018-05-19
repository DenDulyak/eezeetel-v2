<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<%
    String strQuery = "", strResult = "<The_Data>";

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();

        strQuery = "from TMasterCustomerGroups where IsActive = 1 order by Customer_Group_Name";
        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        for (int i = 0; i < records.size(); i++) {
            TMasterCustomerGroups custGroup = (TMasterCustomerGroups) records.get(i);
            strResult += ("<customer_group id=\"" + custGroup.getId() + "\" name=\"" + custGroup.getName() + "\"/>");
        }

        strResult += ("</The_Data>");
        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } catch (Exception e) {
        e.printStackTrace();
        strResult = "<The_Data></The_Data>";
        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
