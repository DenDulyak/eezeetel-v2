package com.eezeetel.service;

import com.eezeetel.entity.GroupBalanceReport;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Date;
import java.util.List;

@Service
public interface GroupBalanceReportService {

    void runDailyReport(LocalDate date);
    List<GroupBalanceReport> findByDay(LocalDate day);
    GroupBalanceReport findInListByGroupId(Integer groupId, List<GroupBalanceReport> reports);
    BigDecimal calcToupByGroupAndBetweenDates(Integer groupId, Date startDate, Date endDate);
    BigDecimal calcSalesByGroupAndBetweenDates(Integer groupId, Date startDate, Date endDate);
    Integer calcTransactionsByGroupAndBetweenDates(Integer groupId, Date startDate, Date endDate);
    Integer calcQuantityByGroupAndBetweenDates(Integer groupId, Date startDate, Date endDate);
}
