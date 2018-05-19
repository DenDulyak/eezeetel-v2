<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Monthly Customer Sales Report</title>
<script language="javascript" src="/GenericApp/Scripts/Validate.js"></script>
<script language="javascript">

var xmlDoc = null;
var customer_list = {};

function displayReportData(customer)
{
	if (xmlDoc == null) return;
	if (customer == null || customer.length <= 0) return;
	var records = xmlDoc.getElementsByTagName("record");
	var total_payment = 0;
	
	var table_data = "<table width=\"100%\" border=\"1\">";
	table_data += "<tr><td>Customer</td><td>Payment Type</td><td>Payment Details</td>";
	table_data += "<td>Payment Amount</td><td>Payment Date</td></tr>";

	for (i = 0; i < records.length; i++)
	{
		var company_name = records[i].getAttribute("company_name");
		var payment_type = records[i].getAttribute("payment_type");
		var payment_details = records[i].getAttribute("payment_details");
		var payment_amount = records[i].getAttribute("payment_amount");
		var payment_date = records[i].getAttribute("payment_date");

		customer_list[company_name] = company_name;

		if (customer != "All" && customer != company_name)
			continue;

		total_payment = eval(payment_amount) + total_payment;

		if (payment_type == 1) payment_type = "Cash";
		if (payment_type == 2) payment_type = "Cheque";
		if (payment_type == 3) payment_type = "Bank Deposit";
		if (payment_type == 4) payment_type = "Funds Transfer";
		if (payment_type == 5) payment_type = "Debit / Credit Card";

		table_data += "<tr>";
		table_data += ("<td>" + company_name + "</td>"); 
		table_data += ("<td>" + payment_type + "</td>");
		table_data += ("<td>" + payment_details + "</td>");
		table_data += ("<td>" + payment_amount + "</td>");
		table_data += ("<td>" + payment_date + "</td>");
		table_data += "</tr>";
	}
	table_data += "<tr><td></td><td></td>";
	table_data += "<td><font color=\"red\">Total</font></td>";
	table_data += ("<td><font color=\"red\">" + eval(total_payment).toFixed(2) + "</font></td>");
	table_data += "</tr></table>"; 
	document.getElementById("report_data").innerHTML = table_data;
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

			var element = document.getElementById('customer_field_id');
			for (var i = 0; i < element.length; i++)
				element.remove(i);
			element.innerHTML = "";
			var elOption = document.createElement('option');
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
		}
	}

	var url = "AJAX_GetMonthlyCustomerCredit.jsp?start_year_number=" + 
				document.the_form.start_year_number.value +
				"&start_month_number=" + document.the_form.start_month_number.value +
				"&end_year_number=" + document.the_form.end_year_number.value +
				"&end_month_number=" + document.the_form.end_month_number.value;	

	httpObj.open("POST", url, true);
	httpObj.send(null);		
}

</script>
</head>
<body>
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
Customer : <select name="customer_name" id="customer_field_id" onchange="displayReportData(this.value)">
</select>
</td>
<td>
Start Year : <select name="start_year_number">
		<option value="<%=nCurrentYear%>" selected><%=nCurrentYear%></option>
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
</body>
</html>