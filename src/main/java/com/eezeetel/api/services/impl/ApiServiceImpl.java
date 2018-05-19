package com.eezeetel.api.services.impl;

import com.eezeetel.api.responses.BalanceResponse;
import com.eezeetel.api.responses.Product;
import com.eezeetel.api.responses.ProductResponse;
import com.eezeetel.api.responses.PurchaseResporse;
import com.eezeetel.api.services.ApiService;
import com.eezeetel.entity.*;
import com.eezeetel.enums.TransactionStatus;
import com.eezeetel.service.*;
import com.eezeetel.util.EncoderUtil;
import lombok.extern.log4j.Log4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.stream.Collectors;

@Log4j
@Service
public class ApiServiceImpl implements ApiService {

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private UserService userService;

    @Autowired
    private SupplierService supplierService;

    @Autowired
    private ProductService productService;

    @Autowired
    private BatchService batchService;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private CustomerUserService customerUserService;

    @Autowired
    private GroupService groupService;

    @Autowired
    private CardService cardService;

    @Autowired
    private TransactionBalanceService transactionBalanceService;

    @Autowired
    private GroupTransactionBalanceService groupTransactionBalanceService;

    @Autowired
    private CustomerGroupCommissionService customerGroupCommissionService;

    @Autowired
    private CustomerCommissionService customerCommissionService;

    @Autowired
    private RequestLogService requestLogService;

    @Override
    public BalanceResponse getBalance(String login, Long key, String md5) {
        BalanceResponse response = new BalanceResponse();
        User user = userService.findByLogin(login);
        if (user == null || validHex(user, key, md5)) {
            response.setErrorCode(1);
            response.setErrorText(messageSource.getMessage("api.error.authentication_failed", null, Locale.ENGLISH));
            return response;
        }

        if (validKey(user, key)) {
            response.setErrorCode(2);
            response.setErrorText(messageSource.getMessage("api.error.key", null, Locale.ENGLISH));
            return response;
        }

        requestLogService.addLog(user, key, md5);

        float balance = 0f;
        if (!user.getCustomerUsers().isEmpty()) {
            balance = user.getCustomerUsers().get(0).getCustomer().getCustomerBalance();
        }

        response.setErrorCode(0);
        response.setErrorText(messageSource.getMessage("api.success", null, Locale.ENGLISH));
        response.setBalance(new BigDecimal(balance + "").setScale(2, BigDecimal.ROUND_HALF_UP));
        return response;
    }

    @Override
    public ProductResponse<Product> getSuppliers(String login, Long key, String md5) {
        ProductResponse<Product> response = new ProductResponse<>();
        User user = userService.findByLogin(login);
        if (user == null || validHex(user, key, md5)) {
            response.setErrorCode(1);
            response.setErrorText(messageSource.getMessage("api.error.authentication_failed", null, Locale.ENGLISH));
            return response;
        }

        if (validKey(user, key)) {
            response.setErrorCode(2);
            response.setErrorText(messageSource.getMessage("api.error.key", null, Locale.ENGLISH));
            return response;
        }

        requestLogService.addLog(user, key, md5);

        response.setErrorCode(0);
        response.setErrorText(messageSource.getMessage("api.success", null, Locale.ENGLISH));
        response.setSuppliers(supplierService.getProducts());
        return response;
    }

    @Override
    public ProductResponse<Product> getProducts(String login, Long key, String md5, Integer supplierId) {
        ProductResponse<Product> response = new ProductResponse<>();
        User user = userService.findByLogin(login);
        if (user == null || validHex(user, key, md5)) {
            response.setErrorCode(1);
            response.setErrorText(messageSource.getMessage("api.error.authentication_failed", null, Locale.ENGLISH));
            return response;
        }

        if (validKey(user, key)) {
            response.setErrorCode(2);
            response.setErrorText(messageSource.getMessage("api.error.key", null, Locale.ENGLISH));
            return response;
        }

        requestLogService.addLog(user, key, md5);

        if (supplierId == null || supplierService.findOne(supplierId) == null) {
            response.setErrorCode(3);
            response.setErrorText(messageSource.getMessage("api.error.products.supplier_not_fount", null, Locale.ENGLISH));
            return response;
        }

        List<Product> products = productService.findBySupplierId(supplierId).stream().map(Product::new).collect(Collectors.toList());

        if (user.getCustomerUsers().isEmpty() || user.getCustomerUsers().get(0).getCustomer() == null) {
            log.info("Error: API /products. Customer not found for user - " + user.getLogin());
            response.setErrorCode(10);
            response.setErrorText(messageSource.getMessage("api.error.unexpected", null, Locale.ENGLISH));
            return response;
        }

        TMasterCustomerinfo customer = user.getCustomerUsers().get(0).getCustomer();
        for (Product p : products) {
            List<TBatchInformation> batches = batchService.findByProductAndReadyToSell(p.getId());
            if (batches.isEmpty()) {
                p.setAvailable(false);
            } else {
                float price = batches.get(0).getUnitPurchasePrice();

                TCustomerGroupCommissions groupCommission = customerGroupCommissionService.findByGroupAndProduct(customer.getGroup().getId(), p.getId());
                if (groupCommission != null) {
                    price += groupCommission.getCommission();
                }

                TCustomerCommission customerCommission = customerCommissionService.findByCustomerAndProduct(customer.getId(), p.getId());
                if (customerCommission != null) {
                    price += customerCommission.getCommission();
                    price += customerCommission.getAgentCommission();
                }

                p.setAvailable(true);
                p.setPrice(new BigDecimal(price + "").setScale(2, BigDecimal.ROUND_HALF_UP));
            }
        }

        response.setErrorCode(0);
        response.setErrorText(messageSource.getMessage("api.success", null, Locale.ENGLISH));
        response.setProducts(products);
        return response;
    }

