package com.eezeetel.customerapp;

import com.eezeetel.bean.CardInfoBean;
import com.eezeetel.bean.ConfirmBean;
import com.eezeetel.entity.*;
import com.eezeetel.enums.TransactionStatus;
import com.eezeetel.service.*;
import com.eezeetel.util.HibernateUtil;
import lombok.extern.log4j.Log4j;
import org.apache.log4j.Level;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

@Log4j
@Service
public class ProcessTransaction {

    @Autowired
    private CustomerService customerService;

    @Autowired
    private ProductService productService;

    @Autowired
    private BatchService batchService;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private GroupService groupService;

    @Autowired
    private CustomerCommissionService customerCommissionService;

    @Autowired
    private CustomerGroupCommissionService customerGroupCommissionService;

    @Autowired
    private CardService cardService;

    @Autowired
    private TransactionBalanceService transactionBalanceService;

    @Autowired
    private GroupTransactionBalanceService groupTransactionBalanceService;

    @Autowired
    private CustomerUserService customerUserService;

    @Autowired
    private EmailClient emailClient;

    @Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRES_NEW, isolation = Isolation.SERIALIZABLE)
    public Boolean process(List<Integer> nProductIDList, List<Integer> nRequiredQuantityList, String login, ConfirmBean bean, final Long transactionId) {
        float m_fAvailableBalance;
        float m_fTotalTransactionAmount = 0.0F;

        List<RequirementRecord> m_arrayRequirement = new ArrayList<>();
        for (int i = 0; i < nProductIDList.size(); i++) {
            RequirementRecord oneRecord = new RequirementRecord();
            oneRecord.m_nProductID = nProductIDList.get(i);
            oneRecord.m_nRequiredQuantity = nRequiredQuantityList.get(i);
            oneRecord.m_nProcessedQuantity = 0;
            oneRecord.m_fFaceValue = 0.0F;
            oneRecord.m_strImageFilePath = null;
            oneRecord.m_strProductName = null;
            oneRecord.m_fProfitMarginEezeeTel = 0.0F;
            oneRecord.m_fGroupProfitMargin = 0.0F;
            oneRecord.m_fAgentProfitMargin = 0.0F;
            oneRecord.m_fCostToCustomer = 0.0F;

            m_arrayRequirement.add(oneRecord);
        }

        int nCustomerID;
        int nCustomerGroupID;
        boolean bSellAtFaceValue = false;

        TCustomerUsers customerUser = customerUserService.findByLogin(login);
        if(customerUser == null){
            customerUser = customerUserService.findByLogin(login);
        }
        TMasterCustomerinfo custInfo = customerUser.getCustomer();
        TMasterCustomerGroups custGroups = custInfo.getGroup();
        nCustomerGroupID = custGroups.getId();
        if (custGroups.getSellAtFaceValue()) {
            bSellAtFaceValue = true;
        }
        nCustomerID = custInfo.getId();

        m_fAvailableBalance = custInfo.getCustomerBalance();
        if (custGroups.getCheckAganinstGroupBalance() && custGroups.getCustomerGroupBalance() < 500.0F) {
            log.info("The balance is less than 500. Group - " + custGroups.getName() + ". Customer - " + custInfo.getCompanyName());
            bean.setError("Insufficent reserve funds. Please contact your Agent.");
            return false;
        }

        Calendar cal = Calendar.getInstance();
        for (int i = 0; i < m_arrayRequirement.size(); i++) {
            RequirementRecord oneRecord = m_arrayRequirement.get(i);

            TMasterProductinfo productInfo = productService.findOne(oneRecord.m_nProductID);
            oneRecord.m_fFaceValue = productInfo.getProductFaceValue();
            oneRecord.m_strProductName = productInfo.getProductName();

            TCustomerCommission customerCommission = customerCommissionService.findByCustomerAndProduct(nCustomerID, oneRecord.m_nProductID);
            if (customerCommission != null) {
                oneRecord.m_fGroupProfitMargin = customerCommission.getCommission();
                oneRecord.m_fAgentProfitMargin = customerCommission.getAgentCommission();
            }

            TCustomerGroupCommissions customerGroupCommission = customerGroupCommissionService.findByGroupAndProduct(nCustomerGroupID, oneRecord.m_nProductID);
            if (customerGroupCommission != null) {
                oneRecord.m_fProfitMarginEezeeTel = customerGroupCommission.getCommission();
            }

            if (oneRecord.m_fFaceValue > 0.0D) {
                int nRequiredQuantityNow = oneRecord.m_nRequiredQuantity;

                List<TBatchInformation> batches = batchService.findByProductAndReadyToSell(oneRecord.m_nProductID);

                for (int nBatch = 0; nBatch < batches.size(); nBatch++) {
                    TBatchInformation batchInfo = batches.get(nBatch);
                    if (nBatch == 0) {
                        String img = batchInfo.getProductsaleinfo().getProductImageFile();
                        oneRecord.m_strImageFilePath = img;
                        if (img.contains("Product_Images")) {
                            oneRecord.m_strImageFilePath = img.replace("Product_Images", "images");
                        }
                    }
                    int nAvailableInThisBatch;
                    if (batchInfo.getAvailableQuantity() >= nRequiredQuantityNow) {
                        nAvailableInThisBatch = nRequiredQuantityNow;
                    } else {
                        nAvailableInThisBatch = batchInfo.getAvailableQuantity();
                    }
                    nRequiredQuantityNow -= nAvailableInThisBatch;
                    batchInfo.setAvailableQuantity(batchInfo.getAvailableQuantity() - nAvailableInThisBatch);
                    batchInfo.setLastTouchTime(Calendar.getInstance().getTime());
                    batchInfo = batchService.save(batchInfo);

                    oneRecord.m_nProcessedQuantity += nAvailableInThisBatch;

                    float fFaceValuePrice = oneRecord.m_fFaceValue * nAvailableInThisBatch;
                    float fBatchUnitPrice = batchInfo.getUnitPurchasePrice();
                    float fBatchCostOriginal = fBatchUnitPrice * nAvailableInThisBatch;
                    float fCostToCustomerGroup = fBatchCostOriginal + oneRecord.m_fProfitMarginEezeeTel * nAvailableInThisBatch;
                    float fCostToCustomerAgent = fCostToCustomerGroup + oneRecord.m_fGroupProfitMargin * nAvailableInThisBatch;
                    float fCostToCustomer = fCostToCustomerAgent + oneRecord.m_fAgentProfitMargin * nAvailableInThisBatch;
                    /*if (fCostToCustomer > fFaceValuePrice) {
                        fCostToCustomerGroup = fFaceValuePrice;
                        fCostToCustomerAgent = fFaceValuePrice;
                        fCostToCustomer = fFaceValuePrice;
                    }*/
                    if (bSellAtFaceValue) {
                        fCostToCustomer = fFaceValuePrice;
                        fCostToCustomerAgent = fCostToCustomer - oneRecord.m_fAgentProfitMargin;
                    }
                    m_fTotalTransactionAmount += fCostToCustomer;
                    oneRecord.m_fCostToCustomer += fCostToCustomer;

                    TTransactions transaction = new TTransactions();
                    transaction.setUser(customerUser.getUser());
                    transaction.setProduct(productInfo);
                    transaction.setCustomer(custInfo);
                    transaction.setBatch(batchInfo);
                    transaction.setTransactionId(transactionId);
                    transaction.setQuantity(nAvailableInThisBatch);
                    transaction.setUnitPurchasePrice(fCostToCustomer);
                    transaction.setSecondaryTransactionPrice(fCostToCustomerAgent);
                    transaction.setCommitted((byte) TransactionStatus.PROCESSED.ordinal());
                    transaction.setTransactionTime(cal.getTime());
                    transaction.setUnitGroupPrice(fCostToCustomerGroup);
                    transaction.setBatchUnitPrice(fBatchCostOriginal);

                    transactionService.save(transaction);

                    if (m_fAvailableBalance < m_fTotalTransactionAmount) {
                        bean.setError("Available balance " + new DecimalFormat("0.##").format((double) m_fAvailableBalance) + " is not enough to process the transaction.");
                        return false;
                    } else {
                        bean.setSuccess(true);
                        bean.setTransactionId(transactionId);
                        bean.setProducts(m_arrayRequirement);
                        log.info("Processed transaction: " + transactionId);
                    }
                    if (m_fAvailableBalance < 25) {
                        bean.setMessage("Your balance is low. Please request a topup as soon as possible");
                    }

                    if (nRequiredQuantityNow <= 0) {
                        break;
                    }
                }
            }
        }

        return true;
    }

    @Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRES_NEW, isolation = Isolation.SERIALIZABLE)
    public List<RequirementRecord> confirm(final long nTransactionID) {
        List<RequirementRecord> requirementRecords = new ArrayList<>();
        if (nTransactionID <= 0L) {
            return requirementRecords;
        }

        TMasterCustomerinfo custInfo = null;
        float fTotalTransactionPrice = 0.0F;
        float fTotalGroupPrice = 0.0F;

        String strTheTransaction = "CONFIRM :: TransactionID = " + nTransactionID;

        List<TTransactions> transaction_list = transactionService.findByTransactionIdAndCommitted(nTransactionID, (byte) TransactionStatus.PROCESSED.ordinal());

        for (TTransactions transaction : transaction_list) {
            RequirementRecord record = new RequirementRecord();
            record.m_nProductID = transaction.getProduct().getId();
            record.m_nRequiredQuantity = transaction.getQuantity();
            record.m_nProcessedQuantity = transaction.getQuantity();
            record.m_fCostToCustomer = transaction.getUnitPurchasePrice();
            record.m_strProductName = transaction.getProduct().getProductName();
            String img = transaction.getBatch().getProductsaleinfo().getProductImageFile();
            record.m_strImageFilePath = img;
            if (img != null && img.contains("Product_Images")) {
                record.m_strImageFilePath = img.replace("Product_Images", "images");
            }
            record.m_fFaceValue = transaction.getProduct().getProductFaceValue();
            requirementRecords.add(record);
        }

        boolean bTransactionProcessed = false;
        for (int i = 0; i < transaction_list.size(); i++) {
            TTransactions theTransaction = transaction_list.get(i);
            strTheTransaction = strTheTransaction + ", Sequence_ID = " + theTransaction.getId();
            if (theTransaction.getQuantity() <= 0) {
                strTheTransaction = strTheTransaction + ", Quantity = 0 - Skipped ";
            } else {
                TBatchInformation theBatch = theTransaction.getBatch();
                custInfo = theTransaction.getCustomer();
                if (i == 0) {
                    strTheTransaction = strTheTransaction + ", TransactionTime = " + theTransaction.getTransactionTime();
                }

                List<TCardInfo> card_list = cardService.findByBatchAndIsSoldOrderByIdAsc(theBatch, false, new PageRequest(0, theTransaction.getQuantity()));
                if (card_list.size() <= 0 || card_list.size() != theTransaction.getQuantity()) {
                    strTheTransaction = strTheTransaction + ", PROBLEM Batch = " + theBatch.getSequenceId() + ", card_list: " + card_list.size();
                    log.info("PROBLEM Batch = " + theBatch.getSequenceId() + ", card_list: " + card_list.size() + ". Transaction ID = " + theTransaction.getTransactionId());
                    emailClient.prepareAndSend(
                            "denis.duleac@gmail.com",
                            "dev.eezeetel@gmail.com",
                            "PROBLEM Batch", "PROBLEM Batch = " + theBatch.getSequenceId() + ", card_list: " + card_list.size() + ". Transaction ID = " + theTransaction.getTransactionId(),
                            false);
                } else {
                    strTheTransaction = strTheTransaction + ", Batch ID = " + theBatch.getSequenceId();
                    for (int j = 0; j < card_list.size(); j++) {
                        TCardInfo cardInfo = card_list.get(j);
                        cardInfo.setIsSold(true);
                        cardInfo.setTransactionId(nTransactionID);
                    }
                    cardService.save(card_list);
                    fTotalTransactionPrice += theTransaction.getUnitPurchasePrice();
                    fTotalGroupPrice += theTransaction.getUnitGroupPrice();

                    strTheTransaction = strTheTransaction + ", TransactionPrice = " + fTotalTransactionPrice;
                    strTheTransaction = strTheTransaction + ", GroupPrice = " + fTotalGroupPrice;

                    theTransaction.setCommitted((byte) TransactionStatus.COMMITTED.ordinal());
                    transactionService.save(theTransaction);

                    bTransactionProcessed = true;
                }
            }
        }
        if ((custInfo != null) && (bTransactionProcessed)) {
            transactionBalanceService.create(nTransactionID, custInfo.getCustomerBalance(), custInfo.getCustomerBalance() - fTotalTransactionPrice);

            custInfo.setCustomerBalance(custInfo.getCustomerBalance() - fTotalTransactionPrice);
            custInfo = customerService.save(custInfo);

            strTheTransaction = strTheTransaction + ", CustomerID = " + custInfo.getId();
            strTheTransaction = strTheTransaction + ", CustomerBalance = " + custInfo.getCustomerBalance();

            TMasterCustomerGroups custGroup = custInfo.getGroup();
            if (custGroup.getCheckAganinstGroupBalance()) {
                BigDecimal balanceBefore = new BigDecimal(custGroup.getCustomerGroupBalance() + "");
                BigDecimal balanceAfter = balanceBefore.subtract(new BigDecimal(fTotalGroupPrice + ""));

                groupTransactionBalanceService.create(nTransactionID, balanceBefore, balanceAfter);

                custGroup.setCustomerGroupBalance(balanceAfter.floatValue());
                groupService.save(custGroup);
                strTheTransaction = strTheTransaction + ", CustomerGroupBalance = " + custGroup.getCustomerGroupBalance();
            }
        }
        if (!strTheTransaction.isEmpty()) {
            log.setLevel(Level.DEBUG);
            log.info(strTheTransaction);
        }
        return requirementRecords;
    }

    @Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRES_NEW, isolation = Isolation.SERIALIZABLE)
    public boolean cancel(long nTransactionID) {
        if (nTransactionID <= 0L) {
            return false;
        }

        try {
            List<TTransactions> transactions = transactionService.findByTransactionIdAndCommitted(nTransactionID, (byte) TransactionStatus.PROCESSED.ordinal());
            for (TTransactions transaction : transactions) {
                TBatchInformation batch = transaction.getBatch();
                batch.setAvailableQuantity(batch.getAvailableQuantity() + transaction.getQuantity());
                batch.setLastTouchTime(Calendar.getInstance().getTime());
                transaction.setCommitted((byte) TransactionStatus.CANCELED.ordinal());
                batch = batchService.save(batch);
                transaction.setBatch(batch);
                transactionService.save(transaction);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return true;
    }

    public Long processSIMCardTransaction(int nCustomerID, int nCustomerGroupID, String strUserID,
                                          long nSimSequenceID, ArrayList<String> mobTopups) {
        long m_nTransactionID = 0L;

        if ((nCustomerID <= 0) || (nCustomerGroupID <= 0) || (strUserID == null) || (strUserID.isEmpty())
                || (nSimSequenceID <= 0L)) {
            return m_nTransactionID;
        }

        Session session = null;
        try {
            session = HibernateUtil.openSession();
            session.beginTransaction();

            String strQuery = "from TSimCardsInfo where SequenceID = " + nSimSequenceID + " and Customer_ID = " + nCustomerID
                    + " and Customer_Group_ID = " + nCustomerGroupID + " and Is_Sold = 0";

            Query query = session.createQuery(strQuery);
            List records = query.list();
            if ((records == null) || (records.size() <= 0)) {
                session.getTransaction().commit();
                return m_nTransactionID;
            }
            TSimCardsInfo simCardInfo = (TSimCardsInfo) records.get(0);

            float fCustomerCommission = 0.0F;
            float fAgentCommission = 0.0F;
            float fGroupCommission = 0.0F;
            float fEezeeTelCommission = 0.0F;

            m_nTransactionID = transactionService.getNextTransactionId();

            Calendar cal = Calendar.getInstance();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String strCurTime = sdf.format(cal.getTime());

            strQuery = "insert into t_sim_transactions(Transaction_ID, Transaction_Time, User_ID, Customer_ID, SIM_Card_SequenceID, Customer_Commission, Agent_Commission,  Group_Commission, Eezeetel_Commission, Committed, Post_Processing_Stage) values ("
                    + m_nTransactionID
                    + ", '" + strCurTime
                    + "', '" + strUserID
                    + "', " + nCustomerID
                    + ", " + nSimSequenceID
                    + ", " + fCustomerCommission
                    + ", " + fAgentCommission
                    + ", " + fGroupCommission
                    + ", " + fEezeeTelCommission
                    + ", 1, 0)";

            SQLQuery sqlQuery = session.createSQLQuery(strQuery);
            sqlQuery.executeUpdate();

            simCardInfo.setTransactionId(m_nTransactionID);
            simCardInfo.setIsSold(true);

            session.save(simCardInfo);
            session.getTransaction().commit();

            long nTheTransaction = m_nTransactionID;
            for (int i = 0; i < mobTopups.size(); i++) {
                attachMobileTopupTransaction(nCustomerID, nCustomerGroupID, strUserID, nSimSequenceID, Long.parseLong(mobTopups.get(i)));
            }
            m_nTransactionID = nTheTransaction;
        } catch (Exception e) {
            e.printStackTrace();
            if (session != null) {
                session.getTransaction().rollback();
            }
            m_nTransactionID = 0L;
            return m_nTransactionID;
        } finally {
            HibernateUtil.closeSession(session);
        }
        return m_nTransactionID;
    }

    public boolean attachMobileTopupTransaction(int nCustomerID, int nCustomerGroupID, String strUserID,
                                                long nSimSequenceID, long nMobileTopupTransactionID) {
        if ((nCustomerID <= 0) || (nCustomerGroupID <= 0) || (strUserID == null) || (strUserID.isEmpty())
                || (nSimSequenceID <= 0L) || (nMobileTopupTransactionID <= 0L)) {
            return false;
        }

        long m_nTransactionID = 0L;

        Session session = null;
        try {
            session = HibernateUtil.openSession();
            session.beginTransaction();

            String strQuery = "from TSimCardsInfo where Is_Sold = 1 and SequenceID = " + nSimSequenceID;

            Query query = session.createQuery(strQuery);
            List records = query.list();
            if ((records == null) || (records.size() <= 0)) {
                return false;
            }
            float fCustomerCommission = 0.0F;
            float fAgentCommission = 0.0F;
            float fGroupCommission = 0.0F;
            float fEezeeTelCommission = 0.0F;

            TSimCardsInfo simCardInfo = (TSimCardsInfo) records.get(0);
            TMasterProductinfo prodInfo = simCardInfo.getProduct();
            if (simCardInfo.getMaxTopups() == simCardInfo.getRemainingTopups()) {
                strQuery = "from TCustomerCommission where  Customer_ID = " + nCustomerID + " and Product_ID = "
                        + prodInfo.getId();
                query = session.createQuery(strQuery);
                List theCommission = query.list();
                if (theCommission.size() > 0) {
                    TCustomerCommission custCommission = (TCustomerCommission) theCommission.get(0);

                    fCustomerCommission = custCommission.getCommission();
                    fAgentCommission = custCommission.getAgentCommission();
                }
                strQuery = "from TCustomerGroupCommissions where  Customer_Group_ID = " + nCustomerGroupID
                        + " and Product_ID = " + prodInfo.getId();
                query = session.createQuery(strQuery);
                List theGrpCommission = query.list();
                if (theGrpCommission.size() > 0) {
                    TCustomerGroupCommissions custGroupCommission = (TCustomerGroupCommissions) theGrpCommission.get(0);
                    fGroupCommission = custGroupCommission.getCommission();
                }
            }
            m_nTransactionID = simCardInfo.getTransactionId();

            Calendar cal = Calendar.getInstance();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String strCurTime = sdf.format(cal.getTime());

            strQuery = "insert into t_sim_transactions(Transaction_ID, Transaction_Time, User_ID, Customer_ID, SIM_Card_SequenceID, Customer_Commission, Agent_Commission,  Group_Commission, Eezeetel_Commission, Committed, Post_Processing_Stage, Mobile_Topup_Transaction_ID) values ("
                    + m_nTransactionID
                    + ", '"
                    + strCurTime
                    + "', '"
                    + strUserID
                    + "', "
                    + nCustomerID
                    + ", "
                    + nSimSequenceID
                    + ", "
                    + fCustomerCommission
                    + ", "
                    + fAgentCommission
                    + ", "
                    + fGroupCommission
                    + ", "
                    + fEezeeTelCommission
                    + ", 1, 0, " + nMobileTopupTransactionID + ")";

            SQLQuery sqlQuery = session.createSQLQuery(strQuery);
            sqlQuery.executeUpdate();

            simCardInfo.setRemainingTopups((byte) (simCardInfo.getRemainingTopups() - 1));
            session.save(simCardInfo);

            session.getTransaction().commit();
        } catch (Exception e) {
            if (session != null) {
                session.getTransaction().rollback();
            }
            return false;
        } finally {
            HibernateUtil.closeSession(session);
        }
        return true;
    }

    public static class RequirementRecord {
        public int m_nProductID;
        public int m_nRequiredQuantity;
        public int m_nProcessedQuantity;
        public String m_strProductName;
        public String m_strImageFilePath;
        public float m_fFaceValue;
        public float m_fProfitMarginEezeeTel;
        public float m_fGroupProfitMargin;
        public float m_fAgentProfitMargin;
        public float m_fCostToCustomer;
        public List<CardInfoBean> cardInfoBeans = new ArrayList<>();

        public RequirementRecord() {
        }
    }
}
