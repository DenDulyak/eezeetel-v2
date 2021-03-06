<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="../imports.jsp"%>
<%@ include file="../SessionCheck.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Attach mobile topup transaction</title>
</head>
<body>
<%
	response.addHeader("Pragma", "no-cache");
	response.addHeader("Expires", "-1");
	
	String strText = "<h3><font color=\"red\"></font></h3>";

	long nTransactionID = 0;
	String strTransactionID = request.getParameter("transaction_number");
	if (strTransactionID != null && !strTransactionID.isEmpty())
		nTransactionID = Long.parseLong(strTransactionID);

	if (nTransactionID <= 0)
	{
%>
		<h3><font color="red">Not a valid transaction number.  Please enter or select a valid mobile topup transaction number to attach.</font></h3>
		<br>
		<a href="<%=ksContext%>/Pages/ListTransactions.jsp"> Try Again </a>		
		</body>
		</html>
<%
		return;
	}
		
	String strMobileNumber = request.getParameter("mobile_number");
	if (strMobileNumber == null || strMobileNumber.isEmpty())
	{
%>
		<h3><font color="red">Not a valid mobile number.  Please enter a valid mobile number to attach.</font></h3>
		<br>
		<a href="<%=ksContext%>/Pages/ListTransactions.jsp"> Try Again </a>		
		</body>
		</html>
<%
		return;
	}
%>	

<%
	String strQuery = "from TTransactions where Transaction_ID = " + nTransactionID + " and Committed = 1 order by Sequence_ID";
	Session theSession= null;

	try
	{
		SessionFactory sessionFactory = HibernateUtil.getSessionFactory(strCountryCode);
		theSession = sessionFactory.getCurrentSession();
		theSession.beginTransaction();
		
		strQuery = "from TTransactions where Transaction_ID = " + nTransactionID + "  and Committed = 1  order by Sequence_ID";
		Query query = theSession.createQuery(strQuery);
		List records = query.list();
		if (records.size() <= 0)
		{
			strQuery = "select * from t_history_transactions where Transaction_ID = " + nTransactionID + "  and Committed = 1  order by Sequence_ID";
			SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
			sqlQuery.addEntity(TTransactions.class);
			records = sqlQuery.list();
		}
		
		if (records.size() <= 0)
		{
%>
			<h3><font color="red">Not a valid transaction number.  Please enter or select a valid mobile topup transaction number to attach.</font></h3>
			<br>
			<a href="<%=ksContext%>/Pages/ListTransactions.jsp"> Try Again </a>			
			</body>
			</html>
<%
			theSession.getTransaction().commit();
			return;
		}

		TTransactions transactionRecord = (TTransactions) records.get(0);
		TMasterCustomerinfo custInfo = transactionRecord.getTMasterCustomerinfo();
		Set custUsers = custInfo.getTCustomerUserses();
			
		boolean transactionBelongsToCustomer = false;
		Object users[] = custUsers.toArray();
		for (int k = 0; k < users.length; k++)
		{
			User theUser = ((TCustomerUsers) users[k]).getUser();
			if (theUser.getUserLoginId().compareToIgnoreCase(request.getRemoteUser()) == 0)
				transactionBelongsToCustomer = true;
		}

		if (!transactionBelongsToCustomer)
		{
%>
			<h3><font color="red">Not a valid transaction number.  Please enter or select a valid mobile topup transaction number to attach.</font></h3>
			<br>
			<a href="<%=ksContext%>/Pages/ListTransactions.jsp"> Try Again </a>
			</body>
			</html>
<%
			theSession.getTransaction().commit();
			return;
		}

		TMasterProductinfo prodInfo = transactionRecord.getTMasterProductinfo();
		if (prodInfo.getTMasterSupplierinfo().getTMasterSuppliertype().getSupplierTypeId() != 16)
		{
%>
			<h3><font color="red">Not a valid mobile topup transaction number.  Please enter or select a valid mobile topup transaction number to attach.</font></h3>
			<br>
			<a href="<%=ksContext%>/Pages/ListTransactions.jsp"> Try Again </a>			
			</body>
			</html>
<%
			theSession.getTransaction().commit();
			return;
		}

		strQuery = "from TSimCardsInfo where Is_Sold = 1 and sim_card_pin = '" + strMobileNumber + "'";
		query = theSession.createQuery(strQuery);
		records = query.list();

		if (records.size() <= 0)
		{
%>
			<h3><font color="red">Not a valid mobile number.  Please enter a valid mobile number to attach.</font></h3>
			<br>
			<a href="<%=ksContext%>/Pages/ListTransactions.jsp"> Try Again </a>			
			</body>
			</html>
<%
			theSession.getTransaction().commit();
			return;
		}

		TSimCardsInfo simCardInfo = (TSimCardsInfo) records.get(0);
		if (simCardInfo.getRemainingTopups() <= 0)
		{
%>
			<h3><font color="red">Maximum topups have already been reached for this mobile number.</font></h3>
			<br>
			<a href="<%=ksContext%>/Pages/ListTransactions.jsp"> Try Again </a>			
			</body>
			</html>
<%
			theSession.getTransaction().commit();
			return;
		}

		strQuery = "select * from t_sim_card_mobile_vouchers_mapping where SIM_Product_ID = " + simCardInfo.getTMasterProductinfo().getProductId() +
						" and Mobile_Voucher_Product_ID = " + transactionRecord.getTMasterProductinfo().getProductId();
		SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
		records = sqlQuery.list();
		if (records.size() <= 0)
		{
%>
			<h3><font color="red">The mobile topup is not for the Mobile number you entered.  Please enter or select a correct mobile topup to attach.</font></h3>
			<br>
			<a href="<%=ksContext%>/Pages/ListTransactions.jsp"> Try Again </a>
			</body>
			</html>
<%
			theSession.getTransaction().commit();
			return;
		}

		strQuery = "from TSimTransactions where Mobile_Topup_Transaction_ID = " + nTransactionID;
		query = theSession.createQuery(strQuery);
		records = query.list();
		if (records.size() > 0)
		{
%>
			<h3><font color="red">The mobile topup transaction <%=nTransactionID%> has already been attached.</font></h3>
			<br>
			<a href="<%=ksContext%>/Pages/ListTransactions.jsp"> Try Again </a>			
			</body>
			</html>
<%
			theSession.getTransaction().commit();
			return;
		}

		theSession.getTransaction().commit();

		ProcessTransaction processTran = new ProcessTransaction();
		processTran.setCountry(strCountryCode);
		boolean bSuccess = processTran.attachMobileTopupTransaction(custInfo.getCustomerId(), 
												custInfo.getTMasterCustomerGroups().getCustomerGroupId(), 
												request.getRemoteUser(), simCardInfo.getSequenceId(), nTransactionID);
		if (bSuccess)
		{
%>
			<h1><font color="blue">Successfully attached the mobile topup transaction.</font></h1>
			<br>
			<a href="<%=ksContext%>/Pages/ShowProducts.jsp"> Show Products </a>
<%
		}
		else
		{
%>
			<h3><font color="red">Failed to attach mobile topup transaction.  Please try again.</font></h3>
			<br>
			<a href="<%=ksContext%>/Pages/ListTransactions.jsp"> Try Again </a>			
<%			
		}
	}
	catch(Exception e)
	{
		if (theSession != null)
			theSession.getTransaction().rollback();
%>
		<br>
		<a href="<%=ksContext%>/Pages/ListTransactions.jsp"> Try Again </a>
<%		
	}
%>
</body>
</html>