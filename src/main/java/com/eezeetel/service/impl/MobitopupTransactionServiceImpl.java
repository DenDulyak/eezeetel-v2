package com.eezeetel.service.impl;

import com.eezeetel.bean.report.WorldMobileTopupSummary;
import com.eezeetel.entity.*;
import com.eezeetel.mobitopup.MobitopupMethodImpl;
import com.eezeetel.mobitopup.MobitopupUtil;
import com.eezeetel.mobitopup.response.CheckNumber;
import com.eezeetel.mobitopup.response.Topup;
import com.eezeetel.repository.MobitopupTransactionRepository;
import com.eezeetel.repository.PinlessTransactionRepository;
import com.eezeetel.service.*;
import com.eezeetel.util.DateUtil;
import com.eezeetel.util.PriceUtil;
import lombok.extern.log4j.Log4j;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import javax.transaction.Transactional;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by Denis Dulyak on 28.03.2016.
 */
@Log4j
@Service
public class MobitopupTransactionServiceImpl implements MobitopupTransactionService {

    @Autowired
    private MobitopupTransactionRepository repository;

    @Autowired
    private GroupService groupService;

    @Autowired
    private CustomerUserService customerUserService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private MobitopupMethodImpl mobitopupMethod;

    @Autowired
    private TransactionBalanceService transactionBalanceService;

    @Autowired
    private GroupTransactionBalanceService groupTransactionBalanceService;

    @Autowired
    private PhoneTopupCountryService countryService;

    @Autowired
    private WorldTopupGroupCommissionService groupCommissionService;

    @Autowired
    private WorldTopupCustomerCommissionService customerCommissionService;

    @Autowired
    private PinlessCustomerCommissionService pinlessCustomerCommissionService;

    @Autowired
    private PinlessTransactionRepository pinlessTransactionRepository;

    @Override
    public MobitopupTransaction findByTransactionId(Long transactionId) {
        return repository.findByTransactionId(transactionId);
    }

    @Override
    public MobitopupTransaction findOne(Integer id) {
        return repository.findOne(id);
    }

    @Override
    public List<MobitopupTransaction> findAll() {
        return repository.findAll();
    }

    @Override
    public Page<MobitopupTransaction> findAll(Pageable pageable) {
        return repository.findByErrorCode(0, new PageRequest(pageable.getPageNumber(), pageable.getPageSize(), new Sort(Sort.Direction.DESC, "transactionId")));
    }

    @Override
    @Transactional
    public List<MobitopupTransaction> findByCustomerAndTransactionTime(TMasterCustomerinfo customer, Date from, Date to) {
        List<MobitopupTransaction> transactions = repository.findByCustomerAndTransactionTimeBetweenAndErrorCode(customer, from, to, 0);

        transactions.forEach(t -> {
            if (t.getTransactionBalance() != null) {
                t.getTransactionBalance().getBalanceAfterTransaction();
            }
        });

        return transactions;
    }

    @Override
    @Transactional
    public List<MobitopupTransaction> findByUserAndTransactionTimeBetween(User user, Date from, Date to) {
        List<MobitopupTransaction> transactions = repository.findByUserAndTransactionTimeBetweenAndErrorCode(user, from, to, 0);

        transactions.forEach(t -> {
            if (t.getTransactionBalance() != null) {
                t.getTransactionBalance().getBalanceAfterTransaction();
            }
        });

        return transactions;
    }

    @Override
    public List<MobitopupTransaction> findByErrorCodeAndCustomerAndTransactionTimeBetween(Integer errorCode, TMasterCustomerinfo customer, Date startDate, Date endDate) {
        return repository.findByErrorCodeAndCustomerAndTransactionTimeBetween(errorCode, customer, startDate, endDate);
    }

    @Override
    public List<MobitopupTransaction> findByRequesterPhone(String login, Integer errorCode, String requesterPhone) {
        TCustomerUsers user = customerUserService.findByLogin(login);
        return repository.findByRequesterPhone(user.getCustomer(), errorCode, requesterPhone);
    }

    @Override
    public MobitopupTransaction save(MobitopupTransaction transaction) {
        return repository.save(transaction);
    }

    @Override
    public List<MobitopupTransaction> findByGroupAndDate(Integer errorCode, TMasterCustomerGroups group, Date startDate, Date endDate) {
        if (group == null || group.getId() == 0) {
            return repository.findByErrorCodeAndTransactionTimeBetween(errorCode, startDate, endDate);
        }

        return repository.findByErrorCodeAndCustomerGroupAndTransactionTimeBetween(errorCode, group, startDate, endDate);
    }

