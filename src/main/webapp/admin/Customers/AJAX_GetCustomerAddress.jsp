<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
    String strCustomerID = request.getParameter("customer_id");
    int nCustomerId = 0;
    if (strCustomerID != null && !strCustomerID.isEmpty())
        nCustomerId = Integer.parseInt(strCustomerID);

    if (nCustomerId <= 0) {
        response.setContentType("text/xml");
        response.getWriter().println("");
        return;
    }

    String strQuery = "from TMasterCustomerinfo where Customer_Group_ID = " + nCustomerGroupID + " and Active_Status = 1 " +
            " and Customer_ID = " + nCustomerId + " order by Customer_Company_Name";

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        String strResult = "<customer_info>";
        if (records.size() > 0) {
            TMasterCustomerinfo custInfo = (TMasterCustomerinfo) records.get(0);
            if (custInfo.getGroup().getId().intValue() == nCustomerGroupID) {
                strResult += "<customer add_line_1 =\"" + custInfo.getAddressLine1() + "\" add_line_2=\"" + custInfo.getAddressLine2() + "\"";
                strResult += " add_line_3 =\"" + custInfo.getAddressLine3() + "\" city=\"" + custInfo.getCity() + "\" ";
                strResult += " state=\"" + custInfo.getState() + "\" Postal_code =\"" + custInfo.getPostalCode() + "\" ";
                strResult += " country=\"" + custInfo.getCountry() + "\"";
                strResult += "/>";
            }
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
