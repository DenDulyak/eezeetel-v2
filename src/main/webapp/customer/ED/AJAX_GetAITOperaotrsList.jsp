<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    response.setContentType("text/html");
    String strCountryISDCode = request.getParameter("country_code");

    if (strCountryISDCode == null || strCountryISDCode.isEmpty()) {
        response.getWriter().print("");
        return;
    }

    List<DingMain.OperatorDetails> listOperators = null;
    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();

        String strUserID = request.getRemoteUser();
        String strQuery = "from TCustomerUsers where User_Login_ID = '" + strUserID + "'";
        Query query = theSession.createQuery(strQuery);
        List listCustomerID = query.list();
        if (listCustomerID.size() > 0) {
            TCustomerUsers custUsers = (TCustomerUsers) listCustomerID.get(0);
            TMasterCustomerinfo custInfo = custUsers.getCustomer();
            DingMain dingService = new DingMain(custInfo.getId(), strUserID);
            listOperators = dingService.GetOperatorList(strCountryISDCode);
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().print("");
        return;
    } finally {
        HibernateUtil.closeSession(theSession);
    }

    if (listOperators != null && listOperators.size() > 0) {
%>
<label class="control-label col-sm-6">Operator:</label>
<div class="col-sm-6">
    <select id="operators_list" name="operators_list" class="form-control">
        <option value="">Select</option>
        <%
            for (DingMain.OperatorDetails opDetails : listOperators) {
        %>
        <option value="<%=opDetails.strOperatorCode%>">
            <%=opDetails.strOperator%>
        </option>
        <%
            }
        %>
    </select>
</div>
<%
    } else {
        response.getWriter().print("");
        return;
    }
%>
