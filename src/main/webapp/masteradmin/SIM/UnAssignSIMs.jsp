<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>Un-Assign SIMS to Customer groups</title>
    <script language="javascript" src="/GenericApp/Scripts/Validate.js"></script>
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

            document.the_form.action = "/masteradmin/SIM/UnAllocateSIMs.jsp";
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
<form name="the_form" method="post" action="">

    <input type=checkbox name=Selectall onclick=ButtonClick()> Select All
    <table border="1" width="100%">
        <%
            String strCustomerGroupID = request.getParameter("customer_group_id");
            String strProductID = request.getParameter("product_id");

            int nCustomerGroupID = 0;
            int nProductID = 0;

            if (strCustomerGroupID != null && !strCustomerGroupID.isEmpty())
                nCustomerGroupID = Integer.parseInt(strCustomerGroupID);

            if (strProductID != null && !strProductID.isEmpty())
                nProductID = Integer.parseInt(strProductID);

            if (nProductID <= 0 || nCustomerGroupID <= 0) {
                return;
            }

            Session theSession = null;

            try {
                theSession = HibernateUtil.openSession();

                String strQuery = "from TSimCardsInfo where Customer_Group_ID = " + nCustomerGroupID +
                        " and Product_ID = " + nProductID +
                        " and Is_Sold = 0 order by Customer_Group_ID, SequenceID";

                Query query = theSession.createQuery(strQuery);
                List list = query.list();

                for (int i = 0; i < list.size(); i++) {
                    TSimCardsInfo simInfo = (TSimCardsInfo) list.get(i);
        %>
        <tr>
            <td><input type="checkbox" name="un_assign_sim"
                       value="<%=simInfo.getId()%>"><%=simInfo.getSimCardId()%>
            </td>
        </tr>
        <%
            }

            if (list.size() > 0) {
        %>
        <tr>
            <td><input type="button" name="un_assign_button" value="Un-Assign Selected SIMs"
                       onClick="UnAssignSelectedSIMs()"></td>
            <td><a href="/masteradmin/MasterInformation.jsp"> Go to Main </a></td>
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
</html>