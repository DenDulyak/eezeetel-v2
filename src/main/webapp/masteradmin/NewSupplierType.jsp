<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<html>
<head>
    <c:import url="common/libs.jsp"/>
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">
        function ValidateInput() {
            if (!CheckSpecialCharacters(document.the_form.supplier_type.value, " ")) {
                alert("Supplier Type must have only characters and numbers.  Please enter a proper value");
                return;
            }

            for (i = 0; i < document.the_form.elements.length; i++)
                if (document.the_form.elements[i].type == "text")
                    CheckDatabaseChars(document.the_form.elements[i]);

            document.the_form.action = "AddSupplierType.jsp";
            document.the_form.submit();
        }
    </script>
    <title>New Supplier Type</title>
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
                            <table width="100%">
                                <tr>
                                    <td align="right">
                                        Supplier Type :
                                    </td>
                                    <td align="left">
                                        <input type="text" name="supplier_type" size="50" maxlength="50">
                                    </td>
                                <tr>
                                    <td align="right">
                                        Supplier Type Description :
                                    </td>
                                    <td align="left">
                                        <input type="text" name="supplier_type_desc" size="50" maxlength="100">
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
                                    </td>
                                    <td align="center">
                                        <input type="button" name="add_button" value="Add" onClick="ValidateInput()">
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