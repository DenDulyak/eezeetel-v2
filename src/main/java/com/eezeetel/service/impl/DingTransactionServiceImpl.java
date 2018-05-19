package com.eezeetel.service.impl;

import com.ding.DingMain;
import com.eezeetel.bean.report.WorldMobileTopupSummary;
import com.eezeetel.entity.*;
import com.eezeetel.enums.TransactionStatus;
import com.eezeetel.repository.DingTransactionRepository;
import com.eezeetel.service.*;
import com.eezeetel.util.DateUtil;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Collections;
import java.util.Date;
import java.util.List;

@Service
public class DingTransactionServiceImpl implements DingTransactionService {

    @Autowired
    private DingTransactionRepository repository;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private CustomerUserService customerUserService;

    @Autowired
    private TransactionBalanceService balanceService;

    @Autowired
    private GroupTransactionBalanceService groupBalanceService;

    @Autowired
    private GroupService groupService;

    @Override
    public TDingTransactions findOne(Long id) {
        return repository.findOne(id);
    }

    @Override
    public List<TDingTransactions> findAll() {
        return repository.findAll();
    }

    @Override
    public TDingTransactions save(TDingTransactions dingTransaction) {
        return repository.save(dingTransaction);
    }

    @Override
    public TDingTransactions findByTransactionId(Long transactionId) {
        return repository.findByTransactionId(transactionId);
    }

    @Override
    public List<TDingTransactions> findByRequesterPhone(String login, Integer errorCode, String requesterPhone) {
        TCustomerUsers user = customerUserService.findByLogin(login);
        return repository.findByRequesterPhone(user.getCustomer(), errorCode, requesterPhone);
    }

    @Override
    public TDingTransactions findLastSuccessfulTransactionByDestinationPhone(TMasterCustomerinfo customer, String destinationPhone) {
        List<TDingTransactions> transactions = repository.findByCustomerAndErrorCodeAndDestinationPhoneOrderByTransactionTimeDesc(customer, 1, destinationPhone);

        return transactions.isEmpty() ? null : transactions.get(0);
    }

