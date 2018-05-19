<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script language="javascript" src="/GenericApp/Scripts/Validate.js"></script>
<script language="javascript">


globalVariable=0;
var tempArray = new Array(); 
var index=0;
var count=0;

function SubmitForm()
{
	if(index!=0)
	{
		var flag1=0;
		for(var n=0;n<index;n++)
		{
			if((tempArray[n][1] != tempArray[n][4]) || (tempArray[n][2] != tempArray[n][5]) || (tempArray[n][3] != tempArray[n][6]))
			{
				count=index;
				index=0;
				globalVariable=0;
				flag1=1;
				saveData();		
				break;		
			}
		}
		if(flag1==0)
		{
			index=0;
			globalVariable=0;
			alert("No information changed. So no need to save");
			return;
		}
		else
			return;
	}
	else
	{
		//alert("in else");
		index=0;
		globalVariable=0;
		alert("No information changed. So no need to save");
		return;
	}
}
function saveData()
{
	alert("Information saved");
	var product_id_string = "";
	for (var i = 0; i < count; i++)
	{
		if((tempArray[i][1] != tempArray[i][4]) || (tempArray[i][2] != tempArray[i][5]) || (tempArray[i][3] != tempArray[i][6]))
		{

			product_id_string += tempArray[i][0] + " ";
		}	
	}
	count=0;

	document.the_form.product_id_list.value = product_id_string;

	document.the_form.action = "AddMultipleCustomerCommission.jsp";	
	document.the_form.submit();	

}

function validateInput(id)
{
	var tempCommission="commission_"+id;
	var tempCommissionType = "commissiontype_"+id;
	var tempNotes = "notes_"+id;
	var errString = "";
	if (!CheckNumbers(document.getElementsByName(tempCommission)[0].value, "."))	
	{
		errString += "\r\Commission should be a number. Please enter a proper value";
		alert(errString);
		document.getElementsByName(tempCommission)[0].focus();
	}
			
	if (document.getElementsByName(tempCommissionType)[0].value == 1)
	{
		if (document.getElementsByName(tempCommission)[0].value > 100)
		{
			errString += "\r\nCommission Percentage cannot be greater than 100. Please enter a proper value";
			alert(errString);
			document.getElementsByName(tempCommission)[0].focus();
		}	
	}
	

	if (errString == null || errString.length <= 0)
	{
		for (i = 0; i < document.the_form.elements.length; i++)
			if (document.the_form.elements[i].type == "text")
				CheckDatabaseChars(document.the_form.elements[i]);
	}	
}

function initialLoad(id)
{

	if(index==0)
	{
		tempArray[0] = new Array(7);

		var tempCommission="commission_"+id;
		var tempCommissionType = "commissiontype_"+id;
		var tempNotes = "notes_"+id;
		
		tempArray[0][0]=id;
		tempArray[0][1]=document.getElementsByName(tempCommission)[0].value;
		tempArray[0][2]=document.getElementsByName(tempCommissionType)[0].value;
		tempArray[0][3]=document.getElementsByName(tempNotes)[0].value;
		tempArray[0][4]=document.getElementsByName(tempCommission)[0].value;
		tempArray[0][5]=document.getElementsByName(tempCommissionType)[0].value;
		tempArray[0][6]=document.getElementsByName(tempNotes)[0].value;
		index++;
	}
	else
	{
		var flag = 0;
		for(var k=0;k<index;k++)
		{
			if(tempArray[k][0]==id)
			{
				flag = 1;
				break;
			}			
		}		
		if(flag == 0)
		{
			tempArray[index] = new Array(7);
			var tempCommission="commission_"+id;
			var tempCommissionType = "commissiontype_"+id;
			var tempNotes = "notes_"+id;
			
		tempArray[index][0]=id;
			tempArray[index][1]=document.getElementsByName(tempCommission)[0].value;
			tempArray[index][2]=document.getElementsByName(tempCommissionType)[0].value;
			tempArray[index][3]=document.getElementsByName(tempNotes)[0].value;
			tempArray[index][4]=document.getElementsByName(tempCommission)[0].value;
			tempArray[index][5]=document.getElementsByName(tempCommissionType)[0].value;
			tempArray[index][6]=document.getElementsByName(tempNotes)[0].value;
			index++;
		}		
	}	
}

function changedField(id)
{
	var tempCommission="commission_"+id;
	var tempCommissionType = "commissiontype_"+id;
	var tempNotes = "notes_"+id;
		
	for(var n=0;n<index;n++)
	{
		if(tempArray[n][0]==id)
		{
			tempArray[n][4]=document.getElementsByName(tempCommission)[0].value;
			tempArray[n][5]=document.getElementsByName(tempCommissionType)[0].value;
			tempArray[n][6]=document.getElementsByName(tempNotes)[0].value;

			count++;	
		}
	}
	globalVariable=1;
}