    @Override
    public PurchaseResporse purchase(String login, Long key, String md5, Integer productId) {
        PurchaseResporse response = new PurchaseResporse();
        try {
            User user = userService.findByLogin(login);
            if (user == null || validHex(user, key, md5)) {
                response.setErrorCode(1);
                response.setErrorText(messageSource.getMessage("api.error.authentication_failed", null, Locale.ENGLISH));
                return response;
            }

            if (validKey(user, key)) {
                response.setErrorCode(2);
                response.setErrorText(messageSource.getMessage("api.error.key", null, Locale.ENGLISH));
                return response;
            }

            requestLogService.addLog(user, key, md5);

            Long transactionId = transactionService.getNextTransactionId();

            TCustomerUsers customerUser = customerUserService.findByLogin(login);
            TMasterCustomerinfo customer = customerUser.getCustomer();
            TMasterCustomerGroups group = customer.getGroup();

            if (group.getCheckAganinstGroupBalance() && group.getCustomerGroupBalance() < 500.0F) {
                //log.info("The balance is less than 500. Group - " + custGroups.getName() + ". Customer - " + custInfo.getCompanyName());
            }

            float profitEezeeTel = 0;
            float profitGroup = 0;
            float profitAgent = 0;

            TMasterProductinfo product = productService.findOne(productId);
            if (product == null) {
                response.setErrorCode(3);
                response.setErrorText(messageSource.getMessage("api.error.purchase.product_not_fount", null, Locale.ENGLISH));
                return response;
            }
            TCustomerCommission customerCommission = customerCommissionService.findByCustomerAndProduct(customer.getId(), productId);
            if (customerCommission != null) {
                profitGroup = customerCommission.getCommission();
                profitAgent = customerCommission.getAgentCommission();
            }

            TCustomerGroupCommissions customerGroupCommission = customerGroupCommissionService.findByGroupAndProduct(group.getId(), productId);
            if (customerGroupCommission != null) {
                profitEezeeTel = customerGroupCommission.getCommission();
            }

            List<TBatchInformation> batches = batchService.findByProductAndReadyToSell(productId);
            if (batches.isEmpty()) {
                response.setErrorCode(4);
                response.setErrorText(messageSource.getMessage("api.error.purchase.product_not_available", null, Locale.ENGLISH));
                return response;
            }

            TBatchInformation batch = batches.get(0);
            batch.setAvailableQuantity(batch.getAvailableQuantity() - 1);
            batch.setLastTouchTime(Calendar.getInstance().getTime());
            batch = batchService.save(batch);

            float fFaceValuePrice = product.getProductFaceValue();
            float fBatchCostOriginal = batch.getUnitPurchasePrice();
            float fCostToCustomerGroup = fBatchCostOriginal + profitEezeeTel;
            float fCostToCustomerAgent = fCostToCustomerGroup + profitGroup;
            float fCostToCustomer = fCostToCustomerAgent + profitAgent;
            if (fCostToCustomer > fFaceValuePrice) {
                fCostToCustomerGroup = fFaceValuePrice;
                fCostToCustomerAgent = fFaceValuePrice;
                fCostToCustomer = fFaceValuePrice;
            }
            if (group.getSellAtFaceValue()) {
                fCostToCustomer = fFaceValuePrice;
                fCostToCustomerAgent = fCostToCustomer - profitAgent;
            }

            if (customer.getCustomerBalance() < fCostToCustomer) {
                response.setErrorCode(5);
                response.setErrorText(messageSource.getMessage("api.error.purchase.balance", null, Locale.ENGLISH));
                return response;
            }

            TTransactions transaction = new TTransactions();
            transaction.setUser(customerUser.getUser());
            transaction.setProduct(product);
            transaction.setCustomer(customer);
            transaction.setBatch(batch);
            transaction.setTransactionId(transactionId);
            transaction.setQuantity(1);
            transaction.setUnitPurchasePrice(fCostToCustomer);
            transaction.setSecondaryTransactionPrice(fCostToCustomerAgent);
            transaction.setCommitted((byte) TransactionStatus.COMMITTED.ordinal());
            transaction.setTransactionTime(Calendar.getInstance().getTime());
            transaction.setUnitGroupPrice(fCostToCustomerGroup);
            transaction.setBatchUnitPrice(fBatchCostOriginal);

            transactionService.save(transaction);

            List<TCardInfo> card_list = cardService.findByBatchAndIsSoldOrderByIdAsc(batch, false, new PageRequest(0, transaction.getQuantity()));
            if (card_list.size() <= 0 || card_list.size() != transaction.getQuantity()) {
                log.info("API - PROBLEM Batch = " + batch.getSequenceId() + ", card_list: " + card_list.size() + ". Transaction ID = " + transaction.getTransactionId());
                response.setErrorCode(10);
                response.setErrorText(messageSource.getMessage("api.error.unexpected", null, Locale.ENGLISH));
                return response;
            } else {
                for (TCardInfo cardInfo : card_list) {
                    cardInfo.setIsSold(true);
                    cardInfo.setTransactionId(transactionId);
                    response.setCardId(cardInfo.getCardId());
                    response.setCardPin(cardInfo.getCardPin());
                    response.setCardInfo(productService.getPrintCardInfo(cardInfo));
                }
                cardService.save(card_list);
            }

            transactionBalanceService.create(transactionId, customer.getCustomerBalance(), customer.getCustomerBalance() - transaction.getUnitPurchasePrice());

            customer.setCustomerBalance(customer.getCustomerBalance() - transaction.getUnitPurchasePrice());
            customerService.save(customer);

            if (group.getCheckAganinstGroupBalance()) {
                BigDecimal balanceBefore = new BigDecimal(group.getCustomerGroupBalance() + "");
                BigDecimal balanceAfter = balanceBefore.subtract(new BigDecimal(transaction.getUnitGroupPrice() + ""));

                groupTransactionBalanceService.create(transactionId, balanceBefore, balanceAfter);

                group.setCustomerGroupBalance(balanceAfter.floatValue());
                groupService.save(group);
            }

            response.setTransactionId(transactionId);
            response.setTransactionTime(transaction.getTransactionTime());
            response.setProductId(product.getId());
            response.setProductName(product.getProductName());
            response.setProductValue(new BigDecimal(product.getProductFaceValue() + ""));
            response.setPrice(new BigDecimal(transaction.getUnitPurchasePrice() + "").setScale(2, BigDecimal.ROUND_HALF_UP));
            response.setBalance(new BigDecimal(customer.getCustomerBalance() + "").setScale(2, BigDecimal.ROUND_HALF_UP));
            response.setErrorCode(0);
            response.setErrorText(messageSource.getMessage("api.success", null, Locale.ENGLISH));
        } catch (Exception e) {
            e.printStackTrace();
            response = new PurchaseResporse();
            response.setErrorCode(10);
            response.setErrorText(messageSource.getMessage("api.error.unexpected", null, Locale.ENGLISH));
        }
        return response;
    }

