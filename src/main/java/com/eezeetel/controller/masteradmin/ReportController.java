package com.eezeetel.controller.masteradmin;

import com.eezeetel.bean.ProductSalesByGroup;
import com.eezeetel.bean.ReportBean;
import com.eezeetel.bean.ResponseContainer;
import com.eezeetel.bean.masteradmin.BatchInfoBean;
import com.eezeetel.bean.report.*;
import com.eezeetel.entity.TMasterProductinfo;
import com.eezeetel.enums.TransactionType;
import com.eezeetel.service.*;
import com.eezeetel.util.DateUtil;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * Created by Denis Dulyak on 28.09.2015.
 */
@RestController
@RequestMapping("/masteradmin/report")
public class ReportController {

    @Autowired
    private ReportService reportService;

    @Autowired
    private ProductService productService;

    @Autowired
    private RevokedTransactionsService revokedTransactionsService;

    @Autowired
    private BatchService batchService;

    @Autowired
    private DingTransactionService dingTransactionService;

    @Autowired
    private MobitopupTransactionService mobitopupTransactionService;

    @RequestMapping(value = "/reconciliation", method = RequestMethod.GET)
    public List<ReportBean> reconciliation(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate from,
                                           @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate to,
                                           @RequestParam(defaultValue = "0") Integer supplierId) {
        return reportService.getStockReconciliationReport(from, to, supplierId);
    }

    @RequestMapping(value = "/product-sales-between-dates", method = RequestMethod.GET)
    public List<ReportBean> productCostPrice(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate from,
                                             @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate to,
                                             @RequestParam(defaultValue = "0") Integer supplierId) {
        return reportService.getSupplierSalesReport(DateUtil.getStartOfDay(from), DateUtil.getEndOfDay(to), supplierId);
    }

    @RequestMapping(value = "/by-sequence-id", method = RequestMethod.GET)
    public ReportBean reportBySequenceId(@RequestParam Integer id) {
        return reportService.getBatchReportBySequenceId(id);
    }

    @RequestMapping(value = "/product-sales-by-group", method = RequestMethod.GET)
    public List<ProductSalesByGroup> productSalesByGroup(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDay,
                                                         @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDay,
                                                         @RequestParam(defaultValue = "0") Integer supplierId) {
        return reportService.getProductSalesByGroup(supplierId, startDay, endDay);
    }

    @RequestMapping(value = "/products-by-supplier-id", method = RequestMethod.GET)
    public List<TMasterProductinfo> productsBySupplierId(@RequestParam Integer id) {
        return productService.findBySupplierId(id);
    }

    @RequestMapping(value = "/detail-sales-by-supplier-id", method = RequestMethod.GET)
    public List<DetailSales> detailSales(@RequestParam @DateTimeFormat(pattern = "MM/dd/yyyy") LocalDate from,
                                         @RequestParam @DateTimeFormat(pattern = "MM/dd/yyyy") LocalDate to,
                                         @RequestParam Integer supplierId,
                                         @RequestParam Integer productId) {
        return reportService.getProductsDetailSales(supplierId, productId, DateUtil.getStartOfDay(from), DateUtil.getEndOfDay(to));
    }

    @RequestMapping(value = "/detail-product-sales", method = RequestMethod.GET)
    public List<DetailSales> detailProductSales(@RequestParam @DateTimeFormat(pattern = "MM/dd/yyyy") LocalDate from,
                                                @RequestParam @DateTimeFormat(pattern = "MM/dd/yyyy") LocalDate to,
                                                @RequestParam Integer productId) {
        return reportService.getProductDetailSaleInfos(productId, DateUtil.getStartOfDay(from), DateUtil.getEndOfDay(to));
    }