    @Override
    public Long checkTimeLimitForTransaction(TMasterCustomerinfo customer, String destinationPhone) {
        TDingTransactions dingTransaction = findLastSuccessfulTransactionByDestinationPhone(customer, destinationPhone);
        if (dingTransaction == null) {
            return 0L;
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime transactionTime = DateUtil.toLocalDateTime(dingTransaction.getTransactionTime()).plusMinutes(10);

        return transactionTime.isAfter(now) ? ChronoUnit.MINUTES.between(now, transactionTime) : 0L;
    }

    @Override
    public List<TDingTransactions> findByGroupAndDate(int errorCode, TMasterCustomerGroups group, Date startDate, Date endDate) {
        if (group == null || group.getId() == 0) {
            return repository.findByErrorCodeAndTransactionTimeBetween(errorCode, startDate, endDate);
        }

        return repository.findByErrorCodeAndCustomerGroupAndTransactionTimeBetween(errorCode, group, startDate, endDate);
    }

    @Override
    public List<TDingTransactions> findByGroupAndDateUser(User user, int errorCode, TMasterCustomerGroups group, Date startDate, Date endDate) {
        return null;
    }

    @Override
    public List<TDingTransactions> findByErrorCodeAndCustomerAndTransactionTimeBetween(int errorCode, TMasterCustomerinfo customer, Date startDate, Date endDate) {
        return repository.findByErrorCodeAndCustomerAndTransactionTimeBetween(errorCode, customer, startDate, endDate);
    }

    @Override
    public List<TDingTransactions> findTransactionsBetweenDays(LocalDate startDay, LocalDate endDay, Integer groupId, Integer type) {
        List<TDingTransactions> result = Collections.emptyList();

        String destinationCountryId = "JM";
        String digicelOperatorId = "DC";

        switch (type) {
            case 0:
                result = repository.findByErrorCodeAndTransactionTimeBetween(1, DateUtil.getStartOfDay(startDay), DateUtil.getEndOfDay(endDay));
                break;
            case 1:
                result = repository.findByErrorCodeAndTransactionTimeBetween(1, DateUtil.getStartOfDay(startDay), DateUtil.getEndOfDay(endDay));
                result.removeIf(r -> r.getDestinationCountryId().equals(destinationCountryId) && r.getDestinationOperatorId().equals(digicelOperatorId));
                break;
            case 2:
                result = repository.findByTransactionTimeBetweenAndDestinationCountryIdAndDestinationOperatorId(
                        DateUtil.getStartOfDay(startDay), DateUtil.getEndOfDay(endDay),
                        destinationCountryId, digicelOperatorId);
                break;
        }

        if (groupId > 0) {
            result.removeIf(t -> !t.getCustomer().getGroup().getId().equals(groupId));
        }

        return result;
    }

    @Override
    public List<WorldMobileTopupSummary> getSummaryTransactions(LocalDate startDay, LocalDate endDay) {
        return repository.getSummaryTransactions(DateUtil.getStartOfDay(startDay), DateUtil.getEndOfDay(endDay));
    }

    @Override
    public BigDecimal calcCustomerPriceBetweenDates(Integer customerId, Date startDate, Date endDate) {
        BigDecimal price = repository.calcCustomerPriceBetweenDates(customerId, startDate, endDate);
        return price == null ? new BigDecimal("0") : price;
    }

    @Override
    public BigDecimal calcGroupPriceBetweenDates(Integer groupId, Date startDate, Date endDate) {
        BigDecimal price = repository.calcGroupPriceBetweenDates(groupId, startDate, endDate);
        return price == null ? new BigDecimal("0") : price;
    }

    @Override
    public Integer countCustomerTransactionsBetweenDates(Integer customerId, Date startDate, Date endDate) {
        return repository.countCustomerTransactionsBetweenDates(customerId, startDate, endDate);
    }

    @Override
    public Integer countGroupTransactionsBetweenDates(Integer groupId, Date startDate, Date endDate) {
        return repository.countGroupTransactionsBetweenDates(groupId, startDate, endDate);
    }

    /*public TDingTransactions initTransaction(Integer customerId, String user, String senderPhone, String destinationPhone,
                                             float costToCustomer, float costToAgent, float costToGroup, float costToEezeeTel) {
        TDingTransactions ding = new TDingTransactions();
        Long transactionId = transactionService.getNextTransactionId();

        ding.setDingTransactionId(0L);
        ding.setErrorCode(0);
        ding.setErrorText("Init Transaction.");
        ding.setRequesterPhone(senderPhone);
        ding.setDestinationPhone(destinationPhone);
        ding.setOriginatingCurrency("UK");
        ding.setCustomer(new TMasterCustomerinfo(customerId));
        ding.setUser(new User(user));
        ding.setSmsSent("NO");
        ding.setTransactionStatus((byte) TransactionStatus.COMMITTED.ordinal());
        ding.setCostToCustomer(costToCustomer);
        ding.setCostToAgent(costToAgent);
        ding.setCostToGroup(topuRes.m_fCostToGroup);
        ding.setCostToEezeeTel(topuRes.m_fCostToEezeeTel);

        return null;
    }*/

    @Override
    @Transactional
    public TDingTransactions create(DingMain.TopupResponse topuRes, Integer customerId, String user) {
        Long transactionId = transactionService.getNextTransactionId();
        TDingTransactions ding = new TDingTransactions();
        topuRes.m_eezeeTelTransactionID = transactionId + "";

        ding.setTransactionId(transactionId);
        ding.setDingTransactionId(NumberUtils.toLong(topuRes.m_dingTransactionID));
        ding.setErrorCode(topuRes.m_nErrorCode);
        ding.setErrorText(topuRes.m_strErrorText);
        ding.setRequesterPhone(topuRes.m_strSender);
        ding.setDestinationPhone(topuRes.m_strReceiver);
        ding.setOriginatingCurrency("UK");
        ding.setDestinationCountry(topuRes.m_strCountry);
        ding.setDestinationCountryId(topuRes.m_strCountryCode);
        ding.setDestinationOperator(topuRes.m_strOperator);
        ding.setDestinationOperatorId(topuRes.m_strOperatorCode);
        ding.setDestinationCurrency(topuRes.m_strCurrencyCode);
        ding.setOperatorReferenceInfo(topuRes.m_strCustomerCare);
        ding.setSmsSent(topuRes.m_strSMSSent);
        ding.setSmsText(topuRes.m_strSMSString == null ? "" : topuRes.m_strSMSString);
        ding.setProductRequested(topuRes.m_fRetailPrice);
        ding.setProductSent(topuRes.m_fCostToEezeeTel);
        ding.setRetailPrice(topuRes.m_fRetailPrice);
        ding.setEezeeTelBalance(topuRes.m_fEezeeTelBalance);
        ding.setCustomer(new TMasterCustomerinfo(customerId));
        ding.setUser(new User(user));
        try {
            ding.setTransactionTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(topuRes.m_strTime));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        ding.setTransactionStatus((byte) TransactionStatus.COMMITTED.ordinal());
        ding.setCostToCustomer(topuRes.m_fCostToCustomer);
        ding.setCostToAgent(topuRes.m_fCostToAgent);
        ding.setCostToGroup(topuRes.m_fCostToGroup);
        ding.setCostToEezeeTel(topuRes.m_fCostToEezeeTel);
        ding = save(ding);

        TMasterCustomerinfo customer = customerService.findOne(customerId);

        balanceService.create(transactionId, customer.getCustomerBalance(), customer.getCustomerBalance() - topuRes.m_fCostToCustomer);

        customer.setCustomerBalance(customer.getCustomerBalance() - topuRes.m_fCostToCustomer);
        customerService.save(customer);

        TMasterCustomerGroups group = customer.getGroup();
        if (group.getCheckAganinstGroupBalance()) {
            BigDecimal balanceBefore = new BigDecimal(group.getCustomerGroupBalance() + "");
            BigDecimal balanceAfter = balanceBefore.subtract(new BigDecimal(topuRes.m_fCostToGroup + ""));

            groupBalanceService.create(transactionId, balanceBefore, balanceAfter);

            group.setCustomerGroupBalance(balanceAfter.floatValue());
            groupService.save(group);
        }

        return ding;
    }
}
