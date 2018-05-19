<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Monthly Customer Sales Report</title>
<script language="javascript" src="/GenericApp/Scripts/Validate.js"></script>
<link rel="stylesheet" href="/GenericApp/Scripts/Print.css" type="text/css" media="print" />
<script language="javascript">

var xmlDoc = null;
var customer_group_list = {};
var customer_list = {};
var supplier_list = {};
var month_name = null;
var year_name = null;
var the_customer_name = null;

function displayReportData(customer)
{
	if (xmlDoc == null) return;
	var customerGroup = document.the_form.customer_group.value;
	customer = document.the_form.customer_name.value;
	the_customer_name = customer;
	var supplier = document.the_form.supplier_name.value;
	if (customerGroup == null || customerGroup.length <= 0) customerGroup = "All";
	if (supplier == null || supplier.length <= 0) supplier = "All";
	if (customer == null || customer.length <= 0) customer = "All";
	if (customer == null || customer.length <= 0) return;
	if (supplier == null || supplier.length <= 0) return;
	var records = xmlDoc.getElementsByTagName("record");
	var total_transactions = 0;
	var total_cards = 0;
	var grand_total_amount = 0;
	var grand_total_price = 0;
	var grand_total_purchase_cost = 0;
	var grand_total_profit = 0;
	var grand_balance = 0;
	var total_non_vat_amount = 0;
	var total_vat = 0;

	var invoice_info = "<center><H3>Invoice for the month of " + month_name + ", " + year_name + "</H3></center>";
	invoice_info += ("<center>" + the_customer_name + "</center><BR>");
	var table_data = "<table width=\"100%\" border=\"1\">";
	table_data += "<tr><td>Customer Group</td><td>Customer</td><td>Supplier</td><td>Product</td><td>Number of Transactions</td>";
	table_data += "<td>Number of Cards</td><td>Total Transaction Amount</td><td>Unit Purchase Price</td>";
	table_data += "<td>Purchase Cost</td><td>Profit</td></tr>";

	var invoice_data = "<table width=\"100%\" border=\"1\">";
	invoice_data += "<tr><td>Product</td><td>Number of Cards</td><td>Amount</td><td>VAT</td>";
	invoice_data += "<td>Total Transaction Amount</td></tr>";

	for (i = 0; i < records.length; i++)
	{
		var supplier_name = records[i].getAttribute("supplier_name");
		var customer_group = records[i].getAttribute("customer_group");
		var customer_name = records[i].getAttribute("customer_name");
		var product_name = records[i].getAttribute("product_name");
		var transactions = records[i].getAttribute("transactions");
		var cards = records[i].getAttribute("cards");
		var total_amount = records[i].getAttribute("total_amount");
		var unitPrice = records[i].getAttribute("unit_price");
		var balance = records[i].getAttribute("balance");
		var purchase_cost = cards * eval(unitPrice);
		var profit = eval(total_amount) - eval(purchase_cost);

		customer_group_list[customer_group] = customer_group;
		supplier_list[supplier_name] = supplier_name;
		customer_list[customer_name] = customer_name;

		if (customerGroup != "All" && customerGroup != customer_group)
			continue;

		if (supplier != "All" && supplier != supplier_name)
			continue;

		if (supplier == "All" && supplier_name == "FNT Logistics ltd")
			continue;
	
		if (customer != "All" && customer != customer_name)
			continue;

		total_transactions = eval(transactions) + total_transactions;
		total_cards = eval(cards) + total_cards;
		grand_total_amount = eval(total_amount) + grand_total_amount;
		grand_total_purchase_cost = eval(purchase_cost) + grand_total_purchase_cost;
		grand_total_profit = eval(profit) + grand_total_profit;
		
		table_data += "<tr>";
		table_data += ("<td>" + customer_group + "</td>");
		table_data += ("<td>" + customer_name + "</td>");
		table_data += ("<td>" + supplier_name + "</td>"); 		
		table_data += ("<td>" + product_name + "</td>");
		table_data += ("<td>" + transactions + "</td>");
		table_data += ("<td>" + cards + "</td>");
		table_data += ("<td>" + eval(total_amount).toFixed(2) + "</td>");
		table_data += ("<td>" + eval(unitPrice).toFixed(2) + "</td>");
		table_data += ("<td>" + eval(purchase_cost).toFixed(2) + "</td>");
		table_data += ("<td>" + eval(profit).toFixed(2) + "</td>");
		table_data += "</tr>";

		invoice_data += "<tr>";
		invoice_data += ("<td>" + product_name + "</td>");
		invoice_data += ("<td>" + cards + "</td>");

		var original_amount = 0;
		var vat_amount = 0;

		if (supplier_name != "FNT Logistics ltd")
		{
			original_amount = eval(total_amount / 1.2);
			vat_amount = eval(total_amount - original_amount);				
		}

		total_non_vat_amount = eval(original_amount) + total_non_vat_amount;
		total_vat = eval(vat_amount) + total_vat;

		invoice_data += ("<td>" + eval(original_amount).toFixed(2) + "</td>");
		invoice_data += ("<td>" + eval(vat_amount).toFixed(2) + "</td>");
		invoice_data += ("<td>" + eval(total_amount).toFixed(2) + "</td>");
		invoice_data += "</tr>";	
	}
	
	table_data += "<tr><td></td><td></td><td></td>";
	table_data += "<td><font color=\"red\">Total</font></td>";
	table_data += ("<td><font color=\"red\">" + total_transactions + "</font></td>");
	table_data += ("<td><font color=\"red\">" + total_cards + "</font></td>");
	table_data += ("<td><font color=\"red\">" + eval(grand_total_amount).toFixed(2) + "</font></td>");
	table_data += ("<td></td>");
	table_data += ("<td><font color=\"red\">" + eval(grand_total_purchase_cost).toFixed(2) + "</font></td>");
	table_data += ("<td><font color=\"red\">" + eval(grand_total_profit).toFixed(2) + "</font></td>");
	table_data += "</table>";

	invoice_data += "<tr>";
	invoice_data += "<td><font color=\"red\">Total</font></td>";
	invoice_data += ("<td><font color=\"red\">" + total_cards + "</font></td>");
	invoice_data += ("<td><font color=\"red\">" + eval(total_non_vat_amount).toFixed(2) + "</font></td>");
	invoice_data += ("<td><font color=\"red\">" + eval(total_vat).toFixed(2) + "</font></td>");
	invoice_data += ("<td><font color=\"red\">" + eval(grand_total_amount).toFixed(2) + "</font></td>");
	invoice_data += "</table>";
	
	document.getElementById("report_data").innerHTML = table_data;
	document.getElementById("report_invoice").innerHTML = invoice_info + invoice_data;
}