    @Override
    public PurchaseResporse purchasetest(String login, Long key, String md5, Integer productId) {
        PurchaseResporse response = new PurchaseResporse();
        try {
            User user = userService.findByLogin(login);
            if (user == null || validHex(user, key, md5)) {
                response.setErrorCode(1);
                response.setErrorText(messageSource.getMessage("api.error.authentication_failed", null, Locale.ENGLISH));
                return response;
            }

            if (validKey(user, key)) {
                response.setErrorCode(2);
                response.setErrorText(messageSource.getMessage("api.error.key", null, Locale.ENGLISH));
                return response;
            }

            requestLogService.addLog(user, key, md5);

            TCustomerUsers customerUser = customerUserService.findByLogin(login);
            TMasterCustomerinfo customer = customerUser.getCustomer();
            TMasterCustomerGroups group = customer.getGroup();

            float profitEezeeTel = 0;
            float profitGroup = 0;
            float profitAgent = 0;

            TMasterProductinfo product = productService.findOne(productId);
            if (product == null) {
                response.setErrorCode(3);
                response.setErrorText(messageSource.getMessage("api.error.purchase.product_not_fount", null, Locale.ENGLISH));
                return response;
            }
            TCustomerCommission customerCommission = customerCommissionService.findByCustomerAndProduct(customer.getId(), productId);
            if (customerCommission != null) {
                profitGroup = customerCommission.getCommission();
                profitAgent = customerCommission.getAgentCommission();
            }

            TCustomerGroupCommissions customerGroupCommission = customerGroupCommissionService.findByGroupAndProduct(group.getId(), productId);
            if (customerGroupCommission != null) {
                profitEezeeTel = customerGroupCommission.getCommission();
            }

            List<TBatchInformation> batches = batchService.findByProductAndReadyToSell(productId);
            if (batches.isEmpty()) {
                response.setErrorCode(4);
                response.setErrorText(messageSource.getMessage("api.error.purchase.product_not_available", null, Locale.ENGLISH));
                return response;
            }

            TBatchInformation batch = batches.get(0);

            float fFaceValuePrice = product.getProductFaceValue();
            float fBatchCostOriginal = batch.getUnitPurchasePrice();
            float fCostToCustomerGroup = fBatchCostOriginal + profitEezeeTel;
            float fCostToCustomerAgent = fCostToCustomerGroup + profitGroup;
            float fCostToCustomer = fCostToCustomerAgent + profitAgent;
            if ((fCostToCustomer > fFaceValuePrice) || (fCostToCustomer < fBatchCostOriginal)) {
                fCostToCustomerGroup = fFaceValuePrice;
                fCostToCustomerAgent = fFaceValuePrice;
                fCostToCustomer = fFaceValuePrice;
            }
            if (group.getSellAtFaceValue()) {
                fCostToCustomer = fFaceValuePrice;
                fCostToCustomerAgent = fCostToCustomer - profitAgent;
            }

            if (customer.getCustomerBalance() < fCostToCustomer) {
                response.setErrorCode(5);
                response.setErrorText(messageSource.getMessage("api.error.purchase.balance", null, Locale.ENGLISH));
                return response;
            }

            TTransactions transaction = new TTransactions();
            transaction.setUser(customerUser.getUser());
            transaction.setProduct(product);
            transaction.setCustomer(customer);
            transaction.setBatch(batch);
            transaction.setQuantity(1);
            transaction.setUnitPurchasePrice(fCostToCustomer);
            transaction.setSecondaryTransactionPrice(fCostToCustomerAgent);
            transaction.setCommitted((byte) TransactionStatus.COMMITTED.ordinal());
            transaction.setTransactionTime(Calendar.getInstance().getTime());
            transaction.setUnitGroupPrice(fCostToCustomerGroup);
            transaction.setBatchUnitPrice(fBatchCostOriginal);

            TCardInfo cardInfo = cardService.findOne(86111L);
            if(cardInfo != null) {
                response.setCardId("2283059");
                response.setCardPin("1813407961");
                response.setCardInfo(productService.getPrintCardInfo(cardInfo));
            } else {
                response.setCardId("2283059");
                response.setCardPin("1813407961");
                response.setCardInfo("No Info");
            }



            response.setTransactionId(12345l);
            response.setTransactionTime(Calendar.getInstance().getTime());
            response.setProductId(product.getId());
            response.setProductName(product.getProductName());
            response.setProductValue(new BigDecimal(product.getProductFaceValue() + ""));
            response.setPrice(new BigDecimal(transaction.getUnitPurchasePrice() + "").setScale(2, BigDecimal.ROUND_HALF_UP));
            response.setBalance(new BigDecimal(customer.getCustomerBalance() + "").setScale(2, BigDecimal.ROUND_HALF_UP));
            response.setErrorCode(0);
            response.setErrorText(messageSource.getMessage("api.success", null, Locale.ENGLISH));
        } catch (Exception e) {
            e.printStackTrace();
            response = new PurchaseResporse();
            response.setErrorCode(10);
            response.setErrorText(messageSource.getMessage("api.error.unexpected", null, Locale.ENGLISH));
        }
        return response;
    }

    private boolean validKey(User user, Long key) {
        return requestLogService.existsByUserAndKey(user, key);
    }

    private boolean validHex(User user, Long key, String md5) {
        return key == null || StringUtils.isBlank(md5) || !Objects.equals(EncoderUtil.getMD5Hex(user.getLogin() + user.getPassword2() + key), md5);
    }
}
