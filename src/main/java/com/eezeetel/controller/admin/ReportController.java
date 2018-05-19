package com.eezeetel.controller.admin;

import com.eezeetel.bean.report.BalanceReportBean;
import com.eezeetel.bean.report.CustomerBalanceReportBean;
import com.eezeetel.bean.report.ProfitReportBean;
import com.eezeetel.enums.TransactionType;
import com.eezeetel.service.ReportService;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;

/**
 * Created by Denis Dulyak on 19.09.2016.
 */
@RestController("adminReportController")
@RequestMapping("/admin/report")
public class ReportController {

    @Autowired
    private ReportService reportService;

    @RequestMapping(value = "/daily-customers-transactions", method = RequestMethod.GET)
    public List<BalanceReportBean> dailyCustomersTransactions(HttpSession session, @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date) {
        System.out.println("=====================>" + session.getAttribute("GROUP_ID"));
        return reportService.dailyCustomersTransactions(NumberUtils.toInt(session.getAttribute("GROUP_ID") + ""), date, "all");
    }

    @RequestMapping(value = "/profit-report", method = RequestMethod.GET)
    public List<ProfitReportBean> profitReport(HttpSession session, @RequestParam(defaultValue = "0") Integer customerId,
                                               @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fromDate,
                                               @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate toDate) {
        return reportService.getProfitReport(TransactionType.TRANSACTION, NumberUtils.toInt(session.getAttribute("GROUP_ID") + ""), customerId, fromDate, toDate);
    }

    @RequestMapping(value = "/profit-report-mobile-topup", method = RequestMethod.GET)
    public List<ProfitReportBean> profitReportMobileTopup(HttpSession session, @RequestParam(defaultValue = "0") Integer customerId,
                                                          @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fromDate,
                                                          @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate toDate) {
        return reportService.getProfitReport(TransactionType.WORLD_MOBILE_TOP_UP, NumberUtils.toInt(session.getAttribute("GROUP_ID") + ""), customerId, fromDate, toDate);
    }

    @RequestMapping(value = "/profit-report-mobile-unlocking", method = RequestMethod.GET)
    public List<ProfitReportBean> profitReportMobileUnlocking(HttpSession session, @RequestParam(defaultValue = "0") Integer customerId,
                                                              @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fromDate,
                                                              @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate toDate) {
        return reportService.getProfitReport(TransactionType.MOBILE_UNLOCKING, NumberUtils.toInt(session.getAttribute("GROUP_ID") + ""), customerId, fromDate, toDate);
    }

    @RequestMapping(value = "/vat-report", method = RequestMethod.GET)
    public List<ProfitReportBean> vatReport(HttpSession session, @RequestParam(defaultValue = "0") Integer customerId,
                                            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fromDate,
                                            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate toDate) {
        return reportService.getVatReport(TransactionType.TRANSACTION, NumberUtils.toInt(session.getAttribute("GROUP_ID") + ""), customerId, fromDate, toDate);
    }

    @RequestMapping(value = "/customer-balance-report", method = RequestMethod.GET)
    public ResponseEntity<List<CustomerBalanceReportBean>> customerBalanceReport(HttpSession session,
                                                                                 @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDay,
                                                                                 @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDay) {
        return ResponseEntity.ok(reportService.getCustomerBalanceReport(NumberUtils.toInt(session.getAttribute("GROUP_ID") + ""), startDay, endDay));
    }

    @RequestMapping(value = "/customer-commissions-report", method = RequestMethod.GET)
    public ResponseEntity<String> customerCommissionsReport(@RequestParam Integer customerId,
                                                            @RequestParam @DateTimeFormat(pattern = "dd-MM-yyyy") LocalDate date) {
        return ResponseEntity.ok(reportService.generateCustomerCommissionsReport(customerId, date));
    }
}
