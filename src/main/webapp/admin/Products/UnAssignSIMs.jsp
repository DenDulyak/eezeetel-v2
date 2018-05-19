<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<html>
<head>
    <script language="javascript" src="/js/validate.js"></script>
    <script language="javascript">
        function UnAssignSelectedSIMs() {
            document.the_form.un_assign_list.value = "";

            var contents = "";

            if (document.the_form.un_assign_sim[0]) {
                for (var i = 0, j = 0; i < document.the_form.un_assign_sim.length; i++)
                    if (document.the_form.un_assign_sim[i].checked == true) {
                        if (j > 0) contents += (",");
                        contents += (document.the_form.un_assign_sim[i].value);
                        j++;
                    }
            }
            else {
                contents = document.the_form.un_assign_sim.value;
            }

            document.the_form.un_assign_list.value = contents;

            document.the_form.action = "/admin/Products/UnAllocateSIMs.jsp";
            document.the_form.submit();
        }

        function ButtonClick() {
            if (document.the_form.Selectall.checked == true) {
                for (var i = 0; i < document.the_form.un_assign_sim.length; i++) {
                    document.the_form.un_assign_sim[i].checked = true;
                }
            }
            else {
                for (var i = 0; i < document.the_form.un_assign_sim.length; i++) {
                    document.the_form.un_assign_sim[i].checked = false;
                }
            }
        }
    </script>
</head>
<body>
<a href="/admin"> Admin Main </a>

<form name="the_form" method="post" action="">
    <%
        String strCustomerID = request.getParameter("customer_id");
        String strProductID = request.getParameter("product_id");

        int nCustomerID = 0;
        int nProductID = 0;

        if (strCustomerID != null && !strCustomerID.isEmpty())
            nCustomerID = Integer.parseInt(strCustomerID);

        if (strProductID != null && !strProductID.isEmpty())
            nProductID = Integer.parseInt(strProductID);

        if (nProductID <= 0 || nCustomerID <= 0)
            return;

        Session theSession = null;

        try {
            Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
            String strCustomerGroups = "" + nCustomerGroupID;
            if (nCustomerGroupID == 5)
                strCustomerGroups += ", 1";

            theSession = HibernateUtil.openSession();

            String strQuery = "from TSimCardsInfo where Customer_Group_ID in(" + strCustomerGroups + ")" +
                    " and Product_ID = " + nProductID + " and Customer_ID = " + nCustomerID +
                    " and Is_Sold = 1 order by SequenceID";

            Query query = theSession.createQuery(strQuery);
            List list = query.list();
    %>
    <table border="1" width="100%">
        <%
            for (int i = 0; i < list.size(); i++) {
                TSimCardsInfo simInfo = (TSimCardsInfo) list.get(i);

                strQuery = "from TMasterCustomerinfo where Customer_ID = " + simInfo.getCustomerId();
                query = theSession.createQuery(strQuery);
                List custList = query.list();

                String strCustomerName = "";

                if (custList.size() > 0) {
                    TMasterCustomerinfo custInfo = (TMasterCustomerinfo) custList.get(0);
                    strCustomerName = custInfo.getCompanyName();

                }

        %>
        <tr>
            <td>
                <input type="checkbox" name="un_assign_sim"
                       value="<%=simInfo.getId()%>"><%=simInfo.getSimCardId()%>
            </td>
            <td>
                <%=simInfo.getSimCardPin()%>
            </td>
            <td>
                <%=strCustomerName%>
            </td>
        </tr>
        <%
            }
            if (list.size() > 0) {
        %>
        <tr>
            <td><input type="button" name="un_assign_button" value="Un-Assign" onClick="UnAssignSelectedSIMs()"></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                HibernateUtil.closeSession(theSession);
            }
        %>

    </table>
    <input type="hidden" name="un_assign_list" value="">
</form>
</body>
<a href="/admin"> Admin Main </a>
</html>
