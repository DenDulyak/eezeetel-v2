<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    String strProductID = request.getParameter("product_id");
    if (strProductID == null || strProductID.isEmpty()) {
        response.setContentType("text/plain");
        response.getWriter().println("0");
        return;
    }

    Session theSession = null;

    try {
        Integer nProductID = Integer.parseInt(strProductID);
        Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
        String strCustomerGroups = "" + nCustomerGroupID;
        if (nCustomerGroupID == 5)
            strCustomerGroups += ", 1";

        theSession = HibernateUtil.openSession();

        String strQuery = "select count(SequenceID) as Quantity from t_sim_cards_info where Is_Sold = 0 and Product_ID = " + nProductID
                + " and Customer_ID = 0 "
                + " and Customer_Group_ID in ( " + strCustomerGroups + ")";

        SQLQuery query = theSession.createSQLQuery(strQuery);
        query.addScalar("Quantity", new IntegerType());
        List list = query.list();
        if (list.size() > 0) {
            Integer availableQuantity = (Integer) list.get(0);
            response.setContentType("text/plain");
            response.getWriter().println(availableQuantity.intValue());
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.setContentType("text/plain");
        response.getWriter().println("0");
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
