<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<html>
<head>
    <link rel="stylesheet" href="/css/print.css" type="text/css" media="print"/>
</head>
<body>
<div id="nav">
    <a href="/admin/Products/AssignSIMs.jsp">Assign SIMs</a>
    <br>
    <br>
    <br>
</div>
<%
    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
    String strCustomerGroups = "" + nCustomerGroupID;
    if (nCustomerGroupID == 5)
        strCustomerGroups += ", 1";
    Session theSession = null;
    try {
        String strCustomerID = request.getParameter("customer_id");
        String strProductID = request.getParameter("product_id");
        String strSIMCardIDs = request.getParameter("final_assign_list");

        int nCustomerID = 0;
        int nProductID = 0;

        if (strCustomerID != null && !strCustomerID.isEmpty())
            nCustomerID = Integer.parseInt(strCustomerID);

        if (strProductID != null && !strProductID.isEmpty())
            nProductID = Integer.parseInt(strProductID);

        if (nCustomerID <= 0 || nProductID <= 0 || strSIMCardIDs == null || strSIMCardIDs.isEmpty()) {
            String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Please select SIMS to assign.</FONT></H4>" +
                    "<A HREF=\"/admin/Products/AssignSIMs.jsp\">Assign SIMs</A></BODY></HTML>";
            response.getWriter().println(strError);

            return;
        }

        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        String strCustomerName = "None";
        String strAddress = "";

        String strQuery = "from TMasterCustomerinfo where Customer_ID = " + nCustomerID +
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

        strQuery = "from TSimCardsInfo qc1 where Product_ID = " + nProductID + " and Customer_Group_ID in ( " +
                strCustomerGroups + ") and Is_Sold = 0 and Customer_ID = 0 and SequenceID in (" + strSIMCardIDs + ")"
                + " order by Batch_Sequence_ID, SequenceID";

        query = theSession.createQuery(strQuery);
        query.setLockMode("qc1", LockMode.UPGRADE);
        List simCards = query.list();
%>

<center><h2>Sim Delivery Note for <%=strCustomerName%>
</h2></center>
<center><%=strAddress%>
</center>
<br>

<table border="1" width="100%">
    <tr>
        <th align="left">Product</th>
        <th align="left">Batch Number</th>
        <th align="left">Phone Number</th>

            <%

	for (int i = 0; i < simCards.size(); i++)
	{
		TSimCardsInfo simCardInfo = (TSimCardsInfo) simCards.get(i);
		TMasterProductinfo prodInfo = simCardInfo.getProduct();
		simCardInfo.setCustomerId(nCustomerID);
		simCardInfo.setIsSold(true);
		theSession.save(simCardInfo);
		theSession.flush();
%>
    <tr>
        <td><%=prodInfo.getProductName()%>
        </td>
        <td><%=simCardInfo.getSimCardId()%>
        </td>
        <td><%=simCardInfo.getSimCardPin()%>
        </td>
    </tr>
    <%
            }

            theSession.getTransaction().commit();
        } catch (Exception e) {
            if (theSession != null)
                theSession.getTransaction().rollback();

            String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">FAILED to allocate SIMS.  Please try again.</FONT></H4>" +
                    "<A HREF=\"/admin/Products/AssignSIMs.jsp\">Assign SIMs</A></BODY></HTML>";
            response.getWriter().println(strError);
        } finally {
            HibernateUtil.closeSession(theSession);
        }
    %>

</table>
<div id="nav">
    <br>
    <a href="/admin/Products/AssignSIMs.jsp">Assign SIMs</a>
</div>
</body>
</html>