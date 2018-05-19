<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%@ include file="/common/SessionCheck.jsp" %>

<%
    String strCustomerID = request.getParameter("customer_id");
    if (strCustomerID == null || strCustomerID.isEmpty()) {
        response.setContentType("text/plain");
        response.getWriter().println("");
        return;
    }

    String strProductID = request.getParameter("product_id");
    if (strProductID == null || strProductID.isEmpty()) {
        response.setContentType("text/plain");
        response.getWriter().println("");
        return;
    }

    String strSoldOrUnSold = request.getParameter("sold_or_unsold");
    if (strSoldOrUnSold == null || strSoldOrUnSold.isEmpty()) {
        response.setContentType("text/plain");
        response.getWriter().println("");
        return;
    }

    String soldOrUnsoldPart = "";
    if (Integer.parseInt(strSoldOrUnSold) != 2)
        soldOrUnsoldPart = " and Is_Sold = " + Integer.parseInt(strSoldOrUnSold);

    Session theSession = null;

    try {
        Integer nProductID = Integer.parseInt(strProductID);
        Integer nCustomerId = Integer.parseInt(strCustomerID);
        Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
        String strCustomerGroups = "" + nCustomerGroupID;
        if (nCustomerGroupID == 5)
            strCustomerGroups += ", 1";

        theSession = HibernateUtil.openSession();

        String strCustomerName = "None";
        String strAddress = "";

        String strQuery = "from TMasterCustomerinfo where Customer_ID = " + nCustomerId +
                " and Customer_Group_ID in( " + strCustomerGroups + ") order by Customer_Company_Name";
        Query query = theSession.createQuery(strQuery);
        List customers = query.list();

        if (customers.size() > 0) {
            TMasterCustomerinfo cust = (TMasterCustomerinfo) customers.get(0);
            strCustomerName = cust.getCompanyName();
            if (!cust.getAddressLine1().isEmpty())
                strAddress += cust.getAddressLine1();
            if (!cust.getAddressLine2().isEmpty()) {
                if (strAddress.isEmpty())
                    strAddress += cust.getAddressLine2();
                else {
                    strAddress += ", ";
                    strAddress += cust.getAddressLine2();
                }
            }

            if (!cust.getAddressLine3().isEmpty()) {
                if (strAddress.isEmpty())
                    strAddress += cust.getAddressLine3();
                else {
                    strAddress += ", ";
                    strAddress += cust.getAddressLine3();
                }
            }

            if (!cust.getCity().isEmpty()) {
                if (strAddress.isEmpty())
                    strAddress += cust.getCity();
                else {
                    strAddress += ", ";
                    strAddress += cust.getCity();
                }
            }

            if (!cust.getCountry().isEmpty()) {
                if (strAddress.isEmpty())
                    strAddress += cust.getCountry();
                else {
                    strAddress += ", ";
                    strAddress += cust.getCountry();
                }
            }

            if (!cust.getPostalCode().isEmpty()) {
                if (strAddress.isEmpty())
                    strAddress += cust.getPostalCode();
                else {
                    strAddress += ", ";
                    strAddress += cust.getPostalCode();
                }
            }

            if (!cust.getPrimaryPhone().isEmpty()) {
                if (strAddress.isEmpty())
                    strAddress += "Phone: " + cust.getPrimaryPhone();
                else {
                    strAddress += ", ";
                    strAddress += "Phone: " + cust.getPrimaryPhone();
                }
            }
        }

        strQuery = "from TSimCardsInfo where Customer_Group_ID in ( " + strCustomerGroups + ") " + soldOrUnsoldPart;
        strQuery += " and Customer_ID = " + nCustomerId;
        if (nProductID > 0)
            strQuery += " and Product_ID = " + nProductID;
        strQuery += " order by Product_ID, Is_Sold, Batch_Sequence_ID, sim_card_id, sim_card_pin";

        query = theSession.createQuery(strQuery);
        List records = query.list();

        String strResult = "<center><h2>Sim Delivery Note for " + strCustomerName + "</h2></center>";
        strResult += "<center>" + strAddress + "</center><br><table width=\"100%\">";
        strResult += "<tr><th align=\"left\">Product</th><th align=\"left\">Batch Number</th><th align=\"left\">Phone Number</th><!--<th align=\"left\">Status</th>--></tr>";

        for (int nSim = 0; nSim < records.size(); nSim++) {
            TSimCardsInfo simInfo = (TSimCardsInfo) records.get(nSim);
            TMasterProductinfo prodInfo = simInfo.getProduct();

            String simSold = "Available";
            if (simInfo.getIsSold())
                simSold = "Sold";


            strResult += "<tr>";
            strResult += "<td>" + prodInfo.getProductName() + "</td>";
            strResult += "<td>" + simInfo.getSimCardId() + "</td>";
            strResult += "<td>" + simInfo.getSimCardPin() + "</td>";
            //strResult += "<td>" + simSold + "</td>";
            strResult += "</tr>";
        }

        strResult += "<table>";

        response.setContentType("text/html");
        response.getWriter().println(strResult);
    } catch (Exception e) {
        response.setContentType("text/plain");
        response.getWriter().println("");
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
    