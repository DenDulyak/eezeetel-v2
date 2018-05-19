<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    String strProductID = request.getParameter("product_id");
    if (strProductID == null || strProductID.isEmpty()) {
        response.setContentType("text/plain");
        response.getWriter().println("");
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

        String strQuery = "from TSimCardsInfo where Customer_Group_ID in ( " + strCustomerGroups + ")" +
                " and Is_Sold = 0 and Customer_ID = 0 and Product_ID = " + nProductID +
                " order by Batch_Sequence_ID, sim_card_id, sim_card_pin";

        Query query = theSession.createQuery(strQuery);
        List records = query.list();
        String strResult = "<table border=\"1\"><tr><th></th><th>Product</th><th>Sim ID</th><th>Sim Number</th></tr>";
        strResult += "<tr><td colspan=4>Available Quantity : " + records.size() + "</td></tr>";
        strResult += "<tr><td colspan=4><input type=\"button\" name=\"Select_All\" value=\"Select All\" onClick=\"SelectAllSIMs()\"></td></tr>";

        for (int nSim = 0; nSim < records.size(); nSim++) {
            TSimCardsInfo simInfo = (TSimCardsInfo) records.get(nSim);
            TMasterProductinfo prodInfo = simInfo.getProduct();

            strResult += "<tr>";
            strResult += "<td><input type=\"checkbox\" name=\"assigned_sims\" value=\"" + simInfo.getId() + "\"/></td>";
            strResult += "<td>" + prodInfo.getProductName() + "</td>";
            strResult += "<td>" + simInfo.getSimCardId() + "</td>";
            strResult += "<td>" + simInfo.getSimCardPin() + "</td>";
            strResult += "</tr>";
        }

        strResult += "</table>";

        response.setContentType("text/html");
        response.getWriter().println(strResult);
    } catch (Exception e) {
        e.printStackTrace();
        response.setContentType("text/plain");
        response.getWriter().println("");
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
    