function verifyDates()
{
	if (eval(document.the_form.start_year_number.value) == eval(document.the_form.end_year_number.value))
	{
		if (eval(document.the_form.start_month_number.value) > eval(document.the_form.end_month_number.value))
		{
			alert ("Report Start Month must be before or same as Report End Month");
			return false;
		}
	}
	else
	if (eval(document.the_form.start_year_number.value) > eval(document.the_form.end_year_number.value))
	{
		alert ("Report Start Year must be before or same as Report End Year");
		return false;
	}

	return true;
}

function populateXMLData()
{
	if (!verifyDates()) return;
	
	var httpObj = getHttpObject();
	if (httpObj == null)
	{
		alert("Cannot get transaction details");
		return;
	}

	httpObj.onreadystatechange=function()
	{
		if(httpObj.readyState==4)
		{
			xmlDoc = httpObj.responseXML;
			displayReportData("All");

			var element = document.getElementById('customer_group_field_id');
			for (var i = 0; i < element.length; i++)
				element.remove(i);
			element.innerHTML = "";
			var elOption = document.createElement('option');
			elOption.value = "All";
			elOption.innerHTML = "All";
			elOption.selected = true;
			element.appendChild( elOption );

		    for (var key in customer_group_list)
		    {
		    	var elOption1 = document.createElement('option');
				elOption1.value = key;
				elOption1.innerHTML = key;
				element.appendChild( elOption1 );		    	
		    }			

			element = document.getElementById('customer_field_id');
			for (var i = 0; i < element.length; i++)
				element.remove(i);
			element.innerHTML = "";
			elOption = document.createElement('option');
			elOption.value = "All";
			elOption.innerHTML = "All";
			elOption.selected = true;
			element.appendChild( elOption );

		    for (var key in customer_list)
		    {
		    	var elOption1 = document.createElement('option');
				elOption1.value = key;
				elOption1.innerHTML = key;
				element.appendChild( elOption1 );		    	
		    }

			element = document.getElementById('supplier_field_id');
			for (var i = 0; i < element.length; i++)
				element.remove(i);
			element.innerHTML = "";
			elOption = document.createElement('option');
			elOption.value = "All";
			elOption.innerHTML = "All";
			elOption.selected = true;
			element.appendChild( elOption );

		    for (var key in supplier_list)
		    {
		    	var elOption1 = document.createElement('option');
				elOption1.value = key;
				elOption1.innerHTML = key;
				element.appendChild( elOption1 );		    	
		    }		    
		}
	}

	var url = "AJAX_GetMonthlyCustomerSalesReport.jsp?start_year_number=" + 
				document.the_form.start_year_number.value +
				"&start_month_number=" + document.the_form.start_month_number.value +
				"&end_year_number=" + document.the_form.end_year_number.value +
				"&end_month_number=" + document.the_form.end_month_number.value;

	switch(document.the_form.start_month_number.value)
	{
	case "1": month_name = "January"; break;
	case "2": month_name = "February"; break;
	case "3": month_name = "March"; break;
	case "4": month_name = "April"; break;
	case "5": month_name = "May"; break;
	case "6": month_name = "June"; break;
	case "7": month_name = "July"; break;
	case "8": month_name = "August"; break;
	case "9": month_name = "September"; break;
	case "10": month_name = "October"; break;
	case "11": month_name = "November"; break;
	case "12": month_name = "December"; break;
	}
	year_name = document.the_form.start_year_number.value;

	httpObj.open("POST", url, true);
	httpObj.send(null);		
}

