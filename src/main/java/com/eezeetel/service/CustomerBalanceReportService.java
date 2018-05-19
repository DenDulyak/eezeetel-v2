package com.eezeetel.service;

import com.eezeetel.entity.CustomerBalanceReport;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public interface CustomerBalanceReportService {

    void runDailyReport(LocalDate date);
    List<CustomerBalanceReport> findByGroupIdAndDay(Integer groupId, LocalDate day);
    CustomerBalanceReport findInListByCustomerId(Integer customerId, List<CustomerBalanceReport> reports);
}
