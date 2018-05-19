<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<div class="container-fluid">
    <form name="the_form" action="">
        <table class="table table-bordered">
            <thead>
            <tr>
                <th></th>
                <th>Name</th>
                <th>Type</th>
                <th>Contact</th>
                <th>Secondary Supplier</th>
                <th>Address Line1</th>
                <th>Address Line2</th>
                <th>Address Line3</th>
                <th>City</th>
                <th>State</th>
                <th>Postal Code</th>
                <th>Country</th>
                <th>Primary Phone</th>
                <th>Secondary Phone</th>
                <th>Mobile Phone</th>
                <th>Web Site Address</th>
                <th>Email Id</th>
                <th>Created By</th>
                <th>Introduced By</th>
                <th>Modified Time</th>
                <th>Creation Time</th>
                <th>Notes</th>
                <th>Active Status</th>
            </tr>
            </thead>
            <%
                String strQuery = "from TMasterSupplierinfo order by Supplier_Active_Status desc, Supplier_Name";

                Session theSession = null;
                try {
                    theSession = HibernateUtil.openSession();
                    Query query = theSession.createQuery(strQuery);
                    List records = query.list();

                    for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                        TMasterSupplierinfo suppInfo = (TMasterSupplierinfo) records.get(nIndex);
                        TMasterSuppliertype suppType = suppInfo.getSupplierType();
                        User userInfo = suppInfo.getUser();

                        String strIsActive = suppInfo.getActive() ? "Yes" : "No";
                        String strBgColor = suppInfo.getActive() ? "active" : "danger";
                        String strSecondarySup = (suppInfo.getSecondarySupplier() == 0) ? "No" : "Yes";
            %>

            <tr class="<%=strBgColor%>">
                <td align="right">
                    <input type="radio" name="record_id" value="<%=suppInfo.getId()%>">
                </td>
                <td align="left"><%=suppInfo.getSupplierName()%>
                </td>
                <td align="left"><%=suppType.getSupplierType()%>
                </td>
                <td align="left"><%=suppInfo.getSupplierContact()%>
                </td>
                <td align="left"><%=strSecondarySup%>
                </td>
                <td align="left"><%=suppInfo.getSupplierAddressLine1()%>
                </td>
                <td align="left"><%=suppInfo.getSupplierAddressLine2()%>
                </td>
                <td align="left"><%=suppInfo.getSupplierAddressLine3()%>
                </td>
                <td align="left"><%=suppInfo.getSupplierCity()%>
                </td>
                <td align="left"><%=suppInfo.getSupplierState()%>
                </td>
                <td align="left"><%=suppInfo.getSupplierPostalCode()%>
                </td>
                <td align="left"><%=suppInfo.getSupplierCountry()%>
                </td>
                <td align="left"><%=suppInfo.getSupplierPrimaryPhone()%>
                </td>
                <td align="left"><%=suppInfo.getSupplierSecondaryPhone()%>
                </td>
                <td align="left"><%=suppInfo.getSupplierMobilePhone()%>
                </td>
                <td align="left"><%=suppInfo.getSupplierWebsiteAddress()%>
                </td>
                <td align="left"><%=suppInfo.getSupplierEmailId()%>
                </td>
                <td align="left"><%=userInfo.getUserFirstName()%>
                </td>
                <td align="left"><%=suppInfo.getSupplierIntroducedBy()%>
                </td>
                <td align="left"><%=suppInfo.getSupplierInfoModifiedTime()%>
                </td>
                <td align="left"><%=suppInfo.getSupplierInfoCreationTime()%>
                </td>
                <td align="left"><%=suppInfo.getNotes()%>
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
                <jsp:param name="follow_up_page" value="SupplierInfo"/>
            </jsp:include>
        </table>
    </form>
</div>

<script src="${pageContext.request.contextPath}/js/validate.js"></script>
