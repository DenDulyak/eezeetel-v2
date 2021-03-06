<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<html>
<head>
    <c:import url="common/libs.jsp"/>
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">
        function ValidateInput() {
            if (!CheckSpecialCharacters(document.the_form.product_type.value, "#. ")) {
                alert("Product Type must have only characters and numbers.  Please enter a proper value");
                return;
            }

            for (i = 0; i < document.the_form.elements.length; i++)
                if (document.the_form.elements[i].type == "text")
                    CheckDatabaseChars(document.the_form.elements[i]);

            document.the_form.action = "UpdateProductType.jsp";
            document.the_form.submit();
        }
    </script>
    <title>Modify Product Type Definition</title>
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
                            String strQuery = "from TMasterProducttype where Product_Type_ID = " + record_id;

                            Session theSession = null;
                            try {
                                theSession = HibernateUtil.openSession();
                                theSession.beginTransaction();
                                Query query = theSession.createQuery(strQuery);
                                List records = query.list();
                                if (records.size() > 0) {
                                    TMasterProducttype prodType = (TMasterProducttype) records.get(0);
                        %>
                        <form method="post" name="the_form" action="">

                            <table class="table table-bordered">
                                <tr>
                                    <td align="right">
                                        Product Type :
                                    </td>
                                    <td align="left">
                                        <input type="hidden" name="record_id" value="<%=prodType.getId()%>">
                                        <input type="text" name="product_type" size="50" maxlength="50"
                                               value="<%=prodType.getProductType()%>">
                                    </td>
                                <tr>
                                    <td align="right">
                                        Product Type Description :
                                    </td>

                                    <td align="left">
                                        <input type="text" name="product_type_desc" size="50" maxlength="100"
                                               value="<%=prodType.getProductTypeDescription()%>">
                                    </td>
                                </tr>

                                <tr>
                                    <td align="right">
                                        Notes :
                                    </td>

                                    <td align="left">
                                        <input type="text" name="notes" size="50" maxlength="100"
                                               value="<%=prodType.getNotes()%>">
                                    </td>
                                </tr>
                                <%
                                        }
                                        theSession.getTransaction().commit();
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                        theSession.getTransaction().rollback();
                                    } finally {
                                        HibernateUtil.closeSession(theSession);
                                    }
                                %>
                                <tr>
                                    <td align="center">
                                        <a href=MasterInformation.jsp> Go to Main </a>
                                    </td>

                                    <td align="center">
                                        <input type="button" name="update_button" value="Update"
                                               onClick="ValidateInput()">
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