function copy_customer()
{
	var httpObj = getHttpObject();
	var to_cust_id=document.getElementsByName("new_customer_id")[0].value;
	var from_cust_id=document.getElementsByName("customer_id")[0].value;
	var supplier_id=document.getElementsByName("supplier_id")[0].value;
	var products_list=document.getElementsByName("total_products_list")[0].value;

	var url = "AJAX_CopyCustomerCommission.jsp?to_customer_id=" + to_cust_id +"&from_customer_id=" + 
	from_cust_id+"&supplier_id="+ supplier_id+"&products_list="+products_list;
	httpObj.open("POST",url,true);
	httpObj.send(null);

	httpObj.onreadystatechange=function()
	{
		if(httpObj.readyState==4)
		{
			alert(httpObj.responseText);
		}
	}	
}

function update_products(isInitialLoad)
{
	if (globalVariable == 1)
	{
		for(var n=0;n<index;n++)
		{
			if((tempArray[n][1] != tempArray[n][4]) || (tempArray[n][2] != tempArray[n][5]) || (tempArray[n][3] != tempArray[n][6]))
			{
				var r = confirm("Information has been changed on this page.  Do you want to save?");
				count=index;
				index=0;
				globalVariable=0;
				if(r == true)
				{
					saveData();
					break;
				}
				else
				{
					count=0;
					alert("Information not saved");
					break;
				}				
			}
		}
		index=0;
		globalVariable=0;
	}
	
	var httpObj = getHttpObject();
	if (httpObj == null)
	{
		alert("Cannot get product information");
		return;
	}

	var sup_id = 0;
	var cust_id = 0;
	if (!isInitialLoad) 
	{
		sup_id = document.the_form.supplier_id.value;
		cust_id = document.the_form.customer_id.value;
	}
	if (sup_id == 0)
	{
		sup_id = "";
		cust_id = "";
	}	
	if(sup_id == 0 || cust_id == 0)
	{
		var theHTML = "<table width=\"100%\"> <tr bgcolor=\"#99CCFF\">" +
		"<td> <h5>Supplier</h5> </td> <td> <h5>Product Name</h5> </td> " + 
		"<td> <h5>Product Face Value</h5> </td> <td> <h5>Commission Type</h5> </td> <td> <h5>Commission</h5>" +
		"</td><td><h5>Product Final Value </h5></td> <td> <h5>Notes</h5> </td>";

		var element = document.getElementById('product_detailed_info_id');
	    element.innerHTML = theHTML;
	}
	if(sup_id != 0 && cust_id !=0)
	{
		httpObj.onreadystatechange=function()
		{
			if(httpObj.readyState==4)
			{
				var theHTML = "<table width=\"100%\"> <tr bgcolor=\"#99CCFF\">" +
					"<td> <h5>Supplier</h5> </td> <td> <h5>Product Name</h5> </td> " + 
					"<td> <h5>Product Face Value</h5> </td> <td> <h5>Profit Margin Type</h5> </td> <td> <h5>Profit Margin</h5>" +
					"</td><td><h5>Product Final Value </h5></td> <td> <h5>Notes</h5> </td>";
			
			    var element = document.getElementById('product_detailed_info_id');
			    element.innerHTML = "";
				
				var nl = httpObj.responseXML.getElementsByTagName('product');
				var cust_values_total = httpObj.responseXML.getElementsByTagName('customer_values');
				var total_products_id_string="";
				//alert(nl);
				//alert(other_customers.item(0));
				//alert(customer_values);
				for(i = 0; i < nl.length; i++ )
				{
				    var nli = nl.item(i);
				    var id = nli.getAttribute('id');
				    total_products_id_string += id + " ";
				    var sup_name = nli.getAttribute('sup_name');
				    var name = nli.getAttribute('name');
				    var value = nli.getAttribute('value');
				    var commission = nli.getAttribute('commission');
			  	 	var commission_type = nli.getAttribute('commission_type');



				    var notes = nli.getAttribute('notes');
				    var active = nli.getAttribute('active');
				    var bgcolor = (active == 1) ? "#FFFFFF" : "#808080";
				    var strIsActive	= (active == 1) ? "Yes" : "No";
				    

				    var final_amount=0;

				    if(commission_type == 0)
				    {
					    final_amount = eval (eval(value) + eval(commission));
				    }
				    else
					    final_amount = eval(eval(value) + (value * commission / 100));
				    
				    if(commission_type == 0)
				    {
					    oneRow = ("<tr bgcolor=" + bgcolor + ">" + 
								"<td align=\"left\">" + sup_name + "</td>" +
				    			"<td align=\"left\">" + name + "</td>" + 
				    			"<td align=\"left\">" + value + "</td>" +
			    				"<td align=\"left\"> <select name=\"commissiontype_" +  id  + "\" onChange=\"changedField(" + id + ")\" \" onFocus=\"initialLoad(" + id + ")\" \" onBlur=\"validateInput(" + id + ")\" ><option value=\"0\">Real Value</option><option value=\"1\"> Percentage </option></select>	</td>"+
			    				"<td align=\"left\"><input type=\"text\" name=\"commission_" +  id  + "\" size=\"10\" maxlength=\"10\" value=" + commission +" onChange=\"changedField("+ id +")\" \" onFocus=\"initialLoad(" + id + ")\" \" onBlur=\"validateInput(" + id + ")\"></td>"+
			    				"<td align=\"left\">" + final_amount + "</td>" +
			    				"<td align=\"left\"><input type=\"text\" name=\"notes_" + id + "\" size=\"20\" maxlength=\"100\" onchange=\"changedField("+ id +")\"  onFocus=\"initialLoad(" + id + ")\" onBlur=\"validateInput(" + id + ")\"  value=\"" + notes + "\"></td>"
			    				);
				    }
				    else
				    {
					    oneRow = ("<tr bgcolor=" + bgcolor + ">" + 
								"<td align=\"left\">" + sup_name + "</td>" +
				    			"<td align=\"left\">" + name + "</td>" + 
				    			"<td align=\"left\">" + value + "</td>" +
			    				"<td align=\"left\"> <select name=\"commissiontype_" +  id  + "\" onChange=\"changedField(" + id + ")\" \" onFocus=\"initialLoad(" + id + ")\" \" onBlur=\"validateInput(" + id + ")\" ><option value=\"1\"> Percentage </option><option value=\"0\">Real Value</option></select>	</td>"+
			    				"<td align=\"left\"><input type=\"text\" name=\"commission_" +  id  + "\" size=\"10\" maxlength=\"10\" value=" + commission +" onChange=\"changedField("+ id +")\" \" onFocus=\"initialLoad(" + id + ")\" \" onBlur=\"validateInput(" + id + ")\"></td>"+
			    				"<td align=\"left\">" + final_amount + "</td>" +
			    				"<td align=\"left\"><input type=\"text\" name=\"notes_" + id + "\" size=\"20\" maxlength=\"100\" onchange=\"changedField("+ id +")\"  onFocus=\"initialLoad(" + id + ")\" onBlur=\"validateInput(" + id + ")\"  value=\"" + notes + "\"></td>"
			    				);					    
				    }
    				theHTML += oneRow;
				}
				//alert(theHTML);
				document.the_form.total_products_list.value = total_products_id_string;
				theHTML += "</table>";
				theHTML += "<table width=\"89%\"><tr align=\"right\"><td>";
				theHTML += "Save changes in the form : ";
				theHTML += "<input type=\"button\" name=\"save_button\" value=\"Save\" OnClick=\"SubmitForm();\"> </td>";
				theHTML += "</tr>";
				theHTML += "<tr> </tr> <tr> </tr> <tr> </tr> <tr> </tr> <tr> </tr> <tr> </tr> <tr> </tr>";
				theHTML += "<table width=\"100%\">";
				theHTML += "<tr> </tr>";
				theHTML += "<tr align=\"right\"> <td>";
				theHTML += "Copy commission of present customer to : ";
				//theHTML += "</td>";
				theHTML += "<select name=\"new_customer_id\">";
				//theHTML += "<option value=\"0\">Select</option>";
				for(var i=0;i<cust_values_total.length;i++)
				{
					var cust_values = cust_values_total.item(i);
			
					var id = cust_values.getAttribute('customer_id');
					var name = cust_values.getAttribute('customer_company_name');
					theHTML += "<option value=\""+ id +"\">"+name+"</option>";
				} 
				theHTML += "<td align=\"left\"><input type=\"button\" name=\"copy_button\" value=\"COPY\" OnClick=\"copy_customer()\">";
				theHTML += "</tr></table>";
				//alert(theHTML);
				var element = document.getElementById('product_detailed_info_id');
		    	element.innerHTML = theHTML;
		    	httpObj = null;
			}
		}
		var url = "AJAX_GetMultipleCommission.jsp?supplier_id=" + sup_id +"&customer_id=" + cust_id;
		httpObj.open("POST",url,true);
		httpObj.send(null);
	}
	
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>List, Modify, Delete or Activate Product Information</title>
</head>
<!--Initial load is removed -->
<body>

<form name="the_form" method="post" action="">
<input type="hidden" name="product_id_list"></input>
<input type="hidden" name="total_products_list"></input>
<table>
	<tr>
		<td align="left">
			Supplier :
		</td>
		<td align="left">
			<genericappdb:SupplierList name="supplier_id" active_records_only="1" secondary_also = "0" initial_option="Select" onChange="update_products(false)" default_select = "0" />
		</td>
		<td align="left">
				Customer:
			</td>
			<td align="left">
				<genericappdb:CustomerList name="customer_id" active_records_only="1" initial_option="Select" onChange="update_products(false)"/>
			</td>
	</tr>
	</table>
	
	<div id="product_detailed_info_id"></div>						
	<table width="95%">
		<tr align="left">
			<td>				
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="MasterInformation.jsp"> Go to Main </a>
			</td>
		</tr>
	</table>
	</form>
	
	
</body>
</html>