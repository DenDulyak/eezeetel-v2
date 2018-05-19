<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<html>
<head>
    <c:import url="common/libs.jsp"/>
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">
        function ValidateInput() {
            var errString = "";

            if (!CheckSpecialCharacters(document.the_form.product_name.value, " "))
                errString += "\r\Product Name can only be mix of characters and numbers.  Please enter a proper value";
            if (!CheckNumbers(document.the_form.face_value.value, "."))
                errString += "\r\nFace value can only be numbers.  Please enter a proper value";
            /* if (!CheckNumbers(document.the_form.commission.value, "."))
             errString += "\r\nCommission can only be numbers.  Please enter a proper value";*/


            if (errString == null || errString.length <= 0) {
                for (i = 0; i < document.the_form.elements.length; i++)
                    if (document.the_form.elements[i].type == "text")
                        CheckDatabaseChars(document.the_form.elements[i]);

                document.the_form.action = "AddProductInfo.jsp";
                document.the_form.submit();
            }
            else
                alert(errString);
        }

    </script>
    <title>New Product Information</title>
</head>
<body>
<section id="container">
    <c:import url="common/header.jsp"/>
    <c:import url="common/menu.jsp"/>

    <section id="main-content">
        <section class="wrapper">
            <div class="row">
                <div class="col-lg-12 col-md-12">
                    <div class="container-fluid">
                        <form method="post" name="the_form" action="">
                            <%
                                Session theSession = null;
                                try {
                                    theSession = HibernateUtil.openSession();
                            %>
                            <table>

                                <tr>
                                    <td align="right">
                                        Supplier :
                                    </td>
                                    <td align="left">
                                        <select name="supplier_id">
                                            <%
                                                String strQuery = "from TMasterSupplierinfo where Secondary_Supplier = 0 and Supplier_Active_Status = 1 "
                                                        + " order by Supplier_Name";
                                                Query query = theSession.createQuery(strQuery);
                                                List records = query.list();
                                                for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                                                    TMasterSupplierinfo supInfo = (TMasterSupplierinfo) records.get(nIndex);

                                            %>
                                            <option value="<%=supInfo.getId()%>"><%=supInfo.getSupplierName()%>
                                            </option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        Product Type :
                                    </td>
                                    <td align="left">
                                        <select name="product_type_id">
                                            <%
                                                strQuery = "from TMasterProducttype where Product_Type_Active_Status = 1 order by Product_Type_Description";
                                                query = theSession.createQuery(strQuery);
                                                List product_types = query.list();

                                                for (int nIndex = 0; nIndex < product_types.size(); nIndex++) {
                                                    TMasterProducttype oneProductType = (TMasterProducttype) product_types.get(nIndex);
                                            %>
                                            <option value="<%=oneProductType.getId()%>"><%=oneProductType.getProductType()%>
                                            </option>
                                            <%
                                                }
                                            %>
                                        </select>
                                        <input type="hidden" name="product_created_by" value="<%=request.getRemoteUser()%>">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        Face Value :
                                    </td>
                                    <td align="left">
                                        <input type="text" name="face_value" size="6" maxlength="6">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        Product Name :
                                    </td>
                                    <td align="left">
                                        <input type="text" name="product_name" size="50" maxlength="100">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        Caliculate VAT :
                                    </td>
                                    <td align="left">
                                        <input type="checkbox" name="caliculate_vat" checked>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        Product Description :
                                    </td>
                                    <td align="left">
                                        <input type="text" name="product_desc" size="50" maxlength="100">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        Notes :
                                    </td>
                                    <td align="left">
                                        <input type="text" name="notes" size="50" maxlength="100">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center">
                                        <a href=MasterInformation.jsp> Go to Main </a>
                                    </td>

                                    <td align="center">
                                        <input type="button" name="add_button" value="Add" onClick="ValidateInput()">
                                    </td>

                                    <td align="center">
                                        <input type="reset" name="clear_button" value="Clear">
                                    </td>
                                </tr>
                            </table>
                            <%
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    HibernateUtil.closeSession(theSession);
                                }
                            %>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>