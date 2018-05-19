<%@ page import="org.apache.commons.lang.math.NumberUtils" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    response.setContentType("text/xml");
    String strFailResult = "<the_response> <the_result code=\"0\"/> </the_response>";
    String strSuccessResult = "<the_response> <the_result code=\"1\"/> </the_response>";
    Session theSession = null;

    try {
        String strCustomerID = request.getParameter("customer_id");
        String strSupplierID = request.getParameter("supplier_id");

        int nCustomerId = 0;
        if (strCustomerID != null && !strCustomerID.isEmpty())
            nCustomerId = Integer.parseInt(strCustomerID);

        int nSupplierID = 0;
        if (strSupplierID != null && !strSupplierID.isEmpty())
            nSupplierID = Integer.parseInt(strSupplierID);

        if (nCustomerId <= 0 || nSupplierID <= 0) {
            response.getWriter().println(strFailResult);
            return;
        }

        DatabaseHelper dbHelper = new DatabaseHelper();
        int dbCustomerGroupID = dbHelper.GetCustomerGroupID(nCustomerId);

        DocumentBuilderFactory docBuildFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder docBuilder = docBuildFactory.newDocumentBuilder();
        Document doc = docBuilder.parse(request.getInputStream());
        NodeList modifedProducts = doc.getElementsByTagName("product");
        int nModifedProducts = modifedProducts.getLength();

        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

        for (int i = 0; i < nModifedProducts; i++) {
            Node theProductNode = modifedProducts.item(i);
            if (theProductNode.getNodeType() == Node.ELEMENT_NODE) {
                Element theProduct = (Element) theProductNode;
                String strProductID = theProduct.getAttribute("id");
                String strEeezeeTelCommission = theProduct.getAttribute("ee_comm");
                String strAgentCommission = theProduct.getAttribute("ag_comm");
                String strNotes = theProduct.getAttribute("notes");
                float fNewCommission = 0f;
                if (strEeezeeTelCommission != null && !strEeezeeTelCommission.isEmpty())
                    fNewCommission = Float.parseFloat(strEeezeeTelCommission);
                float fNewAgentCommission = 0f;
                if (strAgentCommission != null && !strAgentCommission.isEmpty())
                    fNewAgentCommission = Float.parseFloat(strAgentCommission);
                if (strNotes == null)
                    strNotes = "";

                String strQuery = " from TCustomerCommission where Product_ID = " + strProductID +
                        " and Customer_ID = " + nCustomerId;

                Query query = theSession.createQuery(strQuery);
                List theRecord = query.list();
                if (theRecord.size() > 0) {
                    TCustomerCommission custcomm = (TCustomerCommission) theRecord.get(0);
                    TMasterCustomerGroups custGroup = custcomm.getCustomer().getGroup();

                    if (custGroup.getId().intValue() == nCustomerGroupID) {
                        custcomm.setCommission(fNewCommission); // set group commission
                        custcomm.setAgentCommission(fNewAgentCommission);  // set agent commission
                        if (strNotes != null)
                            custcomm.setNotes(strNotes);
                        if (nSupplierID == TransferToServiceMain.TransferTo_SupplierID)
                            custcomm.setCommissionType((byte) 1);
                        theSession.save(custcomm);
                    }
                } else {
                    if (nCustomerGroupID == dbCustomerGroupID) {
                        TCustomerCommissionId custcommId = new TCustomerCommissionId();
                        custcommId.setCustomerId(nCustomerId);
                        custcommId.setProductId(Integer.parseInt(strProductID));

                        TCustomerCommission custcomm = new TCustomerCommission();
                        custcomm.setId(custcommId);
                        custcomm.setActiveStatus((byte) 1);
                        if (nSupplierID == TransferToServiceMain.TransferTo_SupplierID)
                            custcomm.setCommissionType((byte) 1);
                        else
                            custcomm.setCommissionType((byte) 0);
                        custcomm.setCommission(fNewCommission);
                        custcomm.setAgentCommission(fNewAgentCommission);
                        if (strNotes != null)
                            custcomm.setNotes(strNotes);
                        custcomm.setNotes(strNotes);
                        User theUser = new User();
                        theUser.setLogin(request.getRemoteUser());
                        custcomm.setUser(theUser);
                        Date dt = Calendar.getInstance().getTime();
                        custcomm.setCreationTime(dt);
                        custcomm.setLastModifiedTime(dt);

                        theSession.save(custcomm);
                    }
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