    @RequestMapping(value = "/find-revoked-transactions", method = RequestMethod.GET)
    public ResponseContainer<List<RevokedTransaction>> revokedTransactions(@RequestParam @DateTimeFormat(pattern = "MM/dd/yyyy") LocalDate from,
                                                                           @RequestParam @DateTimeFormat(pattern = "MM/dd/yyyy") LocalDate to,
                                                                           @RequestParam(defaultValue = "1") Integer status,
                                                                           @RequestParam(defaultValue = "0") Integer page) {
        return revokedTransactionsService.getRevokedTransactions(page, DateUtil.getStartOfDay(from), DateUtil.getEndOfDay(to), status);
    }

    @RequestMapping(value = "/batch-info-by-product", method = RequestMethod.GET)
    public List<BatchInfoBean> productBatch(@RequestParam Integer productId,
                                            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate from,
                                            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate to) {
        return batchService.findByProductBetweenDates(productId, from, to);
    }

    @RequestMapping(value = "/daily-group-transactions", method = RequestMethod.GET)
    public List<BalanceReportBean> dailyGroupTransactions(@RequestParam(defaultValue = "0") Integer groupId,
                                                          @RequestParam String type,
                                                          @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date) {
        return reportService.dailyCustomersTransactions(groupId, date, type);
    }

    @RequestMapping(value = "/profit-report", method = RequestMethod.GET)
    public List<ProfitReportBean> profitReport(@RequestParam Integer type,
                                               @RequestParam Integer groupId,
                                               @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fromDate,
                                               @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate toDate) {
        return reportService.getProfitReport(TransactionType.values()[type], groupId, fromDate, toDate);
    }

    @RequestMapping(value = "/get-vat-by-month", method = RequestMethod.GET)
    public List<VATReportProcedure> vatByMonth(@RequestParam Integer groupId,
                                               @RequestParam Integer year, @RequestParam Integer month) {
        return reportService.getVatByMonthReport(groupId, year, month);
    }

    @RequestMapping(value = "/summary", method = RequestMethod.GET)
    public ResponseEntity<List<WorldMobileTopupSummary>> worldMobileTopupSummary(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDay,
                                                                                 @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDay,
                                                                                 @RequestParam(defaultValue = "0") Integer type) {
        return ResponseEntity.ok(type == 0 ?
                        dingTransactionService.getSummaryTransactions(startDay, endDay) :
                        mobitopupTransactionService.getSummaryTransactions(startDay, endDay)
        );
    }

    @RequestMapping(value = "/product-summary", method = RequestMethod.GET)
    public ResponseEntity<List<ProductSummaryReport>> productSummary(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDay,
                                                                     @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDay,
                                                                     @RequestParam Integer groupId) {
        return ResponseEntity.ok(reportService.getProductSummaryReport(groupId, startDay, endDay));
    }

    @RequestMapping(value = "/customer-balance-report", method = RequestMethod.GET)
    public ResponseEntity<List<CustomerBalanceReportBean>> customerBalanceReport(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDay,
                                                                                 @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDay,
                                                                                 @RequestParam Integer groupId) {
        return ResponseEntity.ok(reportService.getCustomerBalanceReport(groupId, startDay, endDay));
    }

    @RequestMapping(value = "/sales-return-report", method = RequestMethod.GET)
    public ResponseEntity<List<SalesReturn>> getSalesReturnReport(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDay,
                                                                  @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDay,
                                                                  @RequestParam Integer supplierId) {
        return ResponseEntity.ok(reportService.getSalesReturnReport(supplierId, startDay, endDay));
    }

    @RequestMapping(value = "/export-vat-by-month", method = RequestMethod.GET)
    public void exportVatByMonthReport(HttpServletResponse response, @RequestParam Integer groupId,
                                       @RequestParam Integer year, @RequestParam Integer month) throws IOException {
        response.setContentType("application/octet-stream");
        String fileName = String.format("VAT_%s_%s.xls", year, month);
        String headerValue = String.format("attachment; filename=\"%s\"", fileName);

        response.setHeader("Content-Disposition", headerValue);

        Workbook workbook = reportService.exportVatByMonthReport(groupId, year, month);
        workbook.write(response.getOutputStream());
    }
}
