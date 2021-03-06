<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">

        function update_products(isInitialLoad) {
            if (globalVariable == 1) {
                for (var n = 0; n < index; n++) {
                    if ((tempArray[n][1] != tempArray[n][4]) || (tempArray[n][2] != tempArray[n][5]) || (tempArray[n][3] != tempArray[n][6])) {
                        var r = confirm("Information has been changed on this page.  Do you want to save?");
                        count = index;
                        index = 0;
                        globalVariable = 0;
                        if (r == true) {
                            saveData();
                            break;
                        }
                        else {
                            count = 0;
                            alert("Information not saved");
                            break;
                        }
                    }
                }
                index = 0;
                globalVariable = 0;
            }

            var httpObj = getHttpObject();
            if (httpObj == null) {
                alert("Can not get product information");
                return;
            }

            var sup_id = 0;
            var age_id = 0;
            if (!isInitialLoad) {
                sup_id = document.the_form.supplier_id.value;
                age_id = document.the_form.agent_id.value;
            }
            if (sup_id == 0) {
                sup_id = "";
                age_id = "";
            }
            if (sup_id == 0 || age_id == 0) {
                var theHTML = "<table width=\"100%\"> <tr bgcolor=\"#99CCFF\">" +
                        "<td> <h5>Supplier</h5> </td> <td> <h5>Product Name</h5> </td> " +
                        "<td> <h5>Product Face Value</h5> </td> <td> <h5>Commission Type</h5> </td> <td> <h5>Commission</h5>" +
                        "</td><td><h5>Commission Amount </h5></td> <td> <h5>Notes</h5> </td>";

                var element = document.getElementById('product_detailed_info_id');
                element.innerHTML = theHTML;
            }
            if (sup_id != 0 && age_id != 0) {
                httpObj.onreadystatechange = function () {
                    if (httpObj.readyState == 4) {
                        var theHTML = "<table width=\"100%\"> <tr bgcolor=\"#99CCFF\">" +
                                "<td> <h5>Supplier</h5> </td> <td> <h5>Product Name</h5> </td> " +
                                "<td> <h5>Product Face Value</h5> </td> <td> <h5>Commission Type</h5> </td> <td> <h5>Commission</h5>" +
                                "</td><td><h5>Commission Amount</h5> </td> <td> <h5>Notes</h5> </td>";

                        var element = document.getElementById('product_detailed_info_id');
                        element.innerHTML = "";

                        var nl = httpObj.responseXML.getElementsByTagName('product');
                        var agent_values_total = httpObj.responseXML.getElementsByTagName('agent_values');
                        var total_products_id_string = "";

                        for (i = 0; i < nl.length; i++) {
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
                            var strIsActive = (active == 1) ? "Yes" : "No";

                            var final_amount = 0;

                            if (commission_type == 0)
                                final_amount = eval(eval(value) + eval(commission));
                            else
                                final_amount = eval(eval(value) - (value * commission / 100));

                            if (commission_type == 0) {
                                oneRow = ("<tr bgcolor=" + bgcolor + ">" +
                                        "<td align=\"left\">" + sup_name + "</td>" +
                                        "<td align=\"left\">" + name + "</td>" +
                                        "<td align=\"left\">" + value + "</td>" +
                                        "<td align=\"left\"> <select name=\"commissiontype_" + id + "\" onChange=\"changedField(" + id + ")\" \" onFocus=\"initialLoad(" + id + ")\" \" onBlur=\"validateInput(" + id + ")\" ><option value=\"0\">Real Value</option><option value=\"1\"> Percentage </option></select>	</td>" +
                                        "<td align=\"left\"><input type=\"text\" name=\"commission_" + id + "\" size=\"10\" maxlength=\"10\" value=" + commission + " onChange=\"changedField(" + id + ")\" \" onFocus=\"initialLoad(" + id + ")\" \" onBlur=\"validateInput(" + id + ")\"></td>" +
                                        "<td align=\"left\">" + final_amount + "</td>" +
                                        "<td align=\"left\"><input type=\"text\" name=\"notes_" + id + "\" size=\"20\" maxlength=\"100\" onchange=\"changedField(" + id + ")\"  onFocus=\"initialLoad(" + id + ")\" onBlur=\"validateInput(" + id + ")\"  value=\"" + notes + "\"></td>"
                                );
                            }
                            else {
                                oneRow = ("<tr bgcolor=" + bgcolor + ">" +
                                        "<td align=\"left\">" + sup_name + "</td>" +
                                        "<td align=\"left\">" + name + "</td>" +
                                        "<td align=\"left\">" + value + "</td>" +
                                        "<td align=\"left\"> <select name=\"commissiontype_" + id + "\" onChange=\"changedField(" + id + ")\" \" onFocus=\"initialLoad(" + id + ")\" \" onBlur=\"validateInput(" + id + ")\" ><option value=\"1\"> Percentage </option><option value=\"0\">Real Value</option></select>	</td>" +
                                        "<td align=\"left\"><input type=\"text\" name=\"commission_" + id + "\" size=\"10\" maxlength=\"10\" value=" + commission + " onChange=\"changedField(" + id + ")\" \" onFocus=\"initialLoad(" + id + ")\" \" onBlur=\"validateInput(" + id + ")\"></td>" +
                                        "<td align=\"left\">" + final_amount + "</td>" +
                                        "<td align=\"left\"><input type=\"text\" name=\"notes_" + id + "\" size=\"20\" maxlength=\"100\" onchange=\"changedField(" + id + ")\"  onFocus=\"initialLoad(" + id + ")\" onBlur=\"validateInput(" + id + ")\"  value=\"" + notes + "\"></td>"
                                );
                            }
                            //alert(oneRow);
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
                        theHTML += "Copy commission of present agent to : ";
                        //theHTML += "</td>";
                        theHTML += "<select name=\"new_agent_id\">";
                        //theHTML += "<option value=\"0\">Select</option>";
                        for (var i = 0; i < agent_values_total.length; i++) {
                            var age_values = agent_values_total.item(i);

                            var id = age_values.getAttribute('agent_id');
                            var name = age_values.getAttribute('agent_first_name');
                            theHTML += "<option value=\"" + id + "\">" + name + "</option>";
                        }
                        theHTML += "<td align=\"left\"><input type=\"button\" name=\"copy_button\" value=\"COPY\" OnClick=\"copy_agent()\">";
                        theHTML += "</tr></table>";
                        //alert(theHTML);
                        var element = document.getElementById('product_detailed_info_id');
                        element.innerHTML = theHTML;
                        httpObj = null;
                    }
                }
                var url = "AJAX_GetMultipleAgentCommission.jsp?supplier_id=" + sup_id + "&agent_id=" + age_id;
                httpObj.open("POST", url, true);
                httpObj.send(null);
            }

        }

    </script>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>List, Modify, Delete Agent Commission</title>
</head>

<body>

<form name="the_form" method="post" action="">
    <input type="hidden" name="product_id_list"/>
    <input type="hidden" name="total_products_list"/>
    <table>
        <%
            Session theSession = null;
            try {
                theSession = HibernateUtil.openSession();
        %>

        <tr>
            <td align="left">
                Supplier :
            </td>
            <td align="left">
                <genericappdb:SupplierList name="supplier_id" active_records_only="1" secondary_also="0"
                                           initial_option="Select" onChange="update_products(false)"
                                           default_select="0"/>
            </td>
            <td align="left">
                Agent:
            </td>
            <td align="left">
                <select name="agent_id" onchange="update_products(false)">
                    <option value="0">Select</option>
                    <%
                        String strQuery = "from User where User_Type_And_Privilege = 6 and User_Active_Status = 1";
                        Query query = theSession.createQuery(strQuery);
                        List records = query.list();
                        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                            User userInfo = (User) records.get(nIndex);
                    %>
                    <option value="<%=userInfo.getLogin()%>"><%=userInfo.getUserFirstName()%>
                    </option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>
    </table>

    <div id="product_detailed_info_id"></div>

    <%
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
    %>
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