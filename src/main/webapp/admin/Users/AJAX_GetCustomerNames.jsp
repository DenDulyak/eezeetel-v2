<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
    String strQuery = "from TMasterCustomerinfo where Customer_Group_ID = " + nCustomerGroupID + " and Active_Status = 1 order by Customer_Company_Name";

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        String strResult = "<customer_info>";
        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) records.get(nIndex);
            if (custInfo.getGroup().getId().intValue() == nCustomerGroupID)
                strResult += "<customer id = \"" + custInfo.getId() + "\" name=\"" + custInfo.getCompanyName() + "\"/>";
        }
        strResult += "</customer_info>";

        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } catch (Exception e) {
        e.printStackTrace();
        String strResult = "<customer_info></customer_info>";
        response.setContentType("text/xml");
        response.getWriter().println(strResult);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
