<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    int record_id = Integer.parseInt(request.getParameter("record_id"));
    int nProductID = Integer.parseInt(request.getParameter("product_name"));
    int nSupplierID = Integer.parseInt(request.getParameter("batch_supplied_by"));
    int nSaleInfoID = Integer.parseInt(request.getParameter("product_sale_id"));
    String strBatchID = request.getParameter("batch_id");
    int nQuantity = Integer.parseInt(request.getParameter("quantity"));
    int nAvailableQuantity = Integer.parseInt(request.getParameter("available_quantity"));
    float fProbableSalePrice = Float.parseFloat(request.getParameter("probable_sale_price"));
    float fPurchasePrice = Float.parseFloat(request.getParameter("unit_purchase_price"));
    int nMaxTopups = Integer.parseInt(request.getParameter("max_topus"));

    SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yyyy", Locale.ENGLISH);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);

    String strValue = request.getParameter("batch_arrival_date");
    Date dtArrivalDate = dt.parse(strValue);

    strValue = request.getParameter("batch_expiry_date");
    Date dtExpiryDate = dt.parse(strValue);

    strValue = request.getParameter("batch_activiated_by_supplier");

    boolean bBatchActivated = false;
    if (strValue != null && strValue.equalsIgnoreCase("on"))
        bBatchActivated = true;

    strValue = request.getParameter("batch_ready_to_sell");

    boolean bReadyToSell = false;
    if (strValue != null && strValue.equalsIgnoreCase("on"))
        bReadyToSell = true;

    String strAdditionalInfo = request.getParameter("additional_info");
    String strNotes = request.getParameter("notes");

    String strPaidToSupplier = request.getParameter("paid_to_supplier");
    boolean nPaidToSupplier = false;
    if (strPaidToSupplier != null && strPaidToSupplier.equalsIgnoreCase("on"))
        nPaidToSupplier = true;

    strValue = request.getParameter("batch_payment_date");
    Date dtPaymentDate = null;
    String strPaymentDate = "";
    if (strValue != null) {
        dtPaymentDate = dt.parse(strValue);
        strPaymentDate = sdf.format(dtPaymentDate);
    }

    String strBatchCost = request.getParameter("batch_cost");
    float fBatchCost = 0f;
    if (strBatchCost != null && !strBatchCost.isEmpty())
        fBatchCost = Float.parseFloat(strBatchCost);

    Session theSession = null;
    try {
        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        Boolean bFromHistory = false;
        String strQuery = "from TBatchInformation where SequenceID = " + record_id;
        Query query = theSession.createQuery(strQuery);
        List records = query.list();
        if (records.size() <= 0) {
            strQuery = "select * from t_history_batch_information where SequenceID = " + record_id;
            SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
            sqlQuery.addEntity(TBatchInformation.class);
            records = sqlQuery.list();
            bFromHistory = true;
        }

        if (records.size() > 0) {
            if (!bFromHistory) {
                TBatchInformation theBatch = (TBatchInformation) records.get(0);
                theBatch.setBatchId(strBatchID);

                TMasterSupplierinfo newSupplierInfo = new TMasterSupplierinfo();
                newSupplierInfo.setId(nSupplierID);
                theBatch.setSupplier(newSupplierInfo);

                TMasterProductinfo newProductInfo = new TMasterProductinfo();
                newProductInfo.setId(nProductID);
                theBatch.setProduct(newProductInfo);

                TMasterProductsaleinfo newProductSaleInfo = new TMasterProductsaleinfo();
                newProductSaleInfo.setId(nSaleInfoID);
                theBatch.setProductsaleinfo(newProductSaleInfo);
                theBatch.setProbableSalePrice(fProbableSalePrice);
                theBatch.setUnitPurchasePrice(fPurchasePrice);
                theBatch.setArrivalDate(dtArrivalDate);
                theBatch.setExpiryDate(dtExpiryDate);
                theBatch.setBatchActivatedBySupplier(bBatchActivated);
                theBatch.setBatchReadyToSell(bReadyToSell);
                theBatch.setAdditionalInfo(strAdditionalInfo);
                theBatch.setNotes(strNotes);
                theBatch.setLastModifiedTime(Calendar.getInstance().getTime());
                if (theBatch.getPaidToSupplier()) {
                    if (nPaidToSupplier) {
                        theBatch.setPaidToSupplier(nPaidToSupplier);
                        theBatch.setPaymentDateToSupplier(dtPaymentDate);
                    }
                }

                if (fBatchCost > 0)
                    theBatch.setBatchCost(fBatchCost);

                theSession.save(theBatch);
            } else {
                strQuery = "update t_history_batch_information set " +
                        " Paid_To_Supplier = " + nPaidToSupplier;
                if (strPaymentDate != null && !strPaymentDate.isEmpty() && nPaidToSupplier)
                    strQuery += ", Payment_Date_To_Supplier = '" + strPaymentDate + "'";
                if (fBatchCost > 0)
                    strQuery += ", Batch_Cost = " + fBatchCost;

                strQuery += " where SequenceID = " + record_id;
                SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
                sqlQuery.executeUpdate();
            }
        }

        theSession.getTransaction().commit();
        HibernateUtil.closeSession(theSession);

        theSession = HibernateUtil.openSession();
        theSession.beginTransaction();

        strQuery = "from TMasterProductinfo where Product_ID = " + nProductID;
        query = theSession.createQuery(strQuery);
        records = query.list();
        if (records.size() > 0) {
            TMasterProductinfo prodInfo = (TMasterProductinfo) records.get(0);
            if (prodInfo.getProductType().getId() == 17) {
                strQuery = "update t_sim_cards_info set Remaining_Topups = Remaining_Topups - Max_Topups + " + nMaxTopups +
                        " where Batch_Sequence_ID = " + record_id;
                SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
                sqlQuery.executeUpdate();

                strQuery = "update t_sim_cards_info set Max_Topups = " + nMaxTopups +
                        " where Batch_Sequence_ID = " + record_id;
                sqlQuery = theSession.createSQLQuery(strQuery);
                sqlQuery.executeUpdate();
            }
        }

        theSession.getTransaction().commit();
        response.sendRedirect("ManageBatchInfo.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        if (theSession != null)
            theSession.getTransaction().rollback();

        String strError = "<HTML><BODY><H4><FONT COLOR=\"RED\">Failed to Update Batch Information</FONT></H4>" +
                "<A HREF=\"ManageBatchInfo.jsp\">Manage Batch Information</A></BODY></HTML>";

        response.getWriter().println(strError);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
