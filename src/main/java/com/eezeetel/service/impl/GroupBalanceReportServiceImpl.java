package com.eezeetel.service.impl;

import com.eezeetel.entity.GroupBalanceReport;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.repository.GroupBalanceReportRepository;
import com.eezeetel.service.*;
import com.eezeetel.util.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.Optional;

/**
 * Created by Denis Dulyak on 18.01.2017.
 */
@Service
public class GroupBalanceReportServiceImpl implements GroupBalanceReportService {

    @Autowired
    private GroupBalanceReportRepository repository;

    @Autowired
    private GroupService service;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private DingTransactionService dingTransactionService;

    @Autowired
    private MobitopupTransactionService mobitopupTransactionService;

    @Autowired
    private MobileUnlockingOrderService mobileUnlockingOrderService;

    @Autowired
    private GroupCreditService groupCreditService;

    @Transactional(rollbackFor = Exception.class)
    @Override
    public void runDailyReport(LocalDate date) {
        List<TMasterCustomerGroups> groups = service.findAllActiveAndCheckAganinstGroupBalance();
        Date startOfDay = DateUtil.getStartOfDay(date);
        for (TMasterCustomerGroups group : groups) {
            repository.save(new GroupBalanceReport(group, startOfDay));
        }

        Date yesterdayStart = DateUtil.getStartOfDay(date.minusDays(1));
        Date yesterdayEnd = DateUtil.getEndOfDay(date.minusDays(1));
        List<GroupBalanceReport> yesterdayReports = repository.findByDay(yesterdayStart);
        for (GroupBalanceReport report : yesterdayReports) {
            Integer groupId = report.getGroup().getId();

            BigDecimal topup = groupCreditService.calcGroupCreditAmountBetweenDates(groupId, yesterdayStart, yesterdayEnd);
            report.setTopup(topup);

            BigDecimal cardsPrice = transactionService.calcGroupPriceBetweenDates(groupId, yesterdayStart, yesterdayEnd);
            BigDecimal dingPrice = dingTransactionService.calcGroupPriceBetweenDates(groupId, yesterdayStart, yesterdayEnd);
            BigDecimal mobitopupPrice = mobitopupTransactionService.calcGroupPriceBetweenDates(groupId, yesterdayStart, yesterdayEnd);
            BigDecimal ordersPrice = mobileUnlockingOrderService.calcGroupPriceBetweenDates(groupId, yesterdayStart, yesterdayEnd);
            report.setSales(cardsPrice.add(dingPrice).add(mobitopupPrice).add(ordersPrice));

            Integer cardTransactions = transactionService.countGroupTransactionsBetweenDates(groupId, yesterdayStart, yesterdayEnd);
            Integer dingTransactions = dingTransactionService.countGroupTransactionsBetweenDates(groupId, yesterdayStart, yesterdayEnd);
            Integer mobitopupTransactions = mobitopupTransactionService.countGroupTransactionsBetweenDates(groupId, yesterdayStart, yesterdayEnd);
            Integer muTransactions = mobileUnlockingOrderService.countGroupTransactionsBetweenDates(groupId, yesterdayStart, yesterdayEnd);
            report.setTransactions(cardTransactions + dingTransactions + mobitopupTransactions + muTransactions);

            Integer cardQuantity = transactionService.amountGroupTransactionsBetweenDates(groupId, yesterdayStart, yesterdayEnd);
            Integer muQuantity = mobileUnlockingOrderService.amountGroupTransactionsBetweenDates(groupId, yesterdayStart, yesterdayEnd);
            report.setQuantity(cardQuantity + dingTransactions + mobitopupTransactions + muQuantity);

            repository.save(report);
        }
    }

    @Override
    public List<GroupBalanceReport> findByDay(LocalDate day) {
        return repository.findByDay(DateUtil.getStartOfDay(day));
    }

    @Override
    public GroupBalanceReport findInListByGroupId(Integer groupId, List<GroupBalanceReport> reports) {
        Optional<GroupBalanceReport> optional = reports.stream().filter(r -> r.getGroup().getId().equals(groupId)).findFirst();
        return optional.isPresent() ? optional.get() : null;
    }

    @Override
    public BigDecimal calcToupByGroupAndBetweenDates(Integer groupId, Date startDate, Date endDate) {
        BigDecimal topup = repository.calcToupByGroupAndBetweenDates(groupId, startDate, endDate);
        return topup == null ? new BigDecimal("0") : topup;
    }

    @Override
    public BigDecimal calcSalesByGroupAndBetweenDates(Integer groupId, Date startDate, Date endDate) {
        BigDecimal sales = repository.calcSalesByGroupAndBetweenDates(groupId, startDate, endDate);
        return sales == null ? new BigDecimal("0") : sales;
    }

    @Override
    public Integer calcTransactionsByGroupAndBetweenDates(Integer groupId, Date startDate, Date endDate) {
        Integer transactions = repository.calcTransactionsByGroupAndBetweenDates(groupId, startDate, endDate);
        return transactions == null ? 0 : transactions;
    }

    @Override
    public Integer calcQuantityByGroupAndBetweenDates(Integer groupId, Date startDate, Date endDate) {
        Integer quantity = repository.calcQuantityByGroupAndBetweenDates(groupId, startDate, endDate);
        return quantity == null ? 0 : quantity;
    }
}
