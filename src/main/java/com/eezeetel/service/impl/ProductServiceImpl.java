package com.eezeetel.service.impl;

import com.eezeetel.bean.CardInfoBean;
import com.eezeetel.bean.ConfirmBean;
import com.eezeetel.bean.ProductBean;
import com.eezeetel.bean.customer.PrintSimTransaction;
import com.eezeetel.customerapp.ProcessTransaction;
import com.eezeetel.entity.*;
import com.eezeetel.enums.TransactionStatus;
import com.eezeetel.enums.TransactionType;
import com.eezeetel.repository.ProductRepository;
import com.eezeetel.service.*;
import com.eezeetel.util.HibernateUtil;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionException;
import org.hibernate.transform.Transformers;
import org.hibernate.type.FloatType;
import org.hibernate.type.IntegerType;
import org.hibernate.type.StringType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by Denis Dulyak on 13.10.2015.
 */
@Service
public class ProductServiceImpl implements ProductService {

    private static Logger logger = Logger.getLogger(ProductServiceImpl.class);

    @Autowired
    private ProductRepository repository;

    @Autowired
    private BatchService batchService;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private ProcessTransaction processTransaction;

    @Autowired
    private SimTransactionService simTransactionService;

    @Autowired
    private CardService cardService;

    @Autowired
    private DingTransactionService dingTransactionService;

    @Autowired
    private MobitopupTransactionService mobitopupTransactionService;

    @Override
    public TMasterProductinfo findOne(Integer id) {
        return repository.findOne(id);
    }

    @Override
    public List<TMasterProductinfo> findAll() {
        return repository.findAll();
    }

    @Override
    public List<TMasterProductinfo> findAllActive() {
        return repository.findByActiveTrue();
    }

    @Override
    public TMasterProductinfo save(TMasterProductinfo product) {
        return repository.save(product);
    }

    @Override
    public TMasterProductinfo findByIdFromList(Integer id, List<TMasterProductinfo> products) {
        Optional<TMasterProductinfo> product = products.stream().filter(p -> p.getId().equals(id)).findFirst();
        return product.isPresent() ? product.get() : null;
    }

    @Override
    public List<TMasterProductinfo> findBySupplierId(Integer supplierId) {
        return repository.findBySupplierIdAndActiveTrue(supplierId);
    }

    @Override
    public List<ProductBean> getProductsBySupplier(Integer supplierId) {
        List<ProductBean> beans = Collections.emptyList();
        Session session = null;
        try {
            session = HibernateUtil.openSession();
            String sql = "SELECT " +
                "    pro.Product_ID as id, " +
                "    pro.Product_Name as name, " +
                "    pro.Product_Face_Value as faceValue, " +
                "    SUM(bat.Available_Quantity) as availableQuantity, " +
                "    sal.Product_Image_File as img " +
                "FROM " +
                "    t_master_productinfo pro, " +
                "    t_batch_information bat, " +
                "    t_master_productsaleinfo sal " +
                "WHERE " +
                "    pro.Product_ID = bat.Product_ID " +
                "        AND pro.Supplier_ID = :supplierId " +
                "        AND pro.Product_Active_Status = 1 " +
                "        AND pro.Product_Type_ID != 17 " +
                "        AND bat.IsBatchActive = 1 " +
                "        AND bat.Batch_Activated_By_Supplier = 1 " +
                "        AND bat.Batch_Ready_To_Sell = 1 " +
                "        AND bat.Batch_Upload_Status = 'SUCCESS-BatchUpdateInDB' " +
                "        AND bat.Sale_Info_ID = sal.Sale_Info_ID " +
                "GROUP BY bat.Product_ID " +
                "ORDER BY pro.Product_Face_Value, pro.Product_Name";
            SQLQuery sqlQuery = session.createSQLQuery(sql);
            sqlQuery.setParameter("supplierId", supplierId);
            sqlQuery.addScalar("id", new IntegerType());
            sqlQuery.addScalar("name", new StringType());
            sqlQuery.addScalar("faceValue", new FloatType());
            sqlQuery.addScalar("availableQuantity", new IntegerType());
            sqlQuery.addScalar("img", new StringType());
            sqlQuery.setResultTransformer(Transformers.aliasToBean(ProductBean.class));
            beans = (List<ProductBean>) sqlQuery.list();
        } catch (SessionException e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }
        return beans;
    }