</script>
</head>
<body>
<div id="nav">
<form name="the_form" method="post" action="">
<%
Calendar cal = Calendar.getInstance();
int nCurrentYear = cal.get(Calendar.YEAR);
int nPreviousYear = nCurrentYear - 1;
int nMonth = cal.get(Calendar.MONTH);
nMonth += 1;
%>
<table>
<tr>
<td>
Customer Group: <select name="customer_group" id="customer_group_field_id" onchange="displayReportData(this.value)">
</select>
</td>
<td>
Customer : <select name="customer_name" id="customer_field_id" onchange="displayReportData(this.value)">
</select>
</td>
<td>
Supplier : <select name="supplier_name" id="supplier_field_id" onchange="displayReportData()">
</select>
</td>
<td>
Start Year : <select name="start_year_number">
		<option value="<%=nCurrentYear%>" "selected"><%=nCurrentYear%></option>
		<option value="<%=nPreviousYear%>"><%=nPreviousYear%></option>
		</select>
</td>
<td>
Start Month : <select name="start_month_number">
		<option value="1" <%=((nMonth == 1)?"selected":"")%>>January</option>
		<option value="2" <%=((nMonth == 2)?"selected":"")%>>February</option>
		<option value="3" <%=((nMonth == 3)?"selected":"")%>>March</option>
		<option value="4" <%=((nMonth == 4)?"selected":"")%>>April</option>
		<option value="5" <%=((nMonth == 5)?"selected":"")%>>May</option>
		<option value="6" <%=((nMonth == 6)?"selected":"")%>>June</option>
		<option value="7" <%=((nMonth == 7)?"selected":"")%>>July</option>
		<option value="8" <%=((nMonth == 8)?"selected":"")%>>August</option>
		<option value="9" <%=((nMonth == 9)?"selected":"")%>>September</option>
		<option value="10" <%=((nMonth == 10)?"selected":"")%>>October</option>
		<option value="11" <%=((nMonth == 11)?"selected":"")%>>November</option>
		<option value="12" <%=((nMonth == 12)?"selected":"")%>>December</option>		
		</select>
</td>
<td>
End Year : <select name="end_year_number">
		<option value="<%=nCurrentYear%>" selected><%=nCurrentYear%></option>
		<option value="<%=nPreviousYear%>"><%=nPreviousYear%></option>
		</select>
</td>
<td>
End Month : <select name="end_month_number">
		<option value="1" <%=((nMonth == 1)?"selected":"")%>>January</option>
		<option value="2" <%=((nMonth == 2)?"selected":"")%>>February</option>
		<option value="3" <%=((nMonth == 3)?"selected":"")%>>March</option>
		<option value="4" <%=((nMonth == 4)?"selected":"")%>>April</option>
		<option value="5" <%=((nMonth == 5)?"selected":"")%>>May</option>
		<option value="6" <%=((nMonth == 6)?"selected":"")%>>June</option>
		<option value="7" <%=((nMonth == 7)?"selected":"")%>>July</option>
		<option value="8" <%=((nMonth == 8)?"selected":"")%>>August</option>
		<option value="9" <%=((nMonth == 9)?"selected":"")%>>September</option>
		<option value="10" <%=((nMonth == 10)?"selected":"")%>>October</option>
		<option value="11" <%=((nMonth == 11)?"selected":"")%>>November</option>
		<option value="12" <%=((nMonth == 12)?"selected":"")%>>December</option>		
		</select>
</td>
<td>
<input type="button" name="Generate" value="Generate" onClick="populateXMLData()">
</td>
</tr>
</table>
<BR><BR>
<div id="report_data"></div>
<BR><BR>
<a href="MasterInformation.jsp"> Go to Main </a>
</form>
<BR>
<BR>
<BR>
<BR>
<BR>
</div>
<BR><BR>
<div id="report_invoice"></div>
<BR><BR>
</body>
</html>