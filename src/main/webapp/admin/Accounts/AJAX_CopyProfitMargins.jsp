<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    response.setContentType("text/xml");
    String strFailResult = "<the_response> <the_result code=\"0\"/> </the_response>";
    String strSuccessResult = "<the_response> <the_result code=\"1\"/> </the_response>";

    String strAgent = request.getParameter("agent_id");
    String strFromcustomer = request.getParameter("from_customer_id");
    String strToCustomer = request.getParameter("to_customer_id");
    String strSupplier = request.getParameter("supplier_id");
    String strProduct = request.getParameter("product_id");
    String strCopyType = request.getParameter("copy_type");

    int nFromCustomerID = 0;
    if (strFromcustomer != null && !strFromcustomer.isEmpty())
        nFromCustomerID = Integer.parseInt(strFromcustomer);

    int nToCustomerID = 0;
    if (strToCustomer != null && !strToCustomer.isEmpty())
        nToCustomerID = Integer.parseInt(strToCustomer);

    int nSupplierId = 0;
    if (strSupplier != null && !strSupplier.isEmpty())
        nSupplierId = Integer.parseInt(strSupplier);

    int nProductID = 0;
    if (strProduct != null && !strProduct.isEmpty())
        nProductID = Integer.parseInt(strProduct);

    if (nFromCustomerID <= 0 || strAgent == null || strAgent.isEmpty()) {
        response.getWriter().println(strFailResult);
        return;
    }

    int nCopyType = 3;
    if (strCopyType != null && !strCopyType.isEmpty())
        nCopyType = Integer.parseInt(strCopyType);

    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

    Session theSession = null;

    try {
        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        String strQuery = "from TMasterProductinfo where Product_Active_Status = 1";
        if (nSupplierId != 0)
            strQuery += " and Supplier_ID = " + nSupplierId;
        if (nProductID != 0)
            strQuery += " and Product_ID = " + nProductID;

        Query query = theSession.createQuery(strQuery);
        List theProducts = query.list();
        for (int nProduct = 0; nProduct < theProducts.size(); nProduct++) {
            TMasterProductinfo prodInfo = (TMasterProductinfo) theProducts.get(nProduct);

            strQuery = " from TCustomerCommission where Product_ID = " + prodInfo.getId() +
                    " and Customer_ID = " + nFromCustomerID;

            query = theSession.createQuery(strQuery);
            List theRecord = query.list();
            if (theRecord.size() <= 0) continue;  // NO From Commission to Copy

            TCustomerCommission custFromcomm = (TCustomerCommission) theRecord.get(0);

            strQuery = " from TMasterCustomerinfo where Customer_Group_ID = " + nCustomerGroupID;
            if (strAgent != null && !strAgent.isEmpty())
                strQuery += " and Customer_Introduced_By = '" + strAgent + "'";

            if (nToCustomerID == 0)
                strQuery += " and Customer_ID != " + nFromCustomerID;
            else
                strQuery += " and Customer_ID = " + nToCustomerID;

            query = theSession.createQuery(strQuery);
            List custList = query.list();

            for (int nCustomer = 0; nCustomer < custList.size(); nCustomer++) {
                TMasterCustomerinfo custInfo = (TMasterCustomerinfo) custList.get(nCustomer);

                strQuery = " from TCustomerCommission where Product_ID = " + prodInfo.getId() +
                        " and Customer_ID = " + custInfo.getId();

                query = theSession.createQuery(strQuery);
                theRecord = query.list();
                if (theRecord.size() > 0) {
                    TCustomerCommission custTocomm = (TCustomerCommission) theRecord.get(0);

                    if (nCopyType == 1 || nCopyType == 2)
                        custTocomm.setCommission(custFromcomm.getCommission());

                    if (nCopyType == 1 || nCopyType == 3)
                        custTocomm.setAgentCommission(custFromcomm.getAgentCommission());

                    custTocomm.setNotes(custFromcomm.getNotes());
                    if (nSupplierId == TransferToServiceMain.TransferTo_SupplierID)
                        custTocomm.setCommissionType((byte) 1);
                    theSession.save(custTocomm);
                } else {
                    // new entry
                    TCustomerCommission custTocomm = new TCustomerCommission();
                    custTocomm.setId(custFromcomm.getId());
                    custTocomm.getId().setCustomerId(custInfo.getId());
                    custTocomm.setActiveStatus((byte) 1);
                    if (nSupplierId == TransferToServiceMain.TransferTo_SupplierID)
                        custTocomm.setCommissionType((byte) 1);
                    else
                        custTocomm.setCommissionType((byte) 0);
                    custTocomm.setCommission(0); // default value
                    custTocomm.setAgentCommission(0); // default value

                    if (nCopyType == 1 || nCopyType == 2)
                        custTocomm.setCommission(custFromcomm.getCommission());

                    if (nCopyType == 1 || nCopyType == 3)
                        custTocomm.setAgentCommission(custFromcomm.getAgentCommission());

                    custTocomm.setNotes(custFromcomm.getNotes());
                    User theUser = new User();
                    theUser.setLogin(request.getRemoteUser());
                    custTocomm.setUser(theUser);
                    Date dt = Calendar.getInstance().getTime();
                    custTocomm.setCreationTime(dt);
                    custTocomm.setLastModifiedTime(dt);

                    theSession.save(custTocomm);
                }
            }
        }

        theSession.getTransaction().commit();
        response.getWriter().println(strSuccessResult);
    } catch (Exception e) {
        e.printStackTrace();
        theSession.getTransaction().rollback();
        response.getWriter().println(strFailResult);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>