    @Override
    public List<MobitopupTransaction> findByGroupAndDateAndUser(User user, Integer errorCode, TMasterCustomerGroups group, Date startDate, Date endDate) {
        return null;
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

    @Override
    public MobitopupTransaction topup(String destnumber, String srcnumber, String product, String message, String login) {
        MobitopupTransaction transaction = new MobitopupTransaction();
        transaction.setErrorCode(10);
        transaction.setErrorText("An error occurred please try again.");

        try {
            TCustomerUsers customerUser = customerUserService.findByLogin(login);
            TMasterCustomerinfo customer = customerUser.getCustomer();
            TMasterCustomerGroups group = customer.getGroup();

            if (StringUtils.isBlank(destnumber)) {
                transaction.setErrorText("Dest number - " + destnumber + " is not allowed for mobitopup.");
                return transaction;
            }

            if(customer.getCustomerBalance() <= 0) {
                throw new IllegalArgumentException("Your balance is low. Please request a topup as soon as possible");
            }

            CheckNumber checkNumber = mobitopupMethod.checkNumber(destnumber);
            if (checkNumber == null || !checkNumber.getError_code().equals(0)) {
                transaction.setErrorText("Dest number - " + destnumber + " is not allowed for mobitopup.");
                return transaction;
            }

            Long transactionId = transactionService.getNextTransactionId();

            srcnumber = StringUtils.isEmpty(srcnumber) ?
                    StringUtils.isEmpty(customer.getMobilePhone()) ? "2222222222" : customer.getMobilePhone()
                    : srcnumber;

            PhoneTopupCountry country = countryService.findByMobitopupCountryId(NumberUtils.toInt(checkNumber.getCountryid()));
            if (country == null) {
                log.info("The country - " + checkNumber.getCountry() + " is not found. " + "Country id - " + checkNumber.getCountryid());
                // for default is Great Britain
                country = countryService.findByIso("GB");
            }

            WorldTopupGroupCommission groupsCommission = groupCommissionService.findOrCreateByCountryAndGroupId(country, group.getId());
            WorldTopupCustomerCommission customersCommission = customerCommissionService.findOrCreateByGroupCommissionAndCustomer(groupsCommission, customer);

            transaction.setDestinationPhone(destnumber);
            transaction.setRequesterPhone(srcnumber);
            transaction.setProductRequested(product);
            transaction.setCountry(country);
            transaction.setNetworkId(checkNumber.getNetworkid());
            transaction.setNetwork(checkNumber.getNetwork());
            transaction.setCurrency(checkNumber.getCurrency());
            transaction.setLocalCurrency(checkNumber.getLocalcurrency());
            transaction.setMessage(message);
            transaction.setCustomer(customer);
            transaction.setUser(customerUser.getUser());
            transaction.setTransactionId(transactionId);
            transaction.setTransactionTime(new Date());
            String key = System.currentTimeMillis() + "";
            transaction.setAuthKey(key);

            transaction = save(transaction);

            String respons = MobitopupUtil.sendRequest(MobitopupUtil.getTopupUrl(key, destnumber, srcnumber, product, message));
            Topup topup = MobitopupUtil.getJsonResponse(respons, Topup.class);
            if (topup != null) {
                transaction.setErrorCode(topup.getError_code());
                transaction.setErrorText(topup.getError_text());
                if (topup.getError_code().equals(0)) {
                    BigDecimal eezeetelPrice = new BigDecimal(topup.getPrice());
                    BigDecimal eezeetelCommission = PriceUtil.getPercent(eezeetelPrice, new BigDecimal(groupsCommission.getPercent() + ""));
                    BigDecimal groupPrice = eezeetelPrice.add(eezeetelCommission);
                    BigDecimal groupCommission = PriceUtil.getPercent(groupPrice, new BigDecimal(customersCommission.getGroupPercent() + ""));
                    BigDecimal agentPrice = groupPrice.add(groupCommission);
                    BigDecimal agentCommission = PriceUtil.getPercent(agentPrice, new BigDecimal(customersCommission.getAgentPercent() + ""));
                    BigDecimal customerPrice = agentPrice.add(agentCommission);
                    BigDecimal customerCommission = PriceUtil.getPercent(
                            customerPrice,
                            MobitopupUtil.getCustomerCommission(
                                    MobitopupUtil.isDigicel(country.getIso(), checkNumber.getNetworkid())
                            )
                    );
                    BigDecimal retailPrice = customerPrice.add(customerCommission);

                    transaction.setOrderId(topup.getOrder_id());
                    transaction.setBalance(new BigDecimal(topup.getBalance()));
                    transaction.setPrice(eezeetelPrice);
                    transaction.setEezeetelCommission(eezeetelCommission);
                    transaction.setGroupCommission(groupCommission);
                    transaction.setAgentCommission(agentCommission);
                    transaction.setCustomerCommission(customerCommission);
                    transaction.setRetailPrice(retailPrice);
                    transaction.setProductRequested(topup.getProduct_requested());
                    transaction.setProductSent(topup.getProduct_sent());
                    transaction.setSmsSent(topup.getSms_sent());
                    transaction.setSenderSms(topup.getSender_sms());
                    transaction.setPostProcessingStage(false);

                    transactionBalanceService.create(transactionId, customer.getCustomerBalance(), customer.getCustomerBalance() - customerPrice.floatValue());
                    customer.setCustomerBalance(customer.getCustomerBalance() - customerPrice.floatValue());

                    if (group.getCheckAganinstGroupBalance()) {
                        BigDecimal balanceBefore = new BigDecimal(group.getCustomerGroupBalance() + "");
                        BigDecimal balanceAfter = balanceBefore.subtract(groupPrice);

                        groupTransactionBalanceService.create(transactionId, balanceBefore, balanceAfter);

                        group.setCustomerGroupBalance(balanceAfter.floatValue());
                        groupService.save(group);
                    }
                }
                transaction.setTopup(MobitopupUtil.validate(topup));
            }
            transaction.setResponse(respons);
            transaction = save(transaction);

            customerService.save(customer);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return transaction;
    }

    @Override
    public CheckNumber checkNumberV2(String login, String number) {
        TCustomerUsers customerUser = customerUserService.findByLogin(login);
        TMasterCustomerinfo customer = customerUser.getCustomer();
        TMasterCustomerGroups group = customer.getGroup();

        CheckNumber checkNumber = mobitopupMethod.checkNumberV2(number);
        if (checkNumber.getError_code() == 0) {
            List<String> ticketList = new ArrayList<>();
            PhoneTopupCountry country = countryService.findByMobitopupCountryId(NumberUtils.toInt(checkNumber.getCountryid()));
            if (country == null) {
                log.info("The country - " + checkNumber.getCountry() + " is not found. " + "Country id - " + checkNumber.getCountryid());
                country = countryService.findByIso("GB");
            }
            WorldTopupGroupCommission groupsCommission = groupCommissionService.findOrCreateByCountryAndGroupId(country, group.getId());
            WorldTopupCustomerCommission customersCommission = customerCommissionService.findOrCreateByGroupCommissionAndCustomer(groupsCommission, customer);

            for (String ticket : checkNumber.getTickets().split(",")) {
                BigDecimal eezeetelPrice = new BigDecimal(ticket.split("-")[1]);
                BigDecimal eezeetelCommission = PriceUtil.getPercent(eezeetelPrice, new BigDecimal(groupsCommission.getPercent() + ""));
                BigDecimal groupPrice = eezeetelPrice.add(eezeetelCommission);
                BigDecimal groupCommission = PriceUtil.getPercent(groupPrice, new BigDecimal(customersCommission.getGroupPercent() + ""));
                BigDecimal agentPrice = groupPrice.add(groupCommission);
                BigDecimal agentCommission = PriceUtil.getPercent(agentPrice, new BigDecimal(customersCommission.getAgentPercent() + ""));
                BigDecimal customerPrice = agentPrice.add(agentCommission);
                BigDecimal customerCommission = PriceUtil.getPercent(customerPrice, MobitopupUtil.getCustomerCommission(MobitopupUtil.isDigicel(country.getIso(), checkNumber.getNetworkid())));
                BigDecimal retailPrice = customerPrice.add(customerCommission);
                ticketList.add(ticket.split("-")[0] + "-" + retailPrice);
            }
            checkNumber.setTickets(StringUtils.join(ticketList, ","));
        }
        return checkNumber;
    }

    @Override
    public PinlessTransaction topupV2(String destnumber, String srcnumber, String product, String message, String login) {
        TCustomerUsers customerUser = customerUserService.findByLogin(login);
        TMasterCustomerinfo customer = customerUser.getCustomer();
        TMasterCustomerGroups group = customer.getGroup();

        Assert.isTrue(NumberUtils.isNumber(product), "Incorrect ticket.");
        if(customer.getCustomerBalance() <= 0 || customer.getCustomerBalance() < NumberUtils.toFloat(product)) {
            throw new IllegalArgumentException("Your balance is low. Please request a topup as soon as possible.");
        }

        CheckNumber checkNumber = mobitopupMethod.checkNumberV2(destnumber);
        if (checkNumber == null || !checkNumber.getError_code().equals(0)) {
            throw new IllegalArgumentException("Dest number - " + destnumber + " is not allowed for mobitopup.");
        }

        PhoneTopupCountry country = countryService.findByMobitopupCountryId(NumberUtils.toInt(checkNumber.getCountryid()));
        if (country == null) {
            log.info("The country - " + checkNumber.getCountry() + " is not found. " + "Country id - " + checkNumber.getCountryid());
            // by default is Great Britain
            country = countryService.findByIso("GB");
        }

        PinlessCustomerCommission customersCommission = pinlessCustomerCommissionService.findByCustomerId(group.getId(), customer.getId());
        Assert.notNull(customersCommission, "PinlessCustomerCommission not found. CustomerID - " + customer.getId());
        PinlessGroupCommission groupsCommission = customersCommission.getGroupCommission();

        Long transactionId = transactionService.getNextTransactionId();

        PinlessTransaction transaction = new PinlessTransaction();
        transaction.setDestinationPhone(destnumber);
        transaction.setRequesterPhone(srcnumber);
        transaction.setProductRequested(product);
        transaction.setCountry(country);
        transaction.setNetworkId(checkNumber.getNetworkid());
        transaction.setNetwork(checkNumber.getNetwork());
        transaction.setCurrency(checkNumber.getCurrency());
        transaction.setLocalCurrency(checkNumber.getLocalcurrency());
        transaction.setMessage(message);
        transaction.setCustomer(customer);
        transaction.setUser(customerUser.getUser());
        transaction.setTransactionId(transactionId);
        transaction.setTransactionTime(new Date());

        String key = System.currentTimeMillis() + "";
        transaction.setAuthKey(key);
        try {
            String respons = MobitopupUtil.sendRequest(MobitopupUtil.getTopupUrlV2(key, destnumber, srcnumber, product, message));
            Topup topup = MobitopupUtil.getJsonResponse(respons, Topup.class);
            if (topup != null) {
                transaction.setErrorCode(topup.getError_code());
                transaction.setErrorText(topup.getError_text());
                if (topup.getError_code().equals(0)) {
                    BigDecimal eezeetelPrice = new BigDecimal(topup.getPrice());
                    BigDecimal eezeetelCommission = PriceUtil.getPercent(eezeetelPrice, new BigDecimal(groupsCommission.getPercent() + ""));
                    BigDecimal groupPrice = eezeetelPrice.add(eezeetelCommission);
                    BigDecimal groupCommission = PriceUtil.getPercent(groupPrice, new BigDecimal(customersCommission.getGroupPercent() + ""));
                    BigDecimal agentPrice = groupPrice.add(groupCommission);
                    BigDecimal agentCommission = PriceUtil.getPercent(agentPrice, new BigDecimal(customersCommission.getAgentPercent() + ""));
                    BigDecimal customerPrice = agentPrice.add(agentCommission);
                    BigDecimal customerCommission = PriceUtil.getPercent(
                            customerPrice,
                            MobitopupUtil.getCustomerCommission(
                                    MobitopupUtil.isDigicel(country.getIso(), checkNumber.getNetworkid())
                            )
                    );
                    BigDecimal retailPrice = customerPrice.add(customerCommission);

                    transaction.setOrderId(topup.getOrder_id());
                    transaction.setBalance(new BigDecimal(topup.getBalance()));
                    transaction.setPrice(eezeetelPrice);
                    transaction.setEezeetelCommission(eezeetelCommission);
                    transaction.setGroupCommission(groupCommission);
                    transaction.setAgentCommission(agentCommission);
                    transaction.setCustomerCommission(customerCommission);
                    transaction.setRetailPrice(retailPrice);
                    transaction.setProductRequested(topup.getProduct_requested());
                    transaction.setProductSent(topup.getProduct_sent());
                    transaction.setSmsSent(topup.getSms_sent());
                    transaction.setSenderSms(topup.getSender_sms());
                    transaction.setPostProcessingStage(false);

                    transactionBalanceService.create(transactionId, customer.getCustomerBalance(), customer.getCustomerBalance() - customerPrice.floatValue());
                    customer.setCustomerBalance(customer.getCustomerBalance() - customerPrice.floatValue());

                    if (group.getCheckAganinstGroupBalance()) {
                        BigDecimal balanceBefore = new BigDecimal(group.getCustomerGroupBalance() + "");
                        BigDecimal balanceAfter = balanceBefore.subtract(groupPrice);

                        groupTransactionBalanceService.create(transactionId, balanceBefore, balanceAfter);

                        group.setCustomerGroupBalance(balanceAfter.floatValue());
                        groupService.save(group);
                    }
                }
                transaction.setTopup(MobitopupUtil.validate(topup));
            }
            transaction.setResponse(respons);
            transaction = pinlessTransactionRepository.save(transaction);

            customerService.save(customer);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return transaction;
    }
}
