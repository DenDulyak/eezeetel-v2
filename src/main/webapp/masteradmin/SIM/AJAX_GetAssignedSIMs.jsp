<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>

<%
String strGroupID = request.getParameter("group_id");
if (strGroupID == null || strGroupID.isEmpty())
{
	response.setContentType("text/plain");
	response.getWriter().println("");
	return;	
}

String strProductID = request.getParameter("product_id");
if (strProductID == null || strProductID.isEmpty())
{
	response.setContentType("text/plain");
	response.getWriter().println("");
	return;
}

String strSoldOrUnSold = request.getParameter("sold_or_unsold");
if (strSoldOrUnSold == null || strSoldOrUnSold.isEmpty())
{
	response.setContentType("text/plain");
	response.getWriter().println("");
	return;
}

String soldOrUnsoldPart = "";
if (Integer.parseInt(strSoldOrUnSold) != 2)
	soldOrUnsoldPart = " and Is_Sold = " + Integer.parseInt(strSoldOrUnSold);

Session theSession= null;

try {
	theSession = HibernateUtil.openSession();
	Integer nProductID = Integer.parseInt(strProductID);
	Integer nCustomerGroupID = Integer.parseInt(strGroupID);

	String strQuery = "from TMasterCustomerGroups where Customer_Group_ID = " + nCustomerGroupID;
	Query query = theSession.createQuery(strQuery);
	List custGroups = query.list();
	
	String strCustomerGroupName = "";
	if (custGroups.size() > 0) {
		TMasterCustomerGroups custGroup = (TMasterCustomerGroups) custGroups.get(0);
		strCustomerGroupName = custGroup.getName();
	}
		
	strQuery = "from TSimCardsInfo where Customer_Group_ID = " + nCustomerGroupID + soldOrUnsoldPart;
	if (nProductID > 0)
		strQuery += " and Product_ID = " + nProductID;
	strQuery += " order by Product_ID, Is_Sold";

	query = theSession.createQuery(strQuery);
	List records = query.list();
	
	String strResult = "<center><h2>Sim Delivery Note for " + strCustomerGroupName + "</h2></center><br><br><table width=\"100%\">";
	strResult += "<tr><th align=\"left\">Product</th><th align=\"left\">Batch Number</th><th align=\"left\">Phone Number</th><th align=\"left\">Status</th><th align=\"left\">Allotted To</th></tr>";

	for (int nSim = 0; nSim < records.size(); nSim++) {
		TSimCardsInfo simInfo = (TSimCardsInfo) records.get(nSim);
		TMasterProductinfo prodInfo = simInfo.getProduct();

		String simSold = "Available";
		if (simInfo.getIsSold())
			simSold = "Sold";
		
		String strCustomerName = "None";
		
		if (simInfo.getCustomerId() != null && simInfo.getCustomerId() > 0) {
			strQuery = "from TMasterCustomerinfo where Customer_ID = " + simInfo.getCustomerId();
			query = theSession.createQuery(strQuery);
			List customers = query.list();
	
			if (customers.size() > 0)
			{
				TMasterCustomerinfo cust = (TMasterCustomerinfo) customers.get(0);
				strCustomerName = cust.getCompanyName();
			}
		}
		
		strResult += "<tr>";
		strResult += "<td>" + prodInfo.getProductName() + "</td>";
		strResult += "<td>" + simInfo.getSimCardId() + "</td>";
		strResult += "<td>" + simInfo.getSimCardPin() + "</td>";
		strResult += "<td>" + simSold + "</td>";
		strResult += "<td>" + strCustomerName + "</td>";
		strResult += "</tr>";
	}
	
	strResult += "<table>";	
	
	response.setContentType("text/html");
	response.getWriter().println(strResult);
} catch(Exception e) {
	response.setContentType("text/plain");
	response.getWriter().println("");
	e.printStackTrace();
} finally {
	HibernateUtil.closeSession(theSession);
}
%>
    