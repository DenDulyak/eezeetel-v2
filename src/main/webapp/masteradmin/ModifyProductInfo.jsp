<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <meta charset="utf-8">
    <script src="${pageContext.request.contextPath}/js/validate.js"></script>
    <script>
        function ValidateInput() {
            var errString = "";

            if (!CheckSpecialCharacters(document.the_form.product_name.value, " "))
                errString += "\r\Product Name can only be mix of characters and numbers.  Please enter a proper value";
            if (!CheckNumbers(document.the_form.face_value.value, "."))
                errString += "\r\nFace value can only be numbers.  Please enter a proper value";

            if (errString == null || errString.length <= 0) {
                for (i = 0; i < document.the_form.elements.length; i++)
                    if (document.the_form.elements[i].type == "text")
                        CheckDatabaseChars(document.the_form.elements[i]);

                document.the_form.action = "UpdateProductInfo.jsp";
                document.the_form.submit();
            }
            else
                alert(errString);
        }

    </script>
    <title>Modify Product Information</title>
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
                        <%
                            int record_id = Integer.parseInt(request.getParameter("record_id"));
                            String strQuery = "from TMasterProductinfo where Product_ID = " + record_id;

                            Session theSession = null;
                            try {
                                theSession = HibernateUtil.openSession();
                                Query query = theSession.createQuery(strQuery);
                                List records = query.list();

                                if (records.size() > 0) {
                                    TMasterProductinfo prodInfo = (TMasterProductinfo) records.get(0);
                                    TMasterSupplierinfo supInfo = prodInfo.getSupplier();
                                    TMasterProducttype prodType = prodInfo.getProductType();

                                    String strChecked = "";
                                    if (prodInfo.getCalculateVat() == 1)
                                        strChecked = "checked";
                        %>

                        <form method="post" name="the_form" action="">
                            <table>
                                <tr>
                                    <td align="right">
                                        Supplier :
                                    </td>
                                    <td align="left">
                                        <input type="hidden" name="record_id" value="<%=prodInfo.getId()%>">
                                        <select name="supplier_id">

                                            <%
                                                strQuery = "from TMasterSupplierinfo where Secondary_Supplier = 0 and Supplier_Active_Status = 1";
                                                query = theSession.createQuery(strQuery);
                                                List suppliers = query.list();

                                                for (int nIndex = 0; nIndex < suppliers.size(); nIndex++) {
                                                    TMasterSupplierinfo oneSupplier = (TMasterSupplierinfo) suppliers.get(nIndex);

                                                    String strSelect = "";
                                                    if (oneSupplier.getId() == supInfo.getId())
                                                        strSelect = "Selected";
                                            %>
                                            <option value="<%=oneSupplier.getId()%>" <%=strSelect%>><%=oneSupplier.getSupplierName()%>
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
                                                strQuery = "from TMasterProducttype where Product_Type_Active_Status = 1";
                                                query = theSession.createQuery(strQuery);
                                                List product_types = query.list();

                                                for (int nIndex = 0; nIndex < product_types.size(); nIndex++) {
                                                    TMasterProducttype oneProductType = (TMasterProducttype) product_types.get(nIndex);
                                                    String strSelect = "";
                                                    if (oneProductType.getId() == prodType.getId())
                                                        strSelect = "Selected";
                                            %>
                                            <option value="<%=oneProductType.getId()%>" <%=strSelect%>><%=oneProductType.getProductType()%>
                                            </option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        Face Value :
                                    </td>
                                    <td align="left">
                                        <input type="text" name="face_value" size="6" maxlength="6" value="<%=prodInfo.getProductFaceValue()%>">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        Product Name :
                                    </td>
                                    <td align="left">
                                        <input type="text" name="product_name" size="50" maxlength="100" value="<%=prodInfo.getProductName()%>">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        Caliculate VAT :
                                    </td>
                                    <td align="left">
                                        <input type="checkbox" name="caliculate_vat" <%=strChecked%>>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        Product Description :
                                    </td>
                                    <td align="left">
                                        <input type="text" name="product_desc" size="50" maxlength="100"
                                               value="<%=prodInfo.getProductDescription()%>">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        Cost Price :
                                    </td>
                                    <td align="left">
                                        <input type="number" name="cost_price" step="0.05" value="<%=prodInfo.getCostPrice()%>">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        Notes :
                                    </td>
                                    <td align="left">
                                        <input type="text" name="notes" size="50" maxlength="100" value="<%=prodInfo.getNotes()%>">
                                    </td>
                                </tr>
                                <%
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    } finally {
                                        HibernateUtil.closeSession(theSession);
                                    }
                                %>
                                <tr>
                                    <td align="center">
                                        <a href=MasterInformation.jsp> Go to Main </a>
                                    </td>

                                    <td align="center">
                                        <input type="button" name="update_button" value="Update" onClick="ValidateInput()">
                                    </td>

                                    <td align="center">
                                        <input type="reset" name="clear_button" value="Clear">
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>