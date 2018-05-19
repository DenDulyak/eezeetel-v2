<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Customer Day Transaction</title>
<script language="javascript" src="/GenericApp/Scripts/Validate.js"></script>
<script language="javascript">
function update_customer_daily_transaction(isInitialLoad)
{
	var httpObj = getHttpObject();
	if (httpObj == null)
	{
		alert("Cannot get cusomter daily transaction");
		return;
	}

	var cust_id = 0;
	if (!isInitialLoad) 
		cust_id = document.the_form.customer_id.value;

	var element = document.getElementById('customer_daily_transaction');
	element.innerHTML = "";	

	httpObj.onreadystatechange=function()
	{
		if(httpObj.readyState==4)
		{
			element.innerHTML = httpObj.responseText;
		}
	}

	var url = "AJAX_GetCustomerDailySummary.jsp?customer_id=" + cust_id;
	httpObj.open("POST", url, true);
	httpObj.send(null);
}
</script>
</head>
<body onLoad="update_customer_daily_transaction(true)">
<form name="the_form" method="post" action="">
<table>
	<tr>
		<td align="left">
				Customer:
		</td>
		<td align="left">
			<genericappdb:CustomerList name="customer_id" active_records_only="1" initial_option="Select" onChange="update_customer_daily_transaction(false)"/>
		</td>
		<td><a href=MasterInformation.jsp> Go to Main </a></td>		
	</tr>
</table>
	<div id="customer_daily_transaction"></div>
</form>
</body>
</html>