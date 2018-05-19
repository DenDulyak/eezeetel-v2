<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<%
    String userAgent = request.getHeader("User-Agent");
    String strButtonStyle = "product_type";
    if (userAgent.compareToIgnoreCase("CallingCardsApp") == 0)
        strButtonStyle = "product_type_till";

    String strResponse = "";
    Session theSession = null;
    try {
        String strSupplierID = request.getParameter("supplier_type_id");

        String strIsSIM = request.getParameter("is_sim");
        int isSim = 0;
        if (strIsSIM != null && !strIsSIM.isEmpty())
            isSim = Integer.parseInt(strIsSIM);
        if (isSim < 0 || isSim > 1)
            isSim = 0;

        theSession = HibernateUtil.openSession();

        String strQuery = "from TMasterSupplierinfo where Supplier_ID != " + TransferToServiceMain.TransferTo_SupplierID +
                " and Supplier_Active_Status = 1 and Secondary_Supplier = 0 and Supplier_Type_ID in (" + strSupplierID +
                ") order by Supplier_Name";

        Query query1 = theSession.createQuery(strQuery);
        List suppliers = query1.list();

        String skipUsers[] = {"eeztel", "DEVI", "raghu", "raghu1", "eezee1001", "eezeedemo", "eeztel"};
        boolean skipSupplier = true;
        for (int jj = 0; jj < skipUsers.length; jj++) {
            if (skipUsers[jj].compareToIgnoreCase(request.getRemoteUser()) == 0)
                skipSupplier = false;
        }

        strResponse += "<ul class='list-inline text-center'>";

        for (int nIndex = 0, nDisplayedCards = 0; nIndex < suppliers.size(); nIndex++) {
            TMasterSupplierinfo oneSupplier = (TMasterSupplierinfo) suppliers.get(nIndex);
            if (oneSupplier.getId() == 22 && skipSupplier)
                continue;

            strResponse += "<li>";

            String strSupplierImage = oneSupplier.getSupplierImage();

            if (strSupplierImage != null && !strSupplierImage.isEmpty()) {
                if (strSupplierImage.contains("Product_Images")) {
                    strSupplierImage = strSupplierImage.replace("Product_Images", "images");
                }

                strResponse += "<img class='" + strButtonStyle + "' src='" + strSupplierImage + "'";

                if (isSim == 1)
                    strResponse += " onClick='javascript:list_sim_products(" + oneSupplier.getId() + ")'";
                else
                    strResponse += " onclick='showProductsBySupplier(" + oneSupplier.getId() + ")'";

                strResponse += " alt='" + oneSupplier.getSupplierName() + "'/>";
            } else {
                strResponse += "<a class='productsButton'";
                if (isSim == 1)
                    strResponse += " onClick='javascript:list_sim_products(" + oneSupplier.getId() + ")'";
                else
                    strResponse += " onClick='showProductsBySupplier(" + oneSupplier.getId() + ")'";

                strResponse += "> " + oneSupplier.getSupplierName() + "</a>";
            }

            strResponse += "</li>";

            nDisplayedCards++;
        }

        strResponse += "</ul>";

        response.setContentType("text/html");
        response.getWriter().println(strResponse);
    } catch (Exception e) {
        e.printStackTrace();
        response.setContentType("text/html");
        response.getWriter().println("");
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>