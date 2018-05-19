package com.eezeetel.job;

import com.eezeetel.customerapp.ProcessTransaction;
import com.eezeetel.entity.*;
import com.eezeetel.enums.TransactionStatus;
import com.eezeetel.service.TransactionService;
import com.eezeetel.util.HibernateUtil;
import org.apache.log4j.Logger;
import org.hibernate.LockMode;
import org.hibernate.Query;
import org.hibernate.Session;
import org.quartz.*;
import org.springframework.scheduling.quartz.QuartzJobBean;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

@PersistJobDataAfterExecution
@DisallowConcurrentExecution
public class TransactionPostProcess extends QuartzJobBean {

    private static Logger log = Logger.getLogger(TransactionPostProcess.class);

    private ProcessTransaction processTransaction;
    private TransactionService transactionService;

    @Override
    protected void executeInternal(JobExecutionContext jobExecutionContext) throws JobExecutionException {
        JobDataMap dataMap = jobExecutionContext.getJobDetail().getJobDataMap();
        processTransaction = (ProcessTransaction) dataMap.get("processTransaction");
        transactionService = (TransactionService) dataMap.get("transactionService");

        log.info("Rollback Transactions.");
        rollbackTransactions();
        log.info("Rollback Transactions. -- Done.");

        log.info("Compute Incremental Profits.");
        ComputeIncrementalProfits();
        log.info("Compute Incremental Profits. -- Done.");

        log.info("Compute Incremental TransferToProfits.");
        ComputeIncrementalTransferToProfits();
        log.info("Compute Incremental TransferToProfits. -- Done.");

        log.info("Compute Incremental DingProfits.");
        ComputeIncrementalDingProfits();
        log.info("Compute Incremental DingProfits. -- Done.");

        log.info("Compute Incremental SIMCardProfit.");
        ComputeIncrementalSIMCardProfit();
        log.info("Compute Incremental SIMCardProfit. -- Done.");

        log.info("Compute Incremental MobitopupProfits.");
        ComputeIncrementalMobitopupProfits();
        log.info("Compute Incremental MobitopupProfits. -- Done.");

        log.info("Compute Incremental MobileUnlockingProfits.");
        ComputeIncrementalMobileUnlockingPofits();
        log.info("Compute Incremental MobileUnlockingProfits. -- Done.");

        log.info("Compute Incremental PinlessProfits.");
        ComputeIncrementalPinlessProfits();
        log.info("Compute Incremental PinlessProfits. -- Done.");
    }

    public void rollbackTransactions() {
        try {
            Date today = new Date();
            long time_in_milli_seconds = today.getTime();
            time_in_milli_seconds -= 180000L;
            today.setTime(time_in_milli_seconds);

            List<TTransactions> transactions = transactionService.findByCommitted((byte) TransactionStatus.PROCESSED.ordinal());
            if (!transactions.isEmpty()) {
                for (TTransactions transaction : transactions) {
                    if (transaction.getTransactionTime().before(today)) {
                        processTransaction.cancel(transaction.getTransactionId());
                    }
                }
            }
        } catch (Exception e) {
            log.info("ERROR : " + e.getMessage());
            e.printStackTrace();
        }
    }

    public boolean ComputeIncrementalProfits() {
        Session theSession = null;
        long nTransactionID = 0L;

        try {
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();

            String strQuery = "from TTransactions qc where Committed = 1  and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)  and Product_ID != 146 and Post_Processing_Stage = 0";

            Query query = theSession.createQuery(strQuery);
            List transList = query.list();
            for (int i = 0; i < transList.size(); i++) {
                TTransactions theTransaction = (TTransactions) transList.get(i);
                nTransactionID = theTransaction.getTransactionId();

                TMasterCustomerinfo custInfo = theTransaction.getCustomer();
                TBatchInformation theBatch = theTransaction.getBatch();

                Calendar dtBegin = Calendar.getInstance();
                dtBegin.setTime(theTransaction.getTransactionTime());
                Calendar dtEnd = Calendar.getInstance();
                dtEnd.setTime(theTransaction.getTransactionTime());
                dtEnd.add(2, 1);

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-01 00:00:00", Locale.ENGLISH);
                String strBeginDate = sdf.format(dtBegin.getTime());
                String strEndDate = sdf.format(dtEnd.getTime());

                Date dateBegin;
                Date dateEnd;
                try {
                    dateBegin = sdf.parse(strBeginDate);
                    dateEnd = sdf.parse(strEndDate);
                } catch (ParseException e) {
                    log.error("Parse Exception. Date Begin - " + strBeginDate + ". Date End - " + strEndDate);
                    e.printStackTrace();
                    continue;
                }
                strQuery = "from TReportCustomerProfit qc1 where Customer_ID = " + custInfo.getId() + " and Product_ID = "
                        + theTransaction.getProduct().getId() + " and Begin_Date = '" + strBeginDate
                        + "' and End_Date = '" + strEndDate + "'";

                Query query2 = theSession.createQuery(strQuery);
                query2.setLockMode("qc1", LockMode.PESSIMISTIC_WRITE);
                List cust_profit_list = query2.list();

                float fCustComm;
                float fAgentComm;
                float fGroupComm;
                float fEezeeComm;

                boolean bLocalMobile = false;
                if (theTransaction.getProduct().getSupplier().getSupplierType().getId() == 16) {
                    bLocalMobile = true;
                }
                float fCustomerVAT = 0.0F;
                float fAgentVAT = 0.0F;
                float fGroupVAT = 0.0F;
                float fEezeeTelVAT = 0.0F;
                if (theTransaction.getProduct().getCalculateVat() == 1) {
                    fCustomerVAT = theBatch.getProbableSalePrice() * theTransaction.getQuantity() - theTransaction.getUnitPurchasePrice();
                    fCustomerVAT -= fCustomerVAT / 1.2F;
                    fAgentVAT = theTransaction.getUnitPurchasePrice() - theTransaction.getSecondaryTransactionPrice();
                    fAgentVAT -= fAgentVAT / 1.2F;
                    fGroupVAT = theTransaction.getSecondaryTransactionPrice() - theTransaction.getUnitGroupPrice();
                    fGroupVAT -= fGroupVAT / 1.2F;
                    fEezeeTelVAT = theTransaction.getUnitGroupPrice() - theTransaction.getQuantity() * theBatch.getBatchCost();
                    fEezeeTelVAT -= fEezeeTelVAT / 1.2F;
                    if (custInfo.getGroup().getId() == 1) {
                        fEezeeTelVAT += fGroupVAT;
                        fGroupVAT = fEezeeTelVAT;
                    }
                }
                if (cust_profit_list.size() > 0) {
                    TReportCustomerProfit custProfit = (TReportCustomerProfit) cust_profit_list.get(0);

                    custProfit.setBatchOriginalCost(custProfit.getBatchOriginalCost() + theTransaction.getQuantity()
                            * theBatch.getBatchCost());
                    custProfit.setQuantity(custProfit.getQuantity() + theTransaction.getQuantity());
                    custProfit.setBatchCost(custProfit.getBatchCost() + theTransaction.getBatchUnitPrice());
                    custProfit.setCostToGroup(custProfit.getCostToGroup() + theTransaction.getUnitGroupPrice());
                    custProfit.setCostToAgent(custProfit.getCostToAgent() + theTransaction.getSecondaryTransactionPrice());
                    custProfit.setCostToCustomer(custProfit.getCostToCustomer() + theTransaction.getUnitPurchasePrice());

                    custProfit.setCustomerVat(fCustomerVAT + custProfit.getCustomerVat());
                    custProfit.setAgentVat(fAgentVAT + custProfit.getAgentVat());
                    custProfit.setGroupVat(fGroupVAT + custProfit.getGroupVat());
                    custProfit.setEezeeTelVat(fEezeeTelVAT + custProfit.getEezeeTelVat());

                    theSession.save(custProfit);

                    fCustComm = custProfit.getRetailCost() * theTransaction.getQuantity() - theTransaction.getUnitPurchasePrice();
                    fAgentComm = theTransaction.getUnitPurchasePrice() - theTransaction.getSecondaryTransactionPrice();
                    fGroupComm = theTransaction.getSecondaryTransactionPrice() - theTransaction.getUnitGroupPrice();
                    fEezeeComm = theTransaction.getUnitGroupPrice() - theTransaction.getQuantity() * theBatch.getBatchCost();
                    if (custInfo.getGroup().getId() == 1) {
                        fEezeeComm += fGroupComm;
                    }
                } else {
                    TReportCustomerProfit custProfit = new TReportCustomerProfit();
                    custProfit.setBeginDate(dateBegin);
                    custProfit.setEndDate(dateEnd);
                    custProfit.setCustomer(custInfo);
                    custProfit.setGroup(custInfo.getGroup());
                    custProfit.setAgentId(custInfo.getIntroducedBy().getLogin());
                    custProfit.setProduct(theTransaction.getProduct());
                    custProfit.setQuantity(theTransaction.getQuantity());
                    custProfit.setRetailCost(theBatch.getProbableSalePrice());
                    custProfit.setCostToCustomer(theTransaction.getUnitPurchasePrice());
                    custProfit.setCostToAgent(theTransaction.getSecondaryTransactionPrice());
                    custProfit.setCostToGroup(theTransaction.getUnitGroupPrice());
                    custProfit.setBatchCost(theTransaction.getBatchUnitPrice());
                    custProfit.setBatchOriginalCost(theTransaction.getQuantity() * theBatch.getBatchCost());
                    custProfit.setCustomerVat(fCustomerVAT);
                    custProfit.setAgentVat(fAgentVAT);
                    custProfit.setGroupVat(fGroupVAT);
                    custProfit.setEezeeTelVat(fEezeeTelVAT);

                    theSession.save(custProfit);

                    fCustComm = custProfit.getRetailCost() * theTransaction.getQuantity() - theTransaction.getUnitPurchasePrice();
                    fAgentComm = theTransaction.getUnitPurchasePrice() - theTransaction.getSecondaryTransactionPrice();
                    fGroupComm = theTransaction.getSecondaryTransactionPrice() - theTransaction.getUnitGroupPrice();
                    fEezeeComm = theTransaction.getUnitGroupPrice() - theTransaction.getQuantity() * theBatch.getBatchCost();
                    if (custInfo.getGroup().getId() == 1) {
                        fEezeeComm += fGroupComm;
                    }
                }
                strQuery = "from TReportGroupProfit qc1 where Customer_ID = " + custInfo.getId()
                        + " and Begin_Date = '" + strBeginDate + "' and End_Date = '" + strEndDate + "'";

                query2 = theSession.createQuery(strQuery);
                query2.setLockMode("qc1", LockMode.PESSIMISTIC_WRITE);
                List group_profit_list = query2.list();
                if (group_profit_list.size() > 0) {
                    TReportGroupProfit groupProfit = (TReportGroupProfit) group_profit_list.get(0);

                    groupProfit.setCustomerCommission(groupProfit.getCustomerCommission() + fCustComm);
                    groupProfit.setAgentCommission(groupProfit.getAgentCommission() + fAgentComm);
                    groupProfit.setTotalAmount(groupProfit.getTotalAmount() + theTransaction.getUnitGroupPrice());

                    groupProfit.setCustomerVat(groupProfit.getCustomerVat() + fCustomerVAT);
                    groupProfit.setAgentVat(groupProfit.getAgentVat() + fAgentVAT);
                    groupProfit.setGroupVat(groupProfit.getGroupVat() + fGroupVAT);
                    groupProfit.setEezeeTelVat(groupProfit.getEezeeTelVat() + fEezeeTelVAT);
                    if (bLocalMobile) {
                        groupProfit.setProfitFromLocalMobile(groupProfit.getProfitFromLocalMobile() + fGroupComm);
                        groupProfit.setEezeeTelLocalMobileProfit(groupProfit.getEezeeTelLocalMobileProfit() + fEezeeComm);
                        groupProfit.setTotalLocalMobileTransactions(groupProfit.getTotalLocalMobileTransactions()
                                + theTransaction.getQuantity());
                    } else {
                        groupProfit.setProfitFromCallingCards(groupProfit.getProfitFromCallingCards() + fGroupComm);
                        groupProfit.setEezeeTelCardsProfit(groupProfit.getEezeeTelCardsProfit() + fEezeeComm);
                        groupProfit.setTotalCards(groupProfit.getTotalCards() + theTransaction.getQuantity());
                    }
                    theSession.save(groupProfit);
                } else {
                    TReportGroupProfit groupProfit = new TReportGroupProfit();

                    groupProfit.setBeginDate(dateBegin);
                    groupProfit.setEndDate(dateEnd);
                    groupProfit.setCustomer(custInfo);
                    groupProfit.setGroup(custInfo.getGroup());
                    groupProfit.setAgentId(custInfo.getIntroducedBy().getLogin());
                    groupProfit.setTotalWorldMobileTransactions(0);
                    groupProfit.setTotalAmount(theTransaction.getUnitGroupPrice());
                    groupProfit.setCustomerCommission(fCustComm);
                    groupProfit.setAgentCommission(fAgentComm);
                    groupProfit.setProfitFromWorldMobile(0.0F);
                    groupProfit.setEezeeTelWorldMobileProfit(0.0F);

                    groupProfit.setCustomerVat(fCustomerVAT);
                    groupProfit.setAgentVat(fAgentVAT);
                    groupProfit.setGroupVat(fGroupVAT);
                    groupProfit.setEezeeTelVat(fEezeeTelVAT);
                    if (bLocalMobile) {
                        groupProfit.setTotalCards(0);
                        groupProfit.setTotalLocalMobileTransactions(theTransaction.getQuantity());
                        groupProfit.setProfitFromCallingCards(0.0F);
                        groupProfit.setProfitFromLocalMobile(fGroupComm);
                        groupProfit.setEezeeTelCardsProfit(0.0F);
                        groupProfit.setEezeeTelLocalMobileProfit(fEezeeComm);
                    } else {
                        groupProfit.setTotalCards(theTransaction.getQuantity());
                        groupProfit.setTotalLocalMobileTransactions(0);
                        groupProfit.setProfitFromCallingCards(fGroupComm);
                        groupProfit.setProfitFromLocalMobile(0.0F);
                        groupProfit.setEezeeTelCardsProfit(fEezeeComm);
                        groupProfit.setEezeeTelLocalMobileProfit(0.0F);
                    }
                    theSession.save(groupProfit);
                }
                strQuery = "from TReportEezeetelProfit qc1 where Customer_Group_ID = "
                        + custInfo.getGroup().getId() + " and Begin_Date = '" + strBeginDate
                        + "' and End_Date = '" + strEndDate + "'";

                query2 = theSession.createQuery(strQuery);
                query2.setLockMode("qc1", LockMode.PESSIMISTIC_WRITE);
                List eezeetel_profit_list = query2.list();
                if (eezeetel_profit_list.size() > 0) {
                    TReportEezeetelProfit eezeeTelProfit = (TReportEezeetelProfit) eezeetel_profit_list.get(0);
                    if (bLocalMobile) {
                        eezeeTelProfit.setProfitFromLocalMobile(eezeeTelProfit.getProfitFromLocalMobile() + fEezeeComm);
                        eezeeTelProfit.setTotalLocalMobileTransactions(eezeeTelProfit.getTotalLocalMobileTransactions() + theTransaction.getQuantity());
                    } else {
                        eezeeTelProfit.setProfitFromCallingCards(eezeeTelProfit.getProfitFromCallingCards() + fEezeeComm);
                        eezeeTelProfit.setTotalCards(eezeeTelProfit.getTotalCards() + theTransaction.getQuantity());
                    }
                    theSession.save(eezeeTelProfit);
                } else {
                    TReportEezeetelProfit eezeeTelProfit = new TReportEezeetelProfit();
                    eezeeTelProfit.setBeginDate(dateBegin);
                    eezeeTelProfit.setEndDate(dateEnd);
                    eezeeTelProfit.setGroup(custInfo.getGroup());
                    eezeeTelProfit.setTotalCustomers(custInfo.getGroup().getCustomers().size());
                    eezeeTelProfit.setProfitFromWorldMobile(0.0F);
                    eezeeTelProfit.setTotalWorldMobileTransactions(0);
                    if (bLocalMobile) {
                        eezeeTelProfit.setProfitFromCallingCards(0.0F);
                        eezeeTelProfit.setProfitFromLocalMobile(fEezeeComm);
                        eezeeTelProfit.setTotalLocalMobileTransactions(theTransaction.getQuantity());
                        eezeeTelProfit.setTotalCards(0);
                    } else {
                        eezeeTelProfit.setProfitFromCallingCards(fEezeeComm);
                        eezeeTelProfit.setProfitFromLocalMobile(0.0F);
                        eezeeTelProfit.setTotalLocalMobileTransactions(0);
                        eezeeTelProfit.setTotalCards(theTransaction.getQuantity());
                    }
                    theSession.save(eezeeTelProfit);
                }
                theTransaction.setPostProcessingStage(true);
                theSession.save(theTransaction);
                theSession.flush();
            }
            theSession.getTransaction().commit();
        } catch (Exception e) {
            System.out.println("Normal Transaction ID is  : " + nTransactionID);
            e.printStackTrace();
            if (theSession != null) {
                theSession.getTransaction().rollback();
            }
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return true;
    }

    public boolean ComputeIncrementalTransferToProfits() {

        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();

            String strQuery2 = "from TMasterProductinfo where Product_ID = 303";
            Query prodQuery = theSession.createQuery(strQuery2);
            List prodList = prodQuery.list();
            if (prodList.size() <= 0) {
                return false;
            }
            TMasterProductinfo prodInfo = (TMasterProductinfo) prodList.get(0);

            String strQuery = "from TTransfertoTransactions qc where Transaction_Status = 1  and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)  and Post_Processing_Stage = 0";

            Query query = theSession.createQuery(strQuery);

            List transList = query.list();
            for (int i = 0; i < transList.size(); i++) {
                TTransfertoTransactions theTransaction = (TTransfertoTransactions) transList.get(i);
                TMasterCustomerinfo custInfo = theTransaction.getCustomer();

                Calendar dtBegin = Calendar.getInstance();
                dtBegin.setTime(theTransaction.getTransactionTime());
                Calendar dtEnd = Calendar.getInstance();
                dtEnd.setTime(theTransaction.getTransactionTime());
                dtEnd.add(2, 1);

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-01 00:00:00");
                String strBeginDate = sdf.format(dtBegin.getTime());
                String strEndDate = sdf.format(dtEnd.getTime());

                Date dateBegin;
                Date dateEnd;
                try {
                    dateBegin = sdf.parse(strBeginDate);
                    dateEnd = sdf.parse(strEndDate);
                } catch (ParseException e) {
                    continue;
                }
                float fCustComm;
                float fAgentComm;
                float fGroupComm;
                float fEezeeComm;

                TReportCustomerProfit custProfit = new TReportCustomerProfit();
                custProfit.setBeginDate(dateBegin);
                custProfit.setEndDate(dateEnd);
                custProfit.setCustomer(custInfo);
                custProfit.setGroup(custInfo.getGroup());
                custProfit.setAgentId(custInfo.getIntroducedBy().getLogin());
                custProfit.setProduct(prodInfo);
                custProfit.setQuantity(1);
                custProfit.setRetailCost(theTransaction.getRetailPrice());
                custProfit.setCostToCustomer(theTransaction.getCostToCustomer());
                custProfit.setCostToAgent(theTransaction.getCostToAgent());
                custProfit.setCostToGroup(theTransaction.getCostToGroup());
                custProfit.setBatchCost(theTransaction.getCostToEezeeTel());
                custProfit.setBatchOriginalCost(theTransaction.getCostToEezeeTel());

                theSession.save(custProfit);

                fCustComm = theTransaction.getRetailPrice() - theTransaction.getCostToCustomer();
                fAgentComm = theTransaction.getCostToCustomer() - theTransaction.getCostToAgent();
                fGroupComm = theTransaction.getCostToAgent() - theTransaction.getCostToGroup();
                fEezeeComm = theTransaction.getCostToGroup() - theTransaction.getCostToEezeeTel();
                if (custInfo.getGroup().getId() == 1) {
                    fEezeeComm += fGroupComm;
                }

                strQuery = "from TReportGroupProfit qc1 where Customer_ID = " + custInfo.getId()
                        + " and Begin_Date = '" + strBeginDate + "' and End_Date = '" + strEndDate + "'";

                Query query2 = theSession.createQuery(strQuery);
                query2.setLockMode("qc1", LockMode.PESSIMISTIC_WRITE);
                List group_profit_list = query2.list();
                if (group_profit_list.size() > 0) {
                    TReportGroupProfit groupProfit = (TReportGroupProfit) group_profit_list.get(0);

                    groupProfit.setCustomerCommission(groupProfit.getCustomerCommission() + fCustComm);
                    groupProfit.setAgentCommission(groupProfit.getAgentCommission() + fAgentComm);
                    groupProfit.setTotalAmount(groupProfit.getTotalAmount() + theTransaction.getCostToGroup());
                    groupProfit.setProfitFromWorldMobile(groupProfit.getProfitFromWorldMobile() + fGroupComm);
                    groupProfit.setEezeeTelWorldMobileProfit(groupProfit.getEezeeTelWorldMobileProfit() + fEezeeComm);
                    groupProfit.setTotalWorldMobileTransactions(groupProfit.getTotalWorldMobileTransactions() + 1);

                    theSession.save(groupProfit);
                } else {
                    TReportGroupProfit groupProfit = new TReportGroupProfit();

                    groupProfit.setBeginDate(dateBegin);
                    groupProfit.setEndDate(dateEnd);
                    groupProfit.setCustomer(custInfo);
                    groupProfit.setGroup(custInfo.getGroup());
                    groupProfit.setAgentId(custInfo.getIntroducedBy().getLogin());
                    groupProfit.setTotalWorldMobileTransactions(1);
                    groupProfit.setTotalAmount(theTransaction.getCostToGroup());
                    groupProfit.setCustomerCommission(fCustComm);
                    groupProfit.setAgentCommission(fAgentComm);
                    groupProfit.setProfitFromWorldMobile(fGroupComm);
                    groupProfit.setEezeeTelWorldMobileProfit(fEezeeComm);

                    groupProfit.setTotalCards(0);
                    groupProfit.setTotalLocalMobileTransactions(0);
                    groupProfit.setProfitFromCallingCards(0.0F);
                    groupProfit.setProfitFromLocalMobile(0.0F);
                    groupProfit.setEezeeTelCardsProfit(0.0F);
                    groupProfit.setEezeeTelLocalMobileProfit(0.0F);

                    theSession.save(groupProfit);
                }
                strQuery = "from TReportEezeetelProfit qc1 where Customer_Group_ID = "
                        + custInfo.getGroup().getId() + " and Begin_Date = '" + strBeginDate
                        + "' and End_Date = '" + strEndDate + "'";

                query2 = theSession.createQuery(strQuery);
                query2.setLockMode("qc1", LockMode.PESSIMISTIC_WRITE);
                List eezeetel_profit_list = query2.list();
                if (eezeetel_profit_list.size() > 0) {
                    TReportEezeetelProfit eezeeTelProfit = (TReportEezeetelProfit) eezeetel_profit_list.get(0);

                    eezeeTelProfit.setTotalWorldMobileTransactions(eezeeTelProfit.getTotalWorldMobileTransactions() + 1);
                    eezeeTelProfit.setProfitFromWorldMobile(eezeeTelProfit.getProfitFromWorldMobile() + fEezeeComm);

                    theSession.save(eezeeTelProfit);
                } else {
                    TReportEezeetelProfit eezeeTelProfit = new TReportEezeetelProfit();
                    eezeeTelProfit.setBeginDate(dateBegin);
                    eezeeTelProfit.setEndDate(dateEnd);
                    eezeeTelProfit.setGroup(custInfo.getGroup());
                    eezeeTelProfit.setTotalCustomers(custInfo.getGroup().getCustomers().size());
                    eezeeTelProfit.setProfitFromWorldMobile(fEezeeComm);
                    eezeeTelProfit.setTotalWorldMobileTransactions(1);

                    eezeeTelProfit.setProfitFromCallingCards(0.0F);
                    eezeeTelProfit.setProfitFromLocalMobile(0.0F);
                    eezeeTelProfit.setTotalLocalMobileTransactions(0);
                    eezeeTelProfit.setTotalCards(0);

                    theSession.save(eezeeTelProfit);
                }
                theTransaction.setPostProcessingStage((byte) 1);
                theSession.save(theTransaction);
            }
            theSession.getTransaction().commit();
        } catch (Exception e) {
            log.info("Error by Compute Incremental TransferToProfits.");
            e.printStackTrace();
            if (theSession != null) {
                theSession.getTransaction().rollback();
            }
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return true;
    }

    public boolean ComputeIncrementalDingProfits() {

        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();

            String strQuery2 = "from TMasterProductinfo where Product_ID = 390";
            Query prodQuery = theSession.createQuery(strQuery2);
            List prodList = prodQuery.list();
            if (prodList.size() <= 0) {
                return false;
            }
            TMasterProductinfo prodInfo = (TMasterProductinfo) prodList.get(0);

            String strQuery = "from TDingTransactions qc where Transaction_Status = 1  and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)  and Post_Processing_Stage = 0";

            Query query = theSession.createQuery(strQuery);

            List transList = query.list();
            for (int i = 0; i < transList.size(); i++) {
                TDingTransactions theTransaction = (TDingTransactions) transList.get(i);
                TMasterCustomerinfo custInfo = theTransaction.getCustomer();

                Calendar dtBegin = Calendar.getInstance();
                dtBegin.setTime(theTransaction.getTransactionTime());
                Calendar dtEnd = Calendar.getInstance();
                dtEnd.setTime(theTransaction.getTransactionTime());
                dtEnd.add(2, 1);

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-01 00:00:00");
                String strBeginDate = sdf.format(dtBegin.getTime());
                String strEndDate = sdf.format(dtEnd.getTime());

                Date dateBegin;
                Date dateEnd;
                try {
                    dateBegin = sdf.parse(strBeginDate);
                    dateEnd = sdf.parse(strEndDate);
                } catch (ParseException e) {
                    continue;
                }
                float fCustComm;
                float fAgentComm;
                float fGroupComm;
                float fEezeeComm;

                TReportCustomerProfit custProfit = new TReportCustomerProfit();
                custProfit.setBeginDate(dateBegin);
                custProfit.setEndDate(dateEnd);
                custProfit.setCustomer(custInfo);
                custProfit.setGroup(custInfo.getGroup());
                custProfit.setAgentId(custInfo.getIntroducedBy().getLogin());
                custProfit.setProduct(prodInfo);
                custProfit.setQuantity(1);
                custProfit.setRetailCost(theTransaction.getRetailPrice());
                custProfit.setCostToCustomer(theTransaction.getCostToCustomer());
                custProfit.setCostToAgent(theTransaction.getCostToAgent());
                custProfit.setCostToGroup(theTransaction.getCostToGroup());
                custProfit.setBatchCost(theTransaction.getCostToEezeeTel());
                custProfit.setBatchOriginalCost(theTransaction.getCostToEezeeTel());

                theSession.save(custProfit);

                fCustComm = theTransaction.getRetailPrice() - theTransaction.getCostToCustomer();
                fAgentComm = theTransaction.getCostToCustomer() - theTransaction.getCostToAgent();
                fGroupComm = theTransaction.getCostToAgent() - theTransaction.getCostToGroup();
                fEezeeComm = theTransaction.getCostToGroup() - theTransaction.getCostToEezeeTel();
                if (custInfo.getGroup().getId() == 1) {
                    fEezeeComm += fGroupComm;
                }
                float fNonVAT = theTransaction.getCostToCustomer();
                float fVAT = 0.0F;

                strQuery = "from TReportGroupProfit qc1 where Customer_ID = " + custInfo.getId()
                        + " and Begin_Date = '" + strBeginDate + "' and End_Date = '" + strEndDate + "'";

                Query query2 = theSession.createQuery(strQuery);
                query2.setLockMode("qc1", LockMode.PESSIMISTIC_WRITE);
                List group_profit_list = query2.list();
                if (group_profit_list.size() > 0) {
                    TReportGroupProfit groupProfit = (TReportGroupProfit) group_profit_list.get(0);

                    groupProfit.setCustomerCommission(groupProfit.getCustomerCommission() + fCustComm);
                    groupProfit.setAgentCommission(groupProfit.getAgentCommission() + fAgentComm);
                    groupProfit.setTotalAmount(groupProfit.getTotalAmount() + theTransaction.getCostToGroup());
                    groupProfit.setProfitFromWorldMobile(groupProfit.getProfitFromWorldMobile() + fGroupComm);
                    groupProfit.setEezeeTelWorldMobileProfit(groupProfit.getEezeeTelWorldMobileProfit() + fEezeeComm);
                    groupProfit.setTotalWorldMobileTransactions(groupProfit.getTotalWorldMobileTransactions() + 1);

                    theSession.save(groupProfit);
                } else {
                    TReportGroupProfit groupProfit = new TReportGroupProfit();

                    groupProfit.setBeginDate(dateBegin);
                    groupProfit.setEndDate(dateEnd);
                    groupProfit.setCustomer(custInfo);
                    groupProfit.setGroup(custInfo.getGroup());
                    groupProfit.setAgentId(custInfo.getIntroducedBy().getLogin());
                    groupProfit.setTotalWorldMobileTransactions(1);
                    groupProfit.setTotalAmount(theTransaction.getCostToGroup());
                    groupProfit.setCustomerCommission(fCustComm);
                    groupProfit.setAgentCommission(fAgentComm);
                    groupProfit.setProfitFromWorldMobile(fGroupComm);
                    groupProfit.setEezeeTelWorldMobileProfit(fEezeeComm);

                    groupProfit.setTotalCards(0);
                    groupProfit.setTotalLocalMobileTransactions(0);
                    groupProfit.setProfitFromCallingCards(0.0F);
                    groupProfit.setProfitFromLocalMobile(0.0F);
                    groupProfit.setEezeeTelCardsProfit(0.0F);
                    groupProfit.setEezeeTelLocalMobileProfit(0.0F);

                    theSession.save(groupProfit);
                }
                strQuery = "from TReportEezeetelProfit qc1 where Customer_Group_ID = "
                        + custInfo.getGroup().getId() + " and Begin_Date = '" + strBeginDate
                        + "' and End_Date = '" + strEndDate + "'";

                query2 = theSession.createQuery(strQuery);
                query2.setLockMode("qc1", LockMode.PESSIMISTIC_WRITE);
                List eezeetel_profit_list = query2.list();
                if (eezeetel_profit_list.size() > 0) {
                    TReportEezeetelProfit eezeeTelProfit = (TReportEezeetelProfit) eezeetel_profit_list.get(0);

                    eezeeTelProfit.setTotalWorldMobileTransactions(eezeeTelProfit.getTotalWorldMobileTransactions() + 1);
                    eezeeTelProfit.setProfitFromWorldMobile(eezeeTelProfit.getProfitFromWorldMobile() + fEezeeComm);

                    theSession.save(eezeeTelProfit);
                } else {
                    TReportEezeetelProfit eezeeTelProfit = new TReportEezeetelProfit();
                    eezeeTelProfit.setBeginDate(dateBegin);
                    eezeeTelProfit.setEndDate(dateEnd);
                    eezeeTelProfit.setGroup(custInfo.getGroup());
                    eezeeTelProfit.setTotalCustomers(custInfo.getGroup().getCustomers().size());
                    eezeeTelProfit.setProfitFromWorldMobile(fEezeeComm);
                    eezeeTelProfit.setTotalWorldMobileTransactions(1);

                    eezeeTelProfit.setProfitFromCallingCards(0.0F);
                    eezeeTelProfit.setProfitFromLocalMobile(0.0F);
                    eezeeTelProfit.setTotalLocalMobileTransactions(0);
                    eezeeTelProfit.setTotalCards(0);

                    theSession.save(eezeeTelProfit);
                }
                theTransaction.setPostProcessingStage((byte) 1);
                theSession.save(theTransaction);
            }
            theSession.getTransaction().commit();
        } catch (Exception e) {
            log.info("Error by Compute Incremental Ding Profits.");
            e.printStackTrace();
            if (theSession != null) {
                theSession.getTransaction().rollback();
            }
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return true;
    }

    public boolean ComputeIncrementalSIMCardProfit() {
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();
            boolean bLocalMobile = true;

            String strQuery = "from TSimTransactions qc where Committed = 1  and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)  and Post_Processing_Stage = 0";

            Query query = theSession.createQuery(strQuery);
            List transList = query.list();
            for (int i = 0; i < transList.size(); i++) {
                TSimTransactions theTransaction = (TSimTransactions) transList.get(i);
                TBatchInformation theBatch = theTransaction.getSimCard().getBatch();
                TMasterProductinfo prodInfo = theTransaction.getSimCard().getProduct();

                TMasterCustomerinfo custInfo = theTransaction.getCustomer();
                Calendar dtBegin = Calendar.getInstance();
                dtBegin.setTime(theTransaction.getTransactionTime());
                Calendar dtEnd = Calendar.getInstance();
                dtEnd.setTime(theTransaction.getTransactionTime());
                dtEnd.add(2, 1);

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-01 00:00:00");
                String strBeginDate = sdf.format(dtBegin.getTime());
                String strEndDate = sdf.format(dtEnd.getTime());

                Date dateBegin;
                Date dateEnd;
                try {
                    dateBegin = sdf.parse(strBeginDate);
                    dateEnd = sdf.parse(strEndDate);
                } catch (ParseException e) {
                    continue;
                }
                strQuery =

                        "from TReportCustomerProfit qc1 where Customer_ID = " + custInfo.getId() + " and Product_ID = "
                                + prodInfo.getId() + " and Begin_Date = '" + strBeginDate + "' and End_Date = '" + strEndDate + "'";

                Query query2 = theSession.createQuery(strQuery);
                query2.setLockMode("qc1", LockMode.PESSIMISTIC_WRITE);
                List cust_profit_list = query2.list();

                float fCustComm;
                float fAgentComm;
                float fGroupComm;
                float fEezeeComm;
                if (cust_profit_list.size() > 0) {
                    TReportCustomerProfit custProfit = (TReportCustomerProfit) cust_profit_list.get(0);
                    if (theTransaction.getMobileTopupTransactionId() == null) {
                        custProfit.setQuantity(custProfit.getQuantity() + 1);
                    }
                    custProfit.setCostToGroup(custProfit.getCostToGroup() + theTransaction.getGroupCommission());
                    custProfit.setCostToAgent(custProfit.getCostToAgent() + theTransaction.getAgentCommission());
                    custProfit.setCostToCustomer(custProfit.getCostToCustomer() + theTransaction.getCustomerCommission());

                    theSession.save(custProfit);

                    fCustComm = theTransaction.getCustomerCommission();
                    fAgentComm = theTransaction.getAgentCommission();
                    fGroupComm = theTransaction.getGroupCommission();
                    fEezeeComm = theTransaction.getEezeetelCommission();
                } else {
                    TReportCustomerProfit custProfit = new TReportCustomerProfit();
                    custProfit.setBeginDate(dateBegin);
                    custProfit.setEndDate(dateEnd);
                    custProfit.setCustomer(custInfo);
                    custProfit.setGroup(custInfo.getGroup());
                    custProfit.setAgentId(custInfo.getIntroducedBy().getLogin());
                    custProfit.setProduct(prodInfo);
                    if (theTransaction.getMobileTopupTransactionId() == null) {
                        custProfit.setQuantity(1);
                    }
                    custProfit.setRetailCost(0.0F);
                    custProfit.setCostToCustomer(theTransaction.getCustomerCommission());
                    custProfit.setCostToAgent(theTransaction.getAgentCommission());
                    custProfit.setCostToGroup(theTransaction.getGroupCommission());
                    custProfit.setBatchCost(0.0F);
                    custProfit.setBatchOriginalCost(0.0F);

                    theSession.save(custProfit);

                    fCustComm = theTransaction.getCustomerCommission();
                    fAgentComm = theTransaction.getAgentCommission();
                    fGroupComm = theTransaction.getGroupCommission();
                    fEezeeComm = theBatch.getBatchCost();
                }

                strQuery = "from TReportGroupProfit qc1 where Customer_ID = " + custInfo.getId()
                        + " and Begin_Date = '" + strBeginDate + "' and End_Date = '" + strEndDate + "'";

                query2 = theSession.createQuery(strQuery);
                query2.setLockMode("qc1", LockMode.PESSIMISTIC_WRITE);
                List group_profit_list = query2.list();
                if (group_profit_list.size() > 0) {
                    TReportGroupProfit groupProfit = (TReportGroupProfit) group_profit_list.get(0);

                    groupProfit.setCustomerCommission(groupProfit.getCustomerCommission() + fCustComm);
                    groupProfit.setAgentCommission(groupProfit.getAgentCommission() + fAgentComm);
                    groupProfit.setTotalAmount(0.0F);
                    if (bLocalMobile) {
                        groupProfit.setProfitFromLocalMobile(groupProfit.getProfitFromLocalMobile() + fGroupComm);
                        groupProfit.setEezeeTelLocalMobileProfit(groupProfit.getEezeeTelLocalMobileProfit() + fEezeeComm);
                        groupProfit.setTotalLocalMobileTransactions(groupProfit.getTotalLocalMobileTransactions() + 1);
                    }
                    theSession.save(groupProfit);
                } else {
                    TReportGroupProfit groupProfit = new TReportGroupProfit();

                    groupProfit.setBeginDate(dateBegin);
                    groupProfit.setEndDate(dateEnd);
                    groupProfit.setCustomer(custInfo);
                    groupProfit.setGroup(custInfo.getGroup());
                    groupProfit.setAgentId(custInfo.getIntroducedBy().getLogin());
                    groupProfit.setTotalWorldMobileTransactions(0);
                    groupProfit.setTotalAmount(0.0F);
                    groupProfit.setCustomerCommission(fCustComm);
                    groupProfit.setAgentCommission(fAgentComm);
                    groupProfit.setProfitFromWorldMobile(0.0F);
                    groupProfit.setEezeeTelWorldMobileProfit(0.0F);
                    if (bLocalMobile) {
                        groupProfit.setTotalCards(0);
                        groupProfit.setTotalLocalMobileTransactions(1);
                        groupProfit.setProfitFromCallingCards(0.0F);
                        groupProfit.setProfitFromLocalMobile(fGroupComm);
                        groupProfit.setEezeeTelCardsProfit(0.0F);
                        groupProfit.setEezeeTelLocalMobileProfit(fEezeeComm);
                    }
                    theSession.save(groupProfit);
                }
                strQuery = "from TReportEezeetelProfit qc1 where Customer_Group_ID = "
                        + custInfo.getGroup().getId() + " and Begin_Date = '" + strBeginDate
                        + "' and End_Date = '" + strEndDate + "'";

                query2 = theSession.createQuery(strQuery);
                query2.setLockMode("qc1", LockMode.PESSIMISTIC_WRITE);
                List eezeetel_profit_list = query2.list();
                if (eezeetel_profit_list.size() > 0) {
                    TReportEezeetelProfit eezeeTelProfit = (TReportEezeetelProfit) eezeetel_profit_list.get(0);
                    if (bLocalMobile) {
                        eezeeTelProfit.setProfitFromLocalMobile(eezeeTelProfit.getProfitFromLocalMobile() + fEezeeComm);
                        eezeeTelProfit.setTotalLocalMobileTransactions(eezeeTelProfit.getTotalLocalMobileTransactions() + 1);
                    }
                    theSession.save(eezeeTelProfit);
                } else {
                    TReportEezeetelProfit eezeeTelProfit = new TReportEezeetelProfit();
                    eezeeTelProfit.setBeginDate(dateBegin);
                    eezeeTelProfit.setEndDate(dateEnd);
                    eezeeTelProfit.setGroup(custInfo.getGroup());
                    eezeeTelProfit.setTotalCustomers(custInfo.getGroup().getCustomers().size());
                    eezeeTelProfit.setProfitFromWorldMobile(0.0F);
                    eezeeTelProfit.setTotalWorldMobileTransactions(0);
                    if (bLocalMobile) {
                        eezeeTelProfit.setProfitFromCallingCards(0.0F);
                        eezeeTelProfit.setProfitFromLocalMobile(fEezeeComm);
                        eezeeTelProfit.setTotalLocalMobileTransactions(1);
                        eezeeTelProfit.setTotalCards(0);
                    }
                    theSession.save(eezeeTelProfit);
                }
                theTransaction.setPostProcessingStage((byte) 1);
                theSession.save(theTransaction);
            }
            theSession.getTransaction().commit();
        } catch (Exception e) {
            log.info("Error by Compute Sim Card Profits.");
            e.printStackTrace();
            if (theSession != null) {
                theSession.getTransaction().rollback();
            }
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return true;
    }

    public boolean ComputeIncrementalMobitopupProfits() {

        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();

            Query prodQuery = theSession.createQuery("from TMasterProductinfo where Product_ID = 424");
            List prodList = prodQuery.list();
            if (prodList.size() <= 0) {
                log.warn("Mobitopup product not found. ID - " + 424);
                return false;
            }
            TMasterProductinfo prodInfo = (TMasterProductinfo) prodList.get(0);

            String strQuery = "from MobitopupTransaction where errorCode = 0 and postProcessingStage = 0";
            Query query = theSession.createQuery(strQuery);

            List transList = query.list();
            for (int i = 0; i < transList.size(); i++) {
                MobitopupTransaction transaction = (MobitopupTransaction) transList.get(i);
                TMasterCustomerinfo customer = transaction.getCustomer();

                Calendar dtBegin = Calendar.getInstance();
                dtBegin.setTime(transaction.getTransactionTime());
                Calendar dtEnd = Calendar.getInstance();
                dtEnd.setTime(transaction.getTransactionTime());
                dtEnd.add(2, 1);

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-01 00:00:00");
                String strBeginDate = sdf.format(dtBegin.getTime());
                String strEndDate = sdf.format(dtEnd.getTime());

                Date dateBegin;
                Date dateEnd;
                try {
                    dateBegin = sdf.parse(strBeginDate);
                    dateEnd = sdf.parse(strEndDate);
                } catch (ParseException e) {
                    continue;
                }
                float fCustComm;
                float fAgentComm;
                float fGroupComm;
                float fEezeeComm;

                TReportCustomerProfit custProfit = new TReportCustomerProfit();
                custProfit.setBeginDate(dateBegin);
                custProfit.setEndDate(dateEnd);
                custProfit.setCustomer(customer);
                custProfit.setGroup(customer.getGroup());
                custProfit.setAgentId(customer.getIntroducedBy().getLogin());
                custProfit.setProduct(prodInfo);
                custProfit.setQuantity(1);
                custProfit.setRetailCost(transaction.getRetailPrice().floatValue());
                custProfit.setCostToCustomer(transaction.getRetailPrice().subtract(transaction.getCustomerCommission()).floatValue());
                custProfit.setCostToAgent(transaction.getPrice().add(transaction.getEezeetelCommission()).add(transaction.getGroupCommission()).floatValue());
                custProfit.setCostToGroup(transaction.getPrice().add(transaction.getEezeetelCommission()).floatValue());
                custProfit.setBatchCost(transaction.getPrice().floatValue());
                custProfit.setBatchOriginalCost(transaction.getPrice().floatValue());

                theSession.save(custProfit);

                fCustComm = transaction.getCustomerCommission().floatValue();
                fAgentComm = transaction.getAgentCommission().floatValue();
                fGroupComm = transaction.getGroupCommission().floatValue();
                fEezeeComm = transaction.getEezeetelCommission().floatValue();
                if (customer.getGroup().getId() == 1) {
                    fEezeeComm += fGroupComm;
                }
                float fNonVAT = transaction.getCustomerCommission().floatValue();
                float fVAT = 0.0F;

                strQuery = "from TReportGroupProfit qc1 where Customer_ID = " + customer.getId()
                        + " and Begin_Date = '" + strBeginDate + "' and End_Date = '" + strEndDate + "'";

                Query query2 = theSession.createQuery(strQuery);
                query2.setLockMode("qc1", LockMode.PESSIMISTIC_WRITE);
                List group_profit_list = query2.list();
                if (group_profit_list.size() > 0) {
                    TReportGroupProfit groupProfit = (TReportGroupProfit) group_profit_list.get(0);

                    groupProfit.setCustomerCommission(groupProfit.getCustomerCommission() + fCustComm);
                    groupProfit.setAgentCommission(groupProfit.getAgentCommission() + fAgentComm);
                    groupProfit.setTotalAmount(groupProfit.getTotalAmount() + transaction.getPrice().add(transaction.getEezeetelCommission()).floatValue());
                    groupProfit.setProfitFromWorldMobile(groupProfit.getProfitFromWorldMobile() + fGroupComm);
                    groupProfit.setEezeeTelWorldMobileProfit(groupProfit.getEezeeTelWorldMobileProfit() + fEezeeComm);
                    groupProfit.setTotalWorldMobileTransactions(groupProfit.getTotalWorldMobileTransactions() + 1);

                    theSession.save(groupProfit);
                } else {
                    TReportGroupProfit groupProfit = new TReportGroupProfit();

                    groupProfit.setBeginDate(dateBegin);
                    groupProfit.setEndDate(dateEnd);
                    groupProfit.setCustomer(customer);
                    groupProfit.setGroup(customer.getGroup());
                    groupProfit.setAgentId(customer.getIntroducedBy().getLogin());
                    groupProfit.setTotalWorldMobileTransactions(1);
                    groupProfit.setTotalAmount(transaction.getPrice().add(transaction.getEezeetelCommission()).floatValue());
                    groupProfit.setCustomerCommission(fCustComm);
                    groupProfit.setAgentCommission(fAgentComm);
                    groupProfit.setProfitFromWorldMobile(fGroupComm);
                    groupProfit.setEezeeTelWorldMobileProfit(fEezeeComm);

                    groupProfit.setTotalCards(0);
                    groupProfit.setTotalLocalMobileTransactions(0);
                    groupProfit.setProfitFromCallingCards(0.0F);
                    groupProfit.setProfitFromLocalMobile(0.0F);
                    groupProfit.setEezeeTelCardsProfit(0.0F);
                    groupProfit.setEezeeTelLocalMobileProfit(0.0F);

                    theSession.save(groupProfit);
                }
                strQuery = "from TReportEezeetelProfit qc1 where Customer_Group_ID = "
                        + customer.getGroup().getId() + " and Begin_Date = '" + strBeginDate
                        + "' and End_Date = '" + strEndDate + "'";

                query2 = theSession.createQuery(strQuery);
                query2.setLockMode("qc1", LockMode.PESSIMISTIC_WRITE);
                List eezeetel_profit_list = query2.list();
                if (eezeetel_profit_list.size() > 0) {
                    TReportEezeetelProfit eezeeTelProfit = (TReportEezeetelProfit) eezeetel_profit_list.get(0);

                    eezeeTelProfit.setTotalWorldMobileTransactions(eezeeTelProfit.getTotalWorldMobileTransactions() + 1);
                    eezeeTelProfit.setProfitFromWorldMobile(eezeeTelProfit.getProfitFromWorldMobile() + fEezeeComm);

                    theSession.save(eezeeTelProfit);
                } else {
                    TReportEezeetelProfit eezeeTelProfit = new TReportEezeetelProfit();
                    eezeeTelProfit.setBeginDate(dateBegin);
                    eezeeTelProfit.setEndDate(dateEnd);
                    eezeeTelProfit.setGroup(customer.getGroup());
                    eezeeTelProfit.setTotalCustomers(customer.getGroup().getCustomers().size());
                    eezeeTelProfit.setProfitFromWorldMobile(fEezeeComm);
                    eezeeTelProfit.setTotalWorldMobileTransactions(1);

                    eezeeTelProfit.setProfitFromCallingCards(0.0F);
                    eezeeTelProfit.setProfitFromLocalMobile(0.0F);
                    eezeeTelProfit.setTotalLocalMobileTransactions(0);
                    eezeeTelProfit.setTotalCards(0);

                    theSession.save(eezeeTelProfit);
                }
                transaction.setPostProcessingStage(true);
                theSession.save(transaction);
            }
            theSession.getTransaction().commit();
        } catch (Exception e) {
            log.info("Error by Compute Incremental Mobitopup Profits.");
            e.printStackTrace();
            if (theSession != null) {
                theSession.getTransaction().rollback();
            }
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return true;
    }

    public boolean ComputeIncrementalMobileUnlockingPofits() {

        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();

            Query prodQuery = theSession.createQuery("from TMasterProductinfo where Product_ID = 425");
            List prodList = prodQuery.list();
            if (prodList.size() <= 0) {
                log.warn("MobileUnlocking product not found. ID - " + 425);
                return false;
            }
            TMasterProductinfo prodInfo = (TMasterProductinfo) prodList.get(0);

            String strQuery = "from MobileUnlockingOrder where postProcessingStage = 0 ";
            Query query = theSession.createQuery(strQuery);

            List transList = query.list();
            for (int i = 0; i < transList.size(); i++) {
                MobileUnlockingOrder transaction = (MobileUnlockingOrder) transList.get(i);
                TMasterCustomerinfo customer = transaction.getCustomer();

                Calendar dtBegin = Calendar.getInstance();
                dtBegin.setTime(transaction.getCreatedDate());
                Calendar dtEnd = Calendar.getInstance();
                dtEnd.setTime(transaction.getCreatedDate());
                dtEnd.add(2, 1);

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-01 00:00:00");
                String strBeginDate = sdf.format(dtBegin.getTime());
                String strEndDate = sdf.format(dtEnd.getTime());

                Date dateBegin;
                Date dateEnd;
                try {
                    dateBegin = sdf.parse(strBeginDate);
                    dateEnd = sdf.parse(strEndDate);
                } catch (ParseException e) {
                    continue;
                }
                float fCustComm;
                float fAgentComm;
                float fGroupComm;
                float fEezeeComm;

                TReportCustomerProfit custProfit = new TReportCustomerProfit();
                custProfit.setBeginDate(dateBegin);
                custProfit.setEndDate(dateEnd);
                custProfit.setCustomer(customer);
                custProfit.setGroup(customer.getGroup());
                custProfit.setAgentId(customer.getIntroducedBy().getLogin());
                custProfit.setProduct(prodInfo);
                custProfit.setQuantity(1);
                custProfit.setRetailCost(transaction.getSellingPrice().floatValue());
                custProfit.setCostToCustomer(transaction.getPrice().add(transaction.getEezeetelCommission()).add(transaction.getGroupCommission()).add(transaction.getAgentCommission()).floatValue());
                custProfit.setCostToAgent(transaction.getPrice().add(transaction.getEezeetelCommission()).add(transaction.getGroupCommission()).floatValue());
                custProfit.setCostToGroup(transaction.getPrice().add(transaction.getEezeetelCommission()).floatValue());
                custProfit.setBatchCost(transaction.getPrice().floatValue());
                custProfit.setBatchOriginalCost(transaction.getPrice().floatValue());

                theSession.save(custProfit);

                fCustComm = 0;//transaction.getCustomerCommission().floatValue();
                fAgentComm = transaction.getAgentCommission().floatValue();
                fGroupComm = transaction.getGroupCommission().floatValue();
                fEezeeComm = transaction.getEezeetelCommission().floatValue();
                if (customer.getGroup().getId() == 1) {
                    fEezeeComm += fGroupComm;
                }
                float fNonVAT = 0.0F;//transaction.getCustomerCommission().floatValue();
                float fVAT = 0.0F;

                strQuery = "from TReportGroupProfit qc1 where Customer_ID = " + customer.getId()
                        + " and Begin_Date = '" + strBeginDate + "' and End_Date = '" + strEndDate + "'";

                Query query2 = theSession.createQuery(strQuery);
                query2.setLockMode("qc1", LockMode.PESSIMISTIC_WRITE);
                List group_profit_list = query2.list();
                if (group_profit_list.size() > 0) {
                    TReportGroupProfit groupProfit = (TReportGroupProfit) group_profit_list.get(0);

                    groupProfit.setCustomerCommission(groupProfit.getCustomerCommission() + fCustComm);
                    groupProfit.setAgentCommission(groupProfit.getAgentCommission() + fAgentComm);
                    groupProfit.setTotalAmount(groupProfit.getTotalAmount() + transaction.getPrice().add(transaction.getEezeetelCommission()).floatValue());

                    groupProfit.setProfitFromMobileUnlocking(groupProfit.getProfitFromMobileUnlocking() + fGroupComm);
                    groupProfit.setEezeeTelMobileUnlockingProfit(groupProfit.getEezeeTelMobileUnlockingProfit() + fEezeeComm);
                    groupProfit.setTotalMobileUnlockingTransactions(groupProfit.getTotalMobileUnlockingTransactions() + 1);

                    theSession.save(groupProfit);
                } else {
                    TReportGroupProfit groupProfit = new TReportGroupProfit();

                    groupProfit.setBeginDate(dateBegin);
                    groupProfit.setEndDate(dateEnd);
                    groupProfit.setCustomer(customer);
                    groupProfit.setGroup(customer.getGroup());
                    groupProfit.setAgentId(customer.getIntroducedBy().getLogin());
                    groupProfit.setTotalMobileUnlockingTransactions(1);
                    groupProfit.setTotalAmount(transaction.getPrice().add(transaction.getEezeetelCommission()).floatValue());
                    groupProfit.setCustomerCommission(fCustComm);
                    groupProfit.setAgentCommission(fAgentComm);
                    groupProfit.setProfitFromMobileUnlocking(fGroupComm);
                    groupProfit.setEezeeTelMobileUnlockingProfit(fEezeeComm);

                    groupProfit.setTotalCards(0);
                    groupProfit.setTotalLocalMobileTransactions(0);
                    groupProfit.setProfitFromCallingCards(0.0F);
                    groupProfit.setProfitFromLocalMobile(0.0F);
                    groupProfit.setEezeeTelCardsProfit(0.0F);
                    groupProfit.setEezeeTelLocalMobileProfit(0.0F);

                    theSession.save(groupProfit);
                }
                strQuery = "from TReportEezeetelProfit qc1 where Customer_Group_ID = "
                        + customer.getGroup().getId() + " and Begin_Date = '" + strBeginDate
                        + "' and End_Date = '" + strEndDate + "'";

                query2 = theSession.createQuery(strQuery);
                query2.setLockMode("qc1", LockMode.PESSIMISTIC_WRITE);
                List eezeetel_profit_list = query2.list();
                if (eezeetel_profit_list.size() > 0) {
                    TReportEezeetelProfit eezeeTelProfit = (TReportEezeetelProfit) eezeetel_profit_list.get(0);

                    eezeeTelProfit.setTotalMobileUnlockingTransactions(eezeeTelProfit.getTotalMobileUnlockingTransactions() + 1);
                    eezeeTelProfit.setProfitFromMobileUnlocking(eezeeTelProfit.getProfitFromMobileUnlocking() + fEezeeComm);

                    theSession.save(eezeeTelProfit);
                } else {
                    TReportEezeetelProfit eezeeTelProfit = new TReportEezeetelProfit();
                    eezeeTelProfit.setBeginDate(dateBegin);
                    eezeeTelProfit.setEndDate(dateEnd);
                    eezeeTelProfit.setGroup(customer.getGroup());
                    eezeeTelProfit.setTotalCustomers(customer.getGroup().getCustomers().size());
                    eezeeTelProfit.setProfitFromWorldMobile(fEezeeComm);
                    eezeeTelProfit.setTotalMobileUnlockingTransactions(1);

                    eezeeTelProfit.setProfitFromCallingCards(0.0F);
                    eezeeTelProfit.setProfitFromLocalMobile(0.0F);
                    eezeeTelProfit.setTotalLocalMobileTransactions(0);
                    eezeeTelProfit.setTotalCards(0);

                    theSession.save(eezeeTelProfit);
                }
                transaction.setPostProcessingStage(true);
                theSession.save(transaction);
            }
            theSession.getTransaction().commit();
        } catch (Exception e) {
            log.info("Error by Compute Incremental Mobitopup Profits.");
            e.printStackTrace();
            if (theSession != null) {
                theSession.getTransaction().rollback();
            }
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return true;
    }

    public boolean ComputeIncrementalPinlessProfits() {

        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();

            Query prodQuery = theSession.createQuery("from TMasterProductinfo where Product_ID = 426");
            List prodList = prodQuery.list();
            if (prodList.size() <= 0) {
                log.warn("Pinless product not found. ID - " + 426);
                return false;
            }
            TMasterProductinfo prodInfo = (TMasterProductinfo) prodList.get(0);

            String strQuery = "from PinlessTransaction where errorCode = 0 and postProcessingStage = 0";
            Query query = theSession.createQuery(strQuery);

            List transList = query.list();
            for (int i = 0; i < transList.size(); i++) {
                PinlessTransaction transaction = (PinlessTransaction) transList.get(i);
                TMasterCustomerinfo customer = transaction.getCustomer();

                Calendar dtBegin = Calendar.getInstance();
                dtBegin.setTime(transaction.getTransactionTime());
                Calendar dtEnd = Calendar.getInstance();
                dtEnd.setTime(transaction.getTransactionTime());
                dtEnd.add(2, 1);

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-01 00:00:00");
                String strBeginDate = sdf.format(dtBegin.getTime());
                String strEndDate = sdf.format(dtEnd.getTime());

                Date dateBegin;
                Date dateEnd;
                try {
                    dateBegin = sdf.parse(strBeginDate);
                    dateEnd = sdf.parse(strEndDate);
                } catch (ParseException e) {
                    continue;
                }
                float fCustComm;
                float fAgentComm;
                float fGroupComm;
                float fEezeeComm;

                TReportCustomerProfit custProfit = new TReportCustomerProfit();
                custProfit.setBeginDate(dateBegin);
                custProfit.setEndDate(dateEnd);
                custProfit.setCustomer(customer);
                custProfit.setGroup(customer.getGroup());
                custProfit.setAgentId(customer.getIntroducedBy().getLogin());
                custProfit.setProduct(prodInfo);
                custProfit.setQuantity(1);
                custProfit.setRetailCost(transaction.getRetailPrice().floatValue());
                custProfit.setCostToCustomer(transaction.getRetailPrice().subtract(transaction.getCustomerCommission()).floatValue());
                custProfit.setCostToAgent(transaction.getPrice().add(transaction.getEezeetelCommission()).add(transaction.getGroupCommission()).floatValue());
                custProfit.setCostToGroup(transaction.getPrice().add(transaction.getEezeetelCommission()).floatValue());
                custProfit.setBatchCost(transaction.getPrice().floatValue());
                custProfit.setBatchOriginalCost(transaction.getPrice().floatValue());

                theSession.save(custProfit);

                fCustComm = transaction.getCustomerCommission().floatValue();
                fAgentComm = transaction.getAgentCommission().floatValue();
                fGroupComm = transaction.getGroupCommission().floatValue();
                fEezeeComm = transaction.getEezeetelCommission().floatValue();
                if (customer.getGroup().getId() == 1) {
                    fEezeeComm += fGroupComm;
                }
                float fNonVAT = transaction.getCustomerCommission().floatValue();
                float fVAT = 0.0F;

                strQuery = "from TReportGroupProfit qc1 where Customer_ID = " + customer.getId()
                        + " and Begin_Date = '" + strBeginDate + "' and End_Date = '" + strEndDate + "'";

                Query query2 = theSession.createQuery(strQuery);
                query2.setLockMode("qc1", LockMode.PESSIMISTIC_WRITE);
                List group_profit_list = query2.list();
                if (group_profit_list.size() > 0) {
                    TReportGroupProfit groupProfit = (TReportGroupProfit) group_profit_list.get(0);

                    groupProfit.setCustomerCommission(groupProfit.getCustomerCommission() + fCustComm);
                    groupProfit.setAgentCommission(groupProfit.getAgentCommission() + fAgentComm);
                    groupProfit.setTotalAmount(groupProfit.getTotalAmount() + transaction.getPrice().add(transaction.getEezeetelCommission()).floatValue());
                    groupProfit.setProfitFromPinless(groupProfit.getProfitFromPinless() + fGroupComm);
                    groupProfit.setEezeeTelPinlessProfit(groupProfit.getEezeeTelPinlessProfit() + fEezeeComm);
                    groupProfit.setTotalPinlessTransactions(groupProfit.getTotalPinlessTransactions() + 1);

                    theSession.save(groupProfit);
                } else {
                    TReportGroupProfit groupProfit = new TReportGroupProfit();

                    groupProfit.setBeginDate(dateBegin);
                    groupProfit.setEndDate(dateEnd);
                    groupProfit.setCustomer(customer);
                    groupProfit.setGroup(customer.getGroup());
                    groupProfit.setAgentId(customer.getIntroducedBy().getLogin());
                    groupProfit.setTotalAmount(transaction.getPrice().add(transaction.getEezeetelCommission()).floatValue());
                    groupProfit.setCustomerCommission(fCustComm);
                    groupProfit.setAgentCommission(fAgentComm);

                    groupProfit.setProfitFromPinless(fGroupComm);
                    groupProfit.setEezeeTelPinlessProfit(fEezeeComm);
                    groupProfit.setTotalPinlessTransactions(1);

                    groupProfit.setTotalCards(0);
                    groupProfit.setTotalLocalMobileTransactions(0);
                    groupProfit.setProfitFromCallingCards(0.0F);
                    groupProfit.setProfitFromLocalMobile(0.0F);
                    groupProfit.setEezeeTelCardsProfit(0.0F);
                    groupProfit.setEezeeTelLocalMobileProfit(0.0F);

                    theSession.save(groupProfit);
                }
                strQuery = "from TReportEezeetelProfit qc1 where Customer_Group_ID = "
                        + customer.getGroup().getId() + " and Begin_Date = '" + strBeginDate
                        + "' and End_Date = '" + strEndDate + "'";

                query2 = theSession.createQuery(strQuery);
                query2.setLockMode("qc1", LockMode.PESSIMISTIC_WRITE);
                List eezeetel_profit_list = query2.list();
                if (eezeetel_profit_list.size() > 0) {
                    TReportEezeetelProfit eezeeTelProfit = (TReportEezeetelProfit) eezeetel_profit_list.get(0);

                    eezeeTelProfit.setTotalPinlessTransactions(eezeeTelProfit.getTotalPinlessTransactions() + 1);
                    eezeeTelProfit.setProfitFromPinless(eezeeTelProfit.getProfitFromPinless() + fEezeeComm);

                    theSession.save(eezeeTelProfit);
                } else {
                    TReportEezeetelProfit eezeeTelProfit = new TReportEezeetelProfit();
                    eezeeTelProfit.setBeginDate(dateBegin);
                    eezeeTelProfit.setEndDate(dateEnd);
                    eezeeTelProfit.setGroup(customer.getGroup());
                    eezeeTelProfit.setTotalCustomers(customer.getGroup().getCustomers().size());
                    eezeeTelProfit.setProfitFromPinless(fEezeeComm);
                    eezeeTelProfit.setTotalPinlessTransactions(1);

                    eezeeTelProfit.setProfitFromCallingCards(0.0F);
                    eezeeTelProfit.setProfitFromLocalMobile(0.0F);
                    eezeeTelProfit.setTotalLocalMobileTransactions(0);
                    eezeeTelProfit.setTotalCards(0);

                    theSession.save(eezeeTelProfit);
                }
                transaction.setPostProcessingStage(true);
                theSession.save(transaction);
            }
            theSession.getTransaction().commit();
        } catch (Exception e) {
            log.info("Error by Compute Incremental Mobitopup Profits.");
            e.printStackTrace();
            if (theSession != null) {
                theSession.getTransaction().rollback();
            }
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return true;
    }
}
