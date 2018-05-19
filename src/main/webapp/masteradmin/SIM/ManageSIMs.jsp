<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<%
    String strQuery = "select Product_ID, Customer_Group_ID, count(SequenceID) as Quantity from t_sim_cards_info "
            + " where Is_Sold = 0 group by Customer_Group_ID, Product_ID order by Customer_Group_ID, Product_ID";

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();

        SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
        sqlQuery.addScalar("Product_ID", new IntegerType());
        sqlQuery.addScalar("Customer_Group_ID", new IntegerType());
        sqlQuery.addScalar("Quantity", new IntegerType());
        List records = sqlQuery.list();
%>

<!DOCTYPE html>
<html>
<head>
    <c:import url="../common/libs.jsp"/>
    <meta charset="utf-8">
    <title>SIM Information</title>
    <script language="javascript" src="/js/validate.js"></script>
</head>
<body>
<section id="container">
    <c:import url="../common/header.jsp"/>
    <c:import url="../common/menu.jsp"/>

    <section id="main-content">
        <section class="wrapper">
            <div class="row">
                <div class="col-lg-12 col-md-12">
                    <div class="container-fluid">
                        <form name="the_form" method="post" action="">
                            <a href="/masteradmin/SIM/AssignSIMs.jsp"> Assign SIMS</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <a href="/masteradmin/SIM/ShowSIMs.jsp"> Show SIMS</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <br><br>
                            <table width="100%" border="1">
                                <%
                                    for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                                        if (nIndex == 0) {
                                %>
                                <tr>
                                    <td align="left"> Product</td>
                                    <td align="left"> Unsold Quantity</td>
                                    <td align="left"> Customer Group</td>
                                </tr>
                                <%
                                    }
                                    Object[] oneRecord = (Object[]) records.get(nIndex);
                                    int nProduct_ID = (Integer) oneRecord[0];
                                    int nCustomerGroup_ID = (Integer) oneRecord[1];
                                    int nQuantity = (Integer) oneRecord[2];

                                    strQuery = "from TMasterProductinfo where Product_Active_Status = 1 and Product_ID = " + nProduct_ID;
                                    Query query = theSession.createQuery(strQuery);
                                    List prodList = query.list();
                                    String strProductName = "";
                                    if (prodList != null && prodList.size() > 0) {
                                        TMasterProductinfo prodInfo = (TMasterProductinfo) prodList.get(0);
                                        strProductName = prodInfo.getProductName();
                                    }

                                    String strCustomerGroupName = "UN ASSIGNED";
                                    if (nCustomerGroup_ID > 0) {
                                        strQuery = "from TMasterCustomerGroups where IsActive = 1 and Customer_Group_ID = " + nCustomerGroup_ID;
                                        query = theSession.createQuery(strQuery);
                                        List custList = query.list();

                                        if (custList != null && custList.size() > 0) {
                                            TMasterCustomerGroups custGroupInfo = (TMasterCustomerGroups) custList.get(0);
                                            strCustomerGroupName = custGroupInfo.getName();
                                        }
                                    }
                                %>
                                <tr>
                                    <td align="left">
                                        <%=strProductName%>
                                    </td>
                                    <td align="left">
                                        <%=nQuantity%>
                                    </td>
                                    <td align="left">
                                        <%=strCustomerGroupName%>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </table>
                        </form>

                        <%
                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                HibernateUtil.closeSession(theSession);
                            }
                        %>
                    </div>
                </div>
            </div>
        </section>
    </section>
</section>
</body>
</html>