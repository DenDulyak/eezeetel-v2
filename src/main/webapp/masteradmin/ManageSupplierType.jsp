<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<html>
<head>
    <c:import url="common/libs.jsp"/>
    <script language="javascript" src="/js/validate.js"></script>
    <title>List, Modify, Delete or Activate Supplier Type</title>
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
                                    <th>Supplier Type</th>
                                    <th>Supplier Type Description</th>
                                    <th>Notes</th>
                                    <th>Supplier Type Active</th>
                                </tr>
                                </thead>

                                <%
                                    String strQuery = "from TMasterSuppliertype";

                                    Session theSession = null;
                                    try {
                                        theSession = HibernateUtil.openSession();

                                        Query query = theSession.createQuery(strQuery);
                                        List records = query.list();

                                        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                                            TMasterSuppliertype suppType = (TMasterSuppliertype) records.get(nIndex);

                                            String strIsActive = suppType.getActive() ? "Yes" : "No";
                                            String strBgColor = suppType.getActive() ? "active" : "danger";
                                %>
                                <tr class="<%=strBgColor%>">
                                    <td align="right">
                                        <input type="radio" name="record_id" value="<%=suppType.getId()%>">
                                    </td>
                                    <td align="left"><%=suppType.getSupplierType()%>
                                    </td>
                                    <td align="left"><%=suppType.getDescription()%>
                                    </td>
                                    <td align="left"><%=suppType.getNotes()%>
                                    </td>
                                    <td align="left"><%=strIsActive%>
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

                                <jsp:include page="buttons.jsp">
                                    <jsp:param name="follow_up_page" value="SupplierType"/>
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