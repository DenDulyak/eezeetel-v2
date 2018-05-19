<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../imports.jsp"%>
<%@ include file="../SessionCheck.jsp"%>

<%
response.addHeader("Pragma", "no-cache");
response.addHeader("Expires", "-1");
String userAgent = request.getHeader("User-Agent");

boolean bAutoPrint = true;
if (userAgent.compareToIgnoreCase("CallingCardsApp") == 0)
	bAutoPrint = false;	
%>

<html>
<head>
<link rel="stylesheet" href="<%=ksContext%>/Scripts/Print.css" type="text/css" media="print" />
<STYLE TYPE='text/css'>
P.pagebreakhere {page-break-before: always}
td.font_style
{
font-family:"Verdana";
font-weight:bolder;
font-size:14px;
}
</STYLE>
<script language="javascript">
function pausecomp(milsec)
{
	milsec += new Date().getTime();
	while (new Date() < milsec){}
	window.location.href="<%=ksContext%>/Pages/ShowProducts.jsp";
}

function PrintPage()
{
<%
	if (userAgent.contains("Chrome/"))
	{
%>
		window.print();
		setTimeout("pausecomp(5000)",5000);
<%
	}
	else
	{
%>
		window.location.href="<%=ksContext%>/Pages/ShowProducts.jsp";
		window.print();
<%		
	}
%>
}
<%
if (bAutoPrint)
{
%>
window.onload = PrintPage;
<%
}
%>
</script>
</head>
<body>

<%
Session theSession = null;
try
{
	SessionFactory sessionFactory = HibernateUtil.getSessionFactory(strCountryCode);
	theSession = sessionFactory.getCurrentSession();
	theSession.beginTransaction();

	int nCustomerID = 0;
	int nCustomerGroupID = 0;
	TMasterCustomerinfo theCustomer = null;
	String strQuery = "from TCustomerUsers where User_Login_ID = '" + request.getRemoteUser() + "'";

	Query query = theSession.createQuery(strQuery);
	List customer = query.list();
	if (customer.size() > 0)
	{
		TCustomerUsers custUsers = (TCustomerUsers) customer.get(0);
		theCustomer = custUsers.getTMasterCustomerinfo();
		TMasterCustomerGroups custGroup = theCustomer.getTMasterCustomerGroups();
		User theUser = custUsers.getUser();
		if (theCustomer.getActiveStatus() == 1 && theUser.getUserActiveStatus() == 1)
			nCustomerID = theCustomer.getCustomerId();
		if (custGroup.getIsActive() == 1)
			nCustomerGroupID = custGroup.getCustomerGroupId();
	}

	if (nCustomerID == 0 || nCustomerGroupID == 0)
	{
		theSession.getTransaction().commit();
%>
		<h4><font color="red">Failed to complete SIM Card Transaction</font></h4>
		</body>
		</html>
<%
		return;	
	}

	String strSIMID = request.getParameter("sim_sequence_id");
	Long nSimSequenceID = Long.parseLong(strSIMID);
	strQuery = "from TSimCardsInfo where SequenceID = " + nSimSequenceID +
					 " and Customer_ID = " + nCustomerID + " and Is_Sold = 0";

	query = theSession.createQuery(strQuery);
	List records = query.list();
	
	if (records == null || records.size() <= 0)
	{
		theSession.getTransaction().commit();
%>
		<h4><font color="red">Failed to complete SIM Card Transaction</font></h4>
		</body>
		</html>
<%
		return;	
	}
	
	TSimCardsInfo simCardInfo = (TSimCardsInfo) records.get(0);
	ArrayList<String> topupTransactions = new ArrayList<String>();
	for (int i = 0; i < simCardInfo.getMaxTopups(); i++)
	{
		String strID = "mob_topup_" + (i + 1);
		String strTopupTran = request.getParameter(strID);
		if (strTopupTran == null || strTopupTran.isEmpty())
			break;
		topupTransactions.add(strTopupTran);
	}

	theSession.getTransaction().commit();

	ProcessTransaction processTrans = new ProcessTransaction();
	processTrans.setCountry(strCountryCode);
	if (processTrans.processSIMCardTransaction(nCustomerID, nCustomerGroupID, request.getRemoteUser(), nSimSequenceID, topupTransactions))
	{
		theSession = sessionFactory.getCurrentSession();
		theSession.beginTransaction();
		strQuery = "from TSimTransactions where Transaction_ID = " + processTrans.m_nTransactionID + " order by SequenceId";
		query = theSession.createQuery(strQuery);
		records = query.list();
		TSimTransactions simTran = (TSimTransactions) records.get(0);
		int nTotalTopups = records.size() - 1;
		TMasterProductinfo prodInfo = simTran.getTSimCardsInfo().getTMasterProductinfo();

		String strProductID = "";
		if (!bAutoPrint)
			strProductID = "<tr><td align=\"left\"><u><b>Product ID : " + prodInfo.getProductId() + "</b></u></td></tr>";
%>
		<%
		if (nTotalTopups != topupTransactions.size())
		{
		%>
			<script language="javascript">
				alert("Not all mobile topups have been attached.  Please do it separately.");
			</script>
		<%
		}
		%>

		<table>
			<tr><td align="left"><b><%=theCustomer.getCustomerCompanyName()%></b></td></tr>
			<tr><td align="left"><b>Transaction Number : <%=processTrans.m_nTransactionID%></b></td></tr>
			<tr><td align="left"><b><%=simTran.getTransactionTime()%></b></td></tr>
			<tr><td align="left"><u><b><%=prodInfo.getProductName()%></b></u></td></tr>
			<%=strProductID%>
			<tr><td align="left"><u><b>New Mobile Number: <%=simCardInfo.getSimCardPin()%></b></u></td></tr>
			<tr><td align="left"><u><b>Total Topups: <%=nTotalTopups%></b></u></td></tr>
		</table>
		
		<div id="nav">	
			<br>
			<a href="<%=ksContext%>/Pages/ShowProducts.jsp"> Show Products </a>
		</div>
<%
	}
	else
	{
		if (processTrans.m_nTransactionID == 0)
		{
%>		
			<h4><font color="red">Failed to complete SIM Card Transaction</font></h4>
<%
		}
%>
			<br>
			<a href="<%=ksContext%>/Pages/ShowProducts.jsp"> Show Products </a>
<%
	}
}
catch(Exception e)
{
	if (theSession != null)
		theSession.getTransaction().rollback();
%>
	<h4><font color="red">Failed to complete SIM Card Transaction</font></h4>
<%
}	
%>

</body>
</html>
