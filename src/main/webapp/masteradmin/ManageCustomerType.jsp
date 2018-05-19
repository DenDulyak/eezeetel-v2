<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <c:import url="common/libs.jsp"/>
    <meta charset="utf-8">
    <script language="javascript" src="/js/validate.js"></script>
    <title>List, Modify, Delete or Activate Customer Type</title>
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

                            <table border="1" width="100%">
                                <tr bgcolor="#99CCFF">
                                    <td></td>
                                    <td><h5>Customer Type</h5></td>
                                    <td><h5>Customer Type Description</h5></td>
                                    <td><h5>Notes</h5></td>
                                    <td><h5>Customer Type Active</h5></td>
                                </tr>

                                <%
                                    String strQuery = "from TMasterCustomertype";

                                    Session theSession = null;
                                    try {
                                        theSession = HibernateUtil.openSession();

                                        Query query = theSession.createQuery(strQuery);
                                        List records = query.list();

                                        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                                            TMasterCustomertype custType = (TMasterCustomertype) records.get(nIndex);

                                            String strIsActive = (custType.getCustomerTypeActiveStatus() == 1) ? "Yes" : "No";
                                            String strBgColor = (custType.getCustomerTypeActiveStatus() == 1) ? "#FFFFFF" : "#808080";
                                %>

                                <tr bgcolor="<%=strBgColor%>">
                                    <td align="right">
                                        <input type="radio" name="record_id" value="<%=custType.getId()%>">
                                    </td>

                                    <td align="left"><%=custType.getCustomerType()%>
                                    </td>
                                    <td align="left"><%=custType.getCustomerTypeDescription()%>
                                    </td>
                                    <td align="left"><%=custType.getNotes()%>
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
                                    <jsp:param name="follow_up_page" value="CustomerType"/>
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