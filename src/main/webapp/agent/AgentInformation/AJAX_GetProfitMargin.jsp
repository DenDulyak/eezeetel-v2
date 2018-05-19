<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%
    String strCountryCode = application.getInitParameter("Country");
    String strSupplier = request.getParameter("supplier_id");
    String strCustomer = request.getParameter("customer_id");

    String strQuery = "from TMasterProductinfo where Product_Active_Status = 1";
    if (strSupplier != null && !strSupplier.isEmpty())
        strQuery += (" AND Supplier_ID = " + Integer.parseInt(strSupplier));
    strQuery += " order by Product_Name";

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        Query query = theSession.createQuery(strQuery);
        List records = query.list();

        String strResult = "<table border=\"1\"><tr>";
        strResult += "<td align=center><b>Product Name</b></td>";
        strResult += "<td align=center><b>Commission</b></td>";

        for (int nIndex = 0; nIndex < records.size(); nIndex++) {
            TMasterProductinfo prodInfo = (TMasterProductinfo) records.get(nIndex);

            String strQuery_new = "from TCustomerCommission where Product_ID = " + prodInfo.getId();
            strQuery_new += (" AND Customer_ID = " + Integer.parseInt(strCustomer));

            Query query_new = theSession.createQuery(strQuery_new);
            List records_new = query_new.list();

            float fAgentCommission = 0;
            if (records_new.size() == 1) {
                TCustomerCommission custcomm = (TCustomerCommission) records_new.get(0);
                TMasterCustomerinfo custInfo = custcomm.getCustomer();
                User user = custInfo.getIntroducedBy();
                if (user.getLogin().compareToIgnoreCase(request.getRemoteUser()) == 0)
                    fAgentCommission = custcomm.getAgentCommission();
            }

            strResult += "<tr>";
            strResult += "<td align=left>" + prodInfo.getProductName() + " - " + prodInfo.getProductFaceValue() + "</td>";
            strResult += "<td align=left>" + fAgentCommission + "</td>";
            strResult += "</tr>";
        }

        strResult += "</table>";

        response.setContentType("text/html");
        response.getWriter().println(strResult);
    } catch (Exception e) {
        e.printStackTrace();
        String strResult = "<table></table>";
        response.setContentType("text/html");
        response.getWriter().println(strResult);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
