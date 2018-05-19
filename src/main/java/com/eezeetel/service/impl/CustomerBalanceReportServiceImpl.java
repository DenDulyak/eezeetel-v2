package com.eezeetel.service.impl;

import com.eezeetel.entity.CustomerBalanceReport;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.repository.CustomerBalanceReportRepository;
import com.eezeetel.service.*;
import com.eezeetel.util.DateUtil;
import lombok.NonNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Created by Denis Dulyak on 16.01.2017.
 */
@Service
public class CustomerBalanceReportServiceImpl implements CustomerBalanceReportService {

    @Autowired
    private CustomerBalanceReportRepository repository;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private CustomerCreditService customerCreditService;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private DingTransactionService dingTransactionService;

    @Autowired
    private MobitopupTransactionService mobitopupTransactionService;

    @Autowired
    private MobileUnlockingOrderService mobileUnlockingOrderService;

    @Transactional(rollbackFor = Exception.class)
    @Override
    public void runDailyReport(LocalDate date) {
        List<TMasterCustomerinfo> customers = customerService.findAll(true);
        Date startOfDay = DateUtil.getStartOfDay(date);
        for (TMasterCustomerinfo customer : customers) {
            repository.save(new CustomerBalanceReport(customer, startOfDay));
        }

        Date yesterdayStart = DateUtil.getStartOfDay(date.minusDays(1));
        Date yesterdayEnd = DateUtil.getEndOfDay(date.minusDays(1));
        List<CustomerBalanceReport> yesterdayReports = repository.findByDay(yesterdayStart);

        List<TMasterCustomerinfo> newCostomers = customers.stream()
                .filter(c -> yesterdayReports.stream().noneMatch(r -> Objects.equals(r.getCustomer().getId(), c.getId())))
                .collect(Collectors.toList());
        for(TMasterCustomerinfo customer: newCostomers) {
            yesterdayReports.add(new CustomerBalanceReport(customer, yesterdayStart));
        }

        for (CustomerBalanceReport report : yesterdayReports) {
            Integer customerId = report.getCustomer().getId();

            BigDecimal topup = customerCreditService.calcCustomerCreditAmountBetweenDates(customerId, yesterdayStart, yesterdayEnd);
            report.setTopup(topup);

            BigDecimal cardsPrice = transactionService.calcCustomerPriceBetweenDates(customerId, yesterdayStart, yesterdayEnd);
            BigDecimal dingPrice = dingTransactionService.calcCustomerPriceBetweenDates(customerId, yesterdayStart, yesterdayEnd);
            BigDecimal mobitopupPrice = mobitopupTransactionService.calcCustomerPriceBetweenDates(customerId, yesterdayStart, yesterdayEnd);
            BigDecimal ordersPrice = mobileUnlockingOrderService.calcCustomerPriceBetweenDates(customerId, yesterdayStart, yesterdayEnd);
            report.setSales(cardsPrice.add(dingPrice).add(mobitopupPrice).add(ordersPrice));

            Integer cardTransactions = transactionService.countCustomerTransactionsBetweenDates(customerId, yesterdayStart, yesterdayEnd);
            Integer dingTransactions = dingTransactionService.countCustomerTransactionsBetweenDates(customerId, yesterdayStart, yesterdayEnd);
            Integer mobitopupTransactions = mobitopupTransactionService.countCustomerTransactionsBetweenDates(customerId, yesterdayStart, yesterdayEnd);
            Integer muTransactions = mobileUnlockingOrderService.countCustomerTransactionsBetweenDates(customerId, yesterdayStart, yesterdayEnd);
            report.setTransactions(cardTransactions + dingTransactions + mobitopupTransactions + muTransactions);

            Integer cardQuantity = transactionService.amountCustomerTransactionsBetweenDates(customerId, yesterdayStart, yesterdayEnd);
            Integer muQuantity = mobileUnlockingOrderService.amountCustomerTransactionsBetweenDates(customerId, yesterdayStart, yesterdayEnd);
            report.setQuantity(cardQuantity + dingTransactions + mobitopupTransactions + muQuantity);

            repository.save(report);
        }
    }

    @Override
    public List<CustomerBalanceReport> findByGroupIdAndDay(@NonNull Integer groupId, LocalDate day) {
        return groupId == 0 ? repository.findByDay(DateUtil.getStartOfDay(day)) :
                repository.findByCustomerGroupIdAndDay(groupId, DateUtil.getStartOfDay(day));
    }

    @Override
    public CustomerBalanceReport findInListByCustomerId(Integer customerId, List<CustomerBalanceReport> reports) {
        Optional<CustomerBalanceReport> optional = reports.stream().filter(r -> r.getCustomer().getId().equals(customerId)).findFirst();
        return optional.isPresent() ? optional.get() : null;
    }
}
