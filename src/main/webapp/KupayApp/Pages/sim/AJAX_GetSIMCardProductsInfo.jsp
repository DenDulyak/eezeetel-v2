<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../imports.jsp"%>
<%@ include file="../SessionCheck.jsp"%>

<%
Session theSession = null;
try
{
	String strSupplierID = request.getParameter("supplier_id");
	
	SessionFactory sessionFactory = HibernateUtil.getSessionFactory(strCountryCode);
	theSession = sessionFactory.getCurrentSession();
	theSession.beginTransaction();

	int nCustomerID = 0;
	String strQuery = "from TCustomerUsers where User_Login_ID = '" + request.getRemoteUser() + "'";

	Query query = theSession.createQuery(strQuery);
	List customer = query.list();
	if (customer.size() > 0)
	{
		TCustomerUsers custUsers = (TCustomerUsers) customer.get(0);
		TMasterCustomerinfo theCustomer = custUsers.getTMasterCustomerinfo();
		User theUser = custUsers.getUser();
		if (theCustomer.getActiveStatus() == 1 && theUser.getUserActiveStatus() == 1)
			nCustomerID = theCustomer.getCustomerId();
	}
	
	if (nCustomerID == 0)
	{
		theSession.getTransaction().commit();
		response.setContentType("text/plain");
		response.getWriter().println("");
		return;	
	}

	strQuery = "from TMasterProductinfo where Product_Type_ID = 17 and Product_Active_Status = 1 " +
				" and Supplier_ID = " + strSupplierID +
				" order by Product_Face_Value, Product_Name";
	
	query = theSession.createQuery(strQuery);
	List records = query.list();

	String strResult = "<table width=\"100%\">";
	for (int i = 0, nDisplayedCards = 0; i < records.size(); i++)
	{
		TMasterProductinfo prodInfo = (TMasterProductinfo) records.get(i);
		int nProductID = prodInfo.getProductId();
		String strProductName = prodInfo.getProductName();
		Float strFaceValue = prodInfo.getProductFaceValue();

		strQuery = "from TSimCardsInfo where Product_ID = " + nProductID +
					 " and Customer_ID = " + nCustomerID + " and Is_Sold = 0";
		
		query = theSession.createQuery(strQuery);
		List availablesimslist = query.list();
		if (availablesimslist == null || availablesimslist.size() <= 0) continue;
		
		TSimCardsInfo simCardInfo = (TSimCardsInfo) availablesimslist.get(0);
		TBatchInformation batchInfo = simCardInfo.getTBatchInformation();
		
		String imgFile = batchInfo.getTMasterProductsaleinfo().getProductImageFile();
		if (imgFile == null || imgFile.isEmpty() || imgFile.compareToIgnoreCase("null") == 0)
			imgFile = "";

		if ((nDisplayedCards % 4) == 0)
		{
			if (nDisplayedCards != 0)
				strResult += "</tr>";
			strResult += "<tr>";
		}
		strResult += "<td>";

		String oneEntry = "<table cellpadding=\"10\"><tr>";
		oneEntry += "<td valign=\"bottom\" align=\"center\" nowrap onmouseover=\"this.className='highlight'\"" + " onmouseout=\"this.className='product_normal'\">";
		oneEntry += "<input width=170 height=100 type=\"image\" src=\"" + imgFile + "\"" +
					" onClick=\"return do_sim_transaction(" + nProductID + ")\"" +
					" alt=\"" + strProductName + " - " + strFaceValue + "\"" + "/></td></tr>";

		oneEntry += "<tr><td valign=\"top\" align=\"left\">Select: <select name=\"" + nProductID + "\">";
		oneEntry += ("<option value=0 selected>New Phone Number</option>");
		for (int n = 0; n < availablesimslist.size(); n++)
		{
			simCardInfo = (TSimCardsInfo) availablesimslist.get(n);
			oneEntry += ("<option value=" + simCardInfo.getSequenceId() + ">" + simCardInfo.getSimCardPin() + "</option>");
		}
		oneEntry += "</select></td></tr>";					

		oneEntry += "</table>";
		
		strResult += oneEntry;
		
		strResult += "</td>";
		if ((nDisplayedCards + 1 == records.size()))
			strResult += "</tr>";
		nDisplayedCards++;
	}
		
	strResult += "</table>";
	
	theSession.getTransaction().commit();	
	
	response.setContentType("text/plain");
	response.getWriter().println(strResult);
}
catch(Exception e)
{
	e.printStackTrace();
	if (theSession != null)
		theSession.getTransaction().rollback();
	
	response.setContentType("text/plain");
	response.getWriter().println("");	
}
%>

