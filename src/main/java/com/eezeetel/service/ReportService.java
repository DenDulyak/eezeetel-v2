package com.eezeetel.service;

import com.eezeetel.bean.ProductSalesByGroup;
import com.eezeetel.bean.ReportBean;
import com.eezeetel.bean.report.*;
import com.eezeetel.enums.TransactionType;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;

@Service
public interface ReportService {

    List<BalanceReportBean> dailyCustomersTransactions(Integer groupId, LocalDate day, String type);
    List<BalanceReportBean> monthlyCustomersTransactions(Integer groupId, LocalDate day, Integer monthsCount, String type);
    List<BalanceReportBean> dailyCustomersTransactionsByUsername(String username, Integer groupId, LocalDate day, String type);
    List<BalanceReportBean> monthlyCustomersTransactionsByUsername(String username, Integer groupId, LocalDate day, Integer monthsCount, String type);
    List<ProfitReportBean> getProfitReport(TransactionType type, Integer groupId, LocalDate fromDate, LocalDate toDate);
    List<ProfitReportBean> getProfitReport(TransactionType type, Integer groupId, Integer customerId, LocalDate fromDate, LocalDate toDate);
    List<ProfitReportBean> getVatReport(TransactionType type, Integer groupId, Integer customerId, LocalDate fromDate, LocalDate toDate);
    List<VATReportProcedure> getVatByMonthReport(Integer groupId, Integer year, Integer month);
    List<ProductSummaryReport> getProductSummaryReport(Integer groupId, LocalDate startDate, LocalDate endDate);
    List<CustomerBalanceReportBean> getCustomerBalanceReport(Integer groupId, LocalDate startDate, LocalDate endDate);
    Workbook exportVatByMonthReport(Integer groupId, Integer year, Integer month);
    String generateCustomerCommissionsReport(Integer customerId, LocalDate date);
    List<DetailSales> getProductDetailSaleInfos(Integer productId, Date from, Date to);
    List<ReportBean> getStockReconciliationReport(LocalDate startDate, LocalDate endDate, Integer supplierId);
    List<ReportBean> getSupplierSalesReport(Date from, Date to, Integer supplierId);
    ReportBean getBatchReportBySequenceId(Integer sequenceId);
    List<ProductSalesByGroup> getProductSalesByGroup(Integer supplierId, LocalDate startDate, LocalDate endDate);
    List<DetailSales> getProductsDetailSales(Integer supplierId, Integer productId, Date from, Date to);
    List<SalesReturn> getSalesReturnReport(Integer supplierId, LocalDate startDate, LocalDate endDate);
}
