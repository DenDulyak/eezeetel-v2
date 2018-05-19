<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    response.setContentType("text/xml");
    String strFailResult = "<the_response> <the_result code=\"0\"/> </the_response>";
    String strSuccessResult = "<the_response> <the_result code=\"1\"/> </the_response>";

    String strToCustomer = request.getParameter("to_customer_id");
    String strFromcustomer = request.getParameter("from_customer_id");
    String strSupplier = request.getParameter("supplier_id");
    String strCopyOnlyAgentCommission = request.getParameter("agent_commission_only");

    Boolean bAgentCommissionOnly = true;
    if (strCopyOnlyAgentCommission != null && !strCopyOnlyAgentCommission.isEmpty())
        bAgentCommissionOnly = Boolean.parseBoolean(strCopyOnlyAgentCommission);

    int nToCustomerID = 0;
    if (strToCustomer != null && !strToCustomer.isEmpty())
        nToCustomerID = Integer.parseInt(strToCustomer);

    int nFromCustomerID = 0;
    if (strFromcustomer != null && !strFromcustomer.isEmpty())
        nFromCustomerID = Integer.parseInt(strFromcustomer);

    int nSupplierId = 0;
    if (strSupplier != null && !strSupplier.isEmpty())
        nSupplierId = Integer.parseInt(strSupplier);

    if (nToCustomerID <= 0 || nFromCustomerID <= 0 || nSupplierId <= 0) {
        response.getWriter().println(strFailResult);
        return;
    }
    String strCountry = application.getInitParameter("Country");
    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");
    DatabaseHelper dbHelper = new DatabaseHelper();
    dbHelper.setCountry(strCountry);
    int nFromCustomerGroupID = dbHelper.GetCustomerGroupID(nFromCustomerID);
    int nToCustomerGroupID = dbHelper.GetCustomerGroupID(nToCustomerID);
    if (nCustomerGroupID != nToCustomerGroupID || nCustomerGroupID != nFromCustomerGroupID) {
        response.getWriter().println(strFailResult);
        return;
    }

    Session theSession = null;

    try {
        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        String strQuery = "from TMasterProductinfo where Product_Active_Status = 1 and Supplier_ID = " + nSupplierId;
        Query query = theSession.createQuery(strQuery);
        List theProducts = query.list();
        for (int nProduct = 0; nProduct < theProducts.size(); nProduct++) {
            TMasterProductinfo prodInfo = (TMasterProductinfo) theProducts.get(nProduct);

            strQuery = " from TCustomerCommission where Product_ID = " + prodInfo.getId() +
                    " and Customer_ID = " + nFromCustomerID;

            query = theSession.createQuery(strQuery);
            List theRecord = query.list();
            if (theRecord.size() > 0) {
                TCustomerCommission custFromcomm = (TCustomerCommission) theRecord.get(0);

                strQuery = " from TCustomerCommission where Product_ID = " + prodInfo.getId() +
                        " and Customer_ID = " + nToCustomerID;

                query = theSession.createQuery(strQuery);
                theRecord = query.list();
                if (theRecord.size() > 0) {
                    TCustomerCommission custTocomm = (TCustomerCommission) theRecord.get(0);

                    if (!bAgentCommissionOnly)
                        custTocomm.setCommission(custFromcomm.getCommission());
                    custTocomm.setAgentCommission(custFromcomm.getAgentCommission());
                    custTocomm.setNotes(custFromcomm.getNotes());
                    if (nSupplierId == TransferToServiceMain.TransferTo_SupplierID)
                        custTocomm.setCommissionType((byte) 1);
                    theSession.save(custTocomm);
                } else {
                    // new entry

                    TCustomerCommission custTocomm = new TCustomerCommission();
                    custTocomm.setId(custFromcomm.getId());
                    custTocomm.getId().setCustomerId(nToCustomerID);
                    custTocomm.setActiveStatus((byte) 1);
                    if (nSupplierId == TransferToServiceMain.TransferTo_SupplierID)
                        custTocomm.setCommissionType((byte) 1);
                    else
                        custTocomm.setCommissionType((byte) 0);
                    custTocomm.setCommission(custFromcomm.getCommission());
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