    @Override
    public ConfirmBean process(HttpServletRequest request, List<String> idsAndQuentity, String login) {
        ConfirmBean bean = new ConfirmBean();
        bean.setSuccess(false);

        List<Integer> productIdList = new ArrayList<>();
        List<Integer> quantityList = new ArrayList<>();

        for (String str : idsAndQuentity) {
            Integer productId = Integer.parseInt(str.split(",")[0]);
            Integer quantity = Integer.parseInt(str.split(",")[1]);
            Integer availableQuantity = batchService.getProductAvailableQuantity(productId);
            if (availableQuantity == 0) {
                logger.info("The product with id - " + productId + " is not available.");
                bean.setError("This product is not available now.");
                return bean;
            }
            if (quantity > availableQuantity) {
                bean.setError("Too much of the selected products.");
                return bean;
            }
            if (!productIdList.contains(productId)) {
                productIdList.add(productId);
                quantityList.add(quantity);
            }
        }

        if ((productIdList.size() == 0) || (quantityList.size() == 0)) {
            logger.info("Warning. ProductIdList - " + productIdList + ". QuantityList - " + quantityList);
            return bean;
        }

        try {
            Long transactionId = transactionService.getNextTransactionId();

            logger.info("Request in process login: ===> " + login);

            String remoteUser = request.getRemoteUser();
            if(remoteUser == null)
                remoteUser = login;

            logger.info("Request in process login RMUSer: ===> " + remoteUser);
            Boolean success = processTransaction.process(productIdList, quantityList, remoteUser, bean, transactionId);

            if (success) {
                request.getSession().setAttribute("TRANSACTION_ID", transactionId);
            } else {
                processTransaction.cancel(transactionId);
            }
        } catch (Exception e) {
            logger.info("Unexpected error - " + e.getMessage());
            bean.setError("Sorry, an error has occurred, please try again.");
            e.printStackTrace();
        }

        return bean;
    }

    @Override
    public ConfirmBean confirm(final Long transactionId, Boolean mobile) {
        ConfirmBean bean = new ConfirmBean();
        bean.setSuccess(false);

        List<ProcessTransaction.RequirementRecord> records = Collections.emptyList();
        try {
            records = processTransaction.confirm(transactionId);
            List<TCardInfo> cards = cardService.findByTransactionIdAndSold(transactionId);
            for (ProcessTransaction.RequirementRecord record : records) {

                for (TCardInfo card : cards) {
                    if (record.m_nProductID == card.getProduct().getId()) {
                        if(mobile) {
                            //record.cardInfoBeans.add(new CardInfoBean(card, getPrintCardInfo(card).replaceAll("\\r\\n|\\r|\\n", " ")));
                            record.cardInfoBeans.add(new CardInfoBean(card, getPrintCardInfo(card).replaceAll("Or\\r\\nDial ", "Or Deal")));
                        } else {
                            record.cardInfoBeans.add(new CardInfoBean(card, getPrintCardInfo(card)));
                        }

                    }
                }
            }
            List<TTransactions> transactions = transactionService.findByTransactionIdAndCommitted(transactionId, (byte) TransactionStatus.COMMITTED.ordinal());
            if (transactions.isEmpty()) {
                bean.setError("Transaction is not found.");
                return bean;
            } else {
                TTransactions transaction = transactions.get(0);
                bean.setCustomerCompanyName(transaction.getCustomer().getCompanyName());
                bean.setTransactionId(transaction.getTransactionId());

                String date_s = transaction.getTransactionTime().toString();
                SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd");
                Date date = dt.parse(date_s);
                System.out.println("=======> " + dt.format(transaction.getTransactionTime()));

                if(mobile){
                    bean.setTransactionTime(dt.format(transaction.getTransactionTime()));
                } else {
                    bean.setTransactionTime(transaction.getTransactionTime().toString());
                }
                bean.setSuccess(true);
            }
        } catch (Exception e) {
            bean.setError("An error has occurred by processing the transaction.");
            processTransaction.cancel(transactionId);
            e.printStackTrace();
        }

        bean.setProducts(records);

        return bean;
    }

    @Override
    public Workbook getFileForBulkDownload(Long transactionId) {
        Workbook wb = new HSSFWorkbook();

        List<TTransactions> transactions = transactionService.findByTransactionId(transactionId);
        if (transactions.isEmpty()) {
            transactions = transactionService.findByTransactionIdFromHistory(transactionId);
        }

        int rowNumber = 0;

        try {
            Sheet sheet = wb.createSheet("new sheet");
            sheet.setColumnWidth(0, 8000);
            sheet.setColumnWidth(1, 8000);
            Row rowId = sheet.createRow(rowNumber++);
            rowId.createCell(0).setCellValue("TRANSACTION ID");
            rowId.createCell(1).setCellValue(transactionId);

            if (!transactions.isEmpty()) {
                Row rowTime = sheet.createRow(rowNumber++);
                rowTime.createCell(0).setCellValue("TRANSACTION TIME");
                Cell cell = rowTime.createCell(1);

                CellStyle cellStyle = wb.createCellStyle();
                CreationHelper createHelper = wb.getCreationHelper();
                short dateFormat = createHelper.createDataFormat().getFormat("yyyy-dd-MM HH:mm:ss");
                cellStyle.setDataFormat(dateFormat);

                cell.setCellValue(transactions.get(0).getTransactionTime());
                cell.setCellStyle(cellStyle);

                rowNumber++;
                Row rowPin = sheet.createRow(rowNumber++);
                rowPin.createCell(0).setCellValue("PIN");
                rowPin.createCell(1).setCellValue("SERIAL NUMBER");
                for (TTransactions transaction : transactions) {
                    List<TCardInfo> cardInfoList = cardService.findByProductAndBatchAndtransactionIdAndIsSoldTrue(transaction.getProduct(), transaction.getBatch(), transaction.getTransactionId());
                    if (cardInfoList.isEmpty()) {
                        cardInfoList = cardService.findByProductAndBatchAndtransactionIdAndIsSoldTrueFromHistory(transaction.getProduct(), transaction.getBatch(), transaction.getTransactionId());
                    }
                    for (TCardInfo cardInfo : cardInfoList) {
                        Row row = sheet.createRow(rowNumber++);
                        row.createCell(0).setCellValue(cardInfo.getCardPin());
                        row.createCell(1).setCellValue(cardInfo.getCardId());
                    }
                }
            }
        } catch (Exception e) {
            logger.error("Error by Bulk Download File. TransactionID - " + transactionId);
            e.printStackTrace();
        }

        return wb;
    }

    @Override
    public String getPrintCardInfo(TCardInfo cardInfo) {
        System.out.println("=====> " + cardInfo.getCardPin().replaceAll("(....)", "$1 ").trim());
        String strPrintInfo = cardInfo.getBatch().getProductsaleinfo().getPrintInfo();
        strPrintInfo = strPrintInfo.trim();
        strPrintInfo = strPrintInfo.replaceFirst("<<BATCH_OR_SERIAL_NUMBER>>", cardInfo.getCardId());
        strPrintInfo = strPrintInfo.replaceFirst("<<BATCH_OR_SERIAL_NUMBER>", cardInfo.getCardId());
        String strCardPin = "<span  style='font-size: small; font-family: Verdana;'>" + cardInfo.getCardPin().replaceAll("(....)", "$1 ").trim() + "</span>";
        strPrintInfo = strPrintInfo.replaceFirst("<<CARD_PIN_NUMBER>>", strCardPin);
        //String strExpiryDate = "<font size='2' face='Verdana'>" + dt.format(date_s) + "</font>";
        String strExpiryDate = "<font size='2' face='Verdana'>" + cardInfo.getBatch().getExpiryDate().toString() + "</font>";
        strPrintInfo = strPrintInfo.replaceFirst("<<EXPIRßY_DATE>>", strExpiryDate);
        return strPrintInfo.trim();
    }

    @Override
    public ConfirmBean getPrintTransactionInfo(Long transactionId) {
        ConfirmBean bean = new ConfirmBean();
        bean.setSuccess(false);
        bean.setTransactionId(transactionId);

        List<TTransactions> transactions = transactionService.findByTransactionId(transactionId);
        if (transactions.isEmpty()) {
            transactions = transactionService.findByTransactionIdFromHistory(transactionId);
        }
        if (!transactions.isEmpty()) {
            TTransactions transaction = transactions.get(0);
            bean.setCustomerCompanyName(transaction.getCustomer().getCompanyName());
            bean.setTransactionTime(transaction.getTransactionTime().toString());
            bean.setTransactionType(TransactionType.TRANSACTION);
            bean.setProducts(getTransactionInfo(transactions, transactionId));
            bean.setSuccess(true);
        }

        if (!bean.isSuccess()) {
            List<TSimTransactions> simTransactions = simTransactionService.findByTransactionId(transactionId);
            if (!simTransactions.isEmpty()) {
                bean.setTransactionType(TransactionType.SIM_TRANSACTION);
                bean.setProducts(Collections.singletonList(getSimTransactionInfo(simTransactions.get(0))));
                bean.setSuccess(true);
            }
        }

        if (!bean.isSuccess()) {
            TDingTransactions dingTransaction = dingTransactionService.findByTransactionId(transactionId);
            if (dingTransaction != null) {
                bean.setTransactionType(TransactionType.DING_TRANSACTION);
                bean.setProducts(Collections.singletonList(dingTransaction));
                bean.setSuccess(true);
            }
        }

        if (!bean.isSuccess()) {
            MobitopupTransaction mobitopupTransaction = mobitopupTransactionService.findByTransactionId(transactionId);
            if (mobitopupTransaction != null) {
                bean.setTransactionType(TransactionType.MOBITOPUP_TRANSACTION);
                bean.setProducts(Collections.singletonList(mobitopupTransaction));
                bean.setSuccess(true);
            }
        }

        return bean;
    }

    @Override
    public List getTransactionInfo(List<TTransactions> transactions, Long transactionId) {
        List<ProcessTransaction.RequirementRecord> records = new ArrayList<>();
        List<TCardInfo> cards = cardService.findByTransactionIdAndSold(transactionId);
        for (TTransactions transaction : transactions) {
            ProcessTransaction.RequirementRecord record = new ProcessTransaction.RequirementRecord();
            record.m_nProductID = transaction.getProduct().getId();
            record.m_nRequiredQuantity = transaction.getQuantity();
            record.m_nProcessedQuantity = transaction.getQuantity();
            record.m_fFaceValue = transaction.getProduct().getProductFaceValue();
            record.m_strImageFilePath = transaction.getBatch().getProductsaleinfo().getProductImageFile();
            record.m_strProductName = transaction.getProduct().getProductName();
            record.m_fCostToCustomer = transaction.getUnitPurchasePrice();

            for (TCardInfo card : cards) {
                if (record.m_nProductID == card.getProduct().getId()) {
                    record.cardInfoBeans.add(new CardInfoBean(card, getPrintCardInfo(card)));
                }
            }

            records.add(record);
        }
        return records;
    }

    @Override
    public PrintSimTransaction getSimTransactionInfo(TSimTransactions simTransaction) {
        PrintSimTransaction bean = new PrintSimTransaction();
        bean.setTransactionId(simTransaction.getTransactionId());
        bean.setTransactionTime(simTransaction.getTransactionTime());
        bean.setProductName(simTransaction.getSimCard().getProduct().getProductName());
        bean.setSimCardPin(simTransaction.getSimCard().getSimCardPin());
        bean.setCompanyName(simTransaction.getCustomer().getCompanyName());
        return bean;
    }
}
