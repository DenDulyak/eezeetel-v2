<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <script language="javascript" src="/js/validate.js"></script>
    <title>List, Modify, Delete or Activate Product Type</title>
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
                        <form name="the_form" action="">
                            <table class="table table-bordered">
                                <thead>
                                <tr>
                                    <th></th>
                                    <th>Product Type</th>
                                    <th>Product Type Description</th>
                                    <th>Notes</th>
                                    <th>User Type Active</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                    String strQuery = "from TMasterProducttype";

                                    Session theSession = null;
                                    try {
                                        theSession = HibernateUtil.openSession();

                                        Query query = theSession.createQuery(strQuery);
                                        List records = query.list();

                                        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                                            TMasterProducttype prodType = (TMasterProducttype) records.get(nIndex);

                                            String strIsActive = prodType.getActive() ? "Yes" : "No";
                                            String strBgColor = prodType.getActive() ? "active" : "danger";
                                %>
                                <tr class="<%=strBgColor%>">
                                    <td align="right">
                                        <input type="radio" name="record_id" value="<%=prodType.getId()%>"/>
                                    </td>
                                    <td>
                                        <%=prodType.getProductType()%>
                                    </td>
                                    <td>
                                        <%=prodType.getProductTypeDescription()%>
                                    </td>
                                    <td>
                                        <%=prodType.getNotes()%>
                                    </td>
                                    <td>
                                        <%=strIsActive%>
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
                                </tbody>
                                <jsp:include page="buttons.jsp">
                                    <jsp:param name="follow_up_page" value="ProductType"/>
                                </jsp:include>

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