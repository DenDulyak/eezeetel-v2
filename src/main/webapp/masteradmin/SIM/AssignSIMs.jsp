<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>
<%@ page import="java.text.SimpleDateFormat" %>

<%
String strQuery = "from TMasterCustomerGroups where IsActive = 1 order by Customer_Group_Name";
Session theSession= null;
try
{
%> 

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Assign SIMS to Customer groups</title>
<script language="javascript" src="/js/validate.js"></script>
<script language="javascript">

function ValidateAndSubmit()
{
	if (document.the_form.customer_group_id.value <= 0)
	{
		alert("Please select a customer group.");
		return;
	}

	if (document.the_form.product_id.value <= 0)
	{
		alert("Please select a product.");
		return;
	}
	if (document.the_form.available_quantity.value <= 0)
	{
		alert("Selected product is not available.");
		return;
	}
	if (document.the_form.required_quantity.value <= 0)
	{
		alert("Please enter quantity to be assigned to this customer.");
		return;
	}

	document.the_form.action = "/masteradmin/SIM/AllocateSIMs.jsp";
	document.the_form.submit();		
}

function UnAssignSubmit()
{
	if (document.the_form.customer_group_id.value <= 0)
	{
		alert("Please select a customer group.");
		return;
	}

	if (document.the_form.product_id.value <= 0)
	{
		alert("Please select a product.");
		return;
	}

	document.the_form.action = "/masteradmin/SIM/UnAssignSIMs.jsp";
	document.the_form.submit();	
}

function getAvailableQuantity()
{
	if (document.the_form.product_id.value <= 0)
		document.the_form.available_quantity.value = "";
	
	var httpObj = getHttpObject();
	if (httpObj == null)
	{
		alert("Cannot get available SIMs information");
		return;
	}

	httpObj.onreadystatechange=function()
	{
		document.the_form.available_quantity.value = "";

		if(httpObj.readyState==4)
		{
			document.the_form.available_quantity.value = httpObj.responseText;
			
			httpObj = null;
		}
	};

	var url = "/masteradmin/SIM/AJAX_GetAvailableSIMQuantity.jsp?product_id=" + document.the_form.product_id.value;

	httpObj.open("POST", url, true);
	httpObj.send(null);		
}
</script>
</head>
<body>
<form name="the_form" method="post" action="">
<a href="/masteradmin/MasterInformation.jsp"> Go to Main </a>
<table width="50%">
<tr>
	<td align="right">
		Customer Group :
	</td>
	<td align="left">
		<select name="customer_group_id">
			<option value="0">Select</option>
<%
	theSession = HibernateUtil.openSession();

	Query query = theSession.createQuery(strQuery);
	List records = query.list();	
	
	for (int nIndex = 0; nIndex < records.size(); nIndex++)
	{
		TMasterCustomerGroups custGroupInfo = (TMasterCustomerGroups) records.get(nIndex);
%>		
			<option value="<%=custGroupInfo.getId()%>"><%=custGroupInfo.getName()%></option>
<%
	}
%>		
		</select>
	</td>
</tr>
<tr>
	<td align="right">
		Product:
	</td>
	<td align="left">
		<select name="product_id" onChange="getAvailableQuantity()">
			<option value="0">Select</option>
<%
	strQuery = "from TMasterProductinfo where Product_Type_ID = 17 and Product_Active_Status = 1 " + 
					" order by Product_Name";
	query = theSession.createQuery(strQuery);
	records = query.list();	
	
	for (int nIndex = 0; nIndex < records.size(); nIndex++)
	{
		TMasterProductinfo prodInfo = (TMasterProductinfo) records.get(nIndex);
%>		
			<option value="<%=prodInfo.getId()%>"><%=prodInfo.getProductName()%></option>
<%
	}
%>
		</select>
	</td>
</tr>
<tr>
	<td align="right">
		Available Quantity:
	</td>
	<td align="left">
		<input type="text" name="available_quantity" id="available_quantity_id" size="3" readonly/>
	</td>
</tr>
<tr>
	<td align="right">
		Required Quantity:
	</td>
	<td align="left">
		<input type="text" name="required_quantity" size="3" maxlength="2"/>
	</td>
</tr>
<tr>
<td> </td>
<td><input type="button" name="assign_button" value="Assign New SIMs to Group" onClick="ValidateAndSubmit()"></td>
<td><input type="button" name="un_assign_button" value="Un-Assign SIMs from Group" onClick="UnAssignSubmit()"></td>
</table>
</form>
<a href="/masteradmin/MasterInformation.jsp"> Go to Main </a>
</body>
</html>
<%
} catch(Exception e) {
	e.printStackTrace();
} finally {
	HibernateUtil.closeSession(theSession);
}
%>