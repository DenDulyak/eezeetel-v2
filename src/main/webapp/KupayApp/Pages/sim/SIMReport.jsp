<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../imports.jsp"%>
<%@ include file="../SessionCheck.jsp"%>

<%
response.addHeader("Pragma", "no-cache");
response.addHeader("Expires", "-1");

Session theSession = null;
int nForYear = 0;
int nForMonth = 0;
int nCustomerID = 0;
try
{
	String strHowManyMonthsBack = request.getParameter("previous_month");
	int nPrevMonth = 0;
	if (strHowManyMonthsBack != null && !strHowManyMonthsBack.isEmpty())
	{
		try
		{
			nPrevMonth = Integer.parseInt(strHowManyMonthsBack);
		}
		catch (NumberFormatException nfe)
		{
			nPrevMonth = 0;
		}
	}
	
	if (nPrevMonth > 4 || nPrevMonth < 0) nPrevMonth = 0;
	
	SessionFactory sessionFactory = HibernateUtil.getSessionFactory(strCountryCode);
	theSession = sessionFactory.getCurrentSession();
	String strUserId = (String)request.getRemoteUser();

	if (!strUserId.isEmpty())
	{
		theSession.beginTransaction();

		String strQuery = "from TCustomerUsers where User_Login_ID = '" + request.getRemoteUser() + "'";
		Query query = theSession.createQuery(strQuery);
		List customer = query.list();
		if (customer.size() > 0)
		{
			TCustomerUsers custUsers = (TCustomerUsers) customer.get(0);
			TMasterCustomerinfo custInfo = custUsers.getTMasterCustomerinfo();
			User theUser = custUsers.getUser();
			if (custInfo.getActiveStatus() == 1 && theUser.getUserActiveStatus() == 1)
				nCustomerID = custInfo.getCustomerId();
			else
				custInfo = null;
		}
	}
	
	if (nCustomerID <= 0)
	{
		theSession.getTransaction().commit();
		response.sendRedirect(ksContext + "/Pages/ShowProducts.jsp");
		return;		
	}
	
	// duration
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.MONTH, -1 * nPrevMonth);
    
    nForYear = cal.get(Calendar.YEAR);
    nForMonth = cal.get(Calendar.MONTH);
}
catch(Exception e)
{
	if (theSession != null)
		theSession.getTransaction().rollback();
}    
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="<%=ksContext%>/Scripts/Print.css" type="text/css" media="print" />
<style type="text/css">
table {font-weight:bold}
</style>
<title>Commission Report</title>
</head>
<body>

<%
String[] months = {"January", "February",
		  "March", "April", "May", "June", "July",
		  "August", "September", "October", "November",
		  "December"};

Calendar calNew = Calendar.getInstance();
String currentMonth = months[calNew.get(Calendar.MONTH)] + ", " + calNew.get(Calendar.YEAR);
calNew.add(Calendar.MONTH, -1);
String firstPreviousMonth = months[calNew.get(Calendar.MONTH)] + ", " + calNew.get(Calendar.YEAR);
calNew.add(Calendar.MONTH, -1);
String secondPreviousMonth = months[calNew.get(Calendar.MONTH)] + ", " + calNew.get(Calendar.YEAR);
calNew.add(Calendar.MONTH, -1);
String thirdPreviousMonth = months[calNew.get(Calendar.MONTH)] + ", " + calNew.get(Calendar.YEAR);
calNew.add(Calendar.MONTH, -1);
String fourthPreviousMonth = months[calNew.get(Calendar.MONTH)] + ", " + calNew.get(Calendar.YEAR);
%>
<div id="nav">
<a href="<%=ksContext%>/Pages/sim/SIMReport.jsp"><%=currentMonth%></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="<%=ksContext%>/Pages/sim/SIMReport.jsp?previous_month=1"><%=firstPreviousMonth%></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="<%=ksContext%>/Pages/sim/SIMReport.jsp?previous_month=2"><%=secondPreviousMonth%></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="<%=ksContext%>/Pages/sim/SIMReport.jsp?previous_month=3"><%=thirdPreviousMonth%></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="<%=ksContext%>/Pages/sim/SIMReport.jsp?previous_month=4"><%=fourthPreviousMonth%></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="<%=ksContext%>/Pages/ShowProducts.jsp">Show Products</a>
<hr>
</div>

<%
GenerateOldInvoices invoices = new GenerateOldInvoices();
invoices.setCountry(strCountryCode);
invoices.setDuration(nForYear, nForMonth, nForYear, nForMonth);
invoices.setCustomerID(nCustomerID);
invoices.setGenerateHTMLOutput(true);
invoices.createSIMInvoiceReport();
%>

<%=invoices.m_strInvoiceReport%>

</body>
</html>