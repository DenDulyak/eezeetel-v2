package com.eezeetel.service.impl;

import com.commons.GenerateOldInvoices;
import com.eezeetel.bean.ProductSalesByGroup;
import com.eezeetel.bean.ReportBean;
import com.eezeetel.bean.products.ProductSaleInfo;
import com.eezeetel.bean.report.*;
import com.eezeetel.entity.*;
import com.eezeetel.enums.SettingType;
import com.eezeetel.enums.TransactionStatus;
import com.eezeetel.enums.TransactionType;
import com.eezeetel.repository.BatchRepository;
import com.eezeetel.repository.TransactionRepository;
import com.eezeetel.repository.custom.ReportRepository;
import com.eezeetel.service.*;
import com.eezeetel.util.AuthenticationUtils;
import com.eezeetel.util.DateUtil;
import com.eezeetel.util.HibernateUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.transform.Transformers;
import org.hibernate.type.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Created by Denis Dulyak on 29.09.2015.
 */
@Service
public class ReportServiceImpl implements ReportService {

    @Autowired
    private ReportRepository repository;

    @Autowired
    private ProductService productService;

    @Autowired
    private BatchRepository batchRepository;

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private DingTransactionService dingTransactionService;

    @Autowired
    private MobitopupTransactionService mobitopupTransactionService;

    @Autowired
    private PinlessTransactionService pinlessTransactionService;

    @Autowired
    private MobileUnlockingOrderService mobileUnlockingOrderService;

    @Autowired
    private SettingService settingService;

    @Autowired
    private SupplierService supplierService;

    @Autowired
    private ProductTypeService productTypeService;

    @Autowired
    private GroupBalanceReportService groupBalanceReportService;

    @Autowired
    private CustomerBalanceReportService customerBalanceReportService;

    @Override
    public List<BalanceReportBean> dailyCustomersTransactions(Integer groupId, LocalDate day, String type) {
        List<BalanceReportBean> transactions = new ArrayList<>();
        if (day == null) {
            day = LocalDate.now();
        }

        TMasterCustomerGroups group = new TMasterCustomerGroups(groupId);
        Date startDate = DateUtil.getStartOfDay(day);
        Date endDate = DateUtil.getEndOfDay(day);

        if (type.equals("all") || type.equals("card")) {
            transactionService.findByGroupAndDate(
                    TransactionStatus.COMMITTED,
                    group,
                    startDate,
                    endDate
            ).forEach(t -> transactions.add(BalanceReportBean.toBean(t)));

            if (LocalDate.now().minusDays(7).isAfter(day)) {
                transactionService.findByGroupAndDateFromHistory(
                        TransactionStatus.COMMITTED,
                        group.getId(),
                        startDate,
                        endDate
                ).forEach(t -> transactions.add(BalanceReportBean.toBean(t)));
            }
        }

        if (type.equals("all") || type.equals("ding")) {
            dingTransactionService.findByGroupAndDate(
                    1,
                    group,
                    startDate,
                    endDate
            ).forEach(d -> transactions.add(BalanceReportBean.toBean(d)));
        }

        if (type.equals("all") || type.equals("mobitopup")) {
            List<MobitopupTransaction> mTransactions = mobitopupTransactionService.findByGroupAndDate(
                    0, group, startDate, endDate);
            mTransactions.forEach(m -> transactions.add(BalanceReportBean.toBean(m)));
        }

        if (type.equals("all") || type.equals("pinless")) {
            List<PinlessTransaction> pTransactions = pinlessTransactionService.findByGroupAndDate(
                    0, group, startDate, endDate);
            pTransactions.forEach(p -> transactions.add(BalanceReportBean.toBean(p)));
        }

        if (type.equals("all") || type.equals("mobileUnlockin")) {
            mobileUnlockingOrderService.findByGroupAndDate(
                    group,
                    startDate,
                    endDate
            ).forEach(o -> transactions.add(BalanceReportBean.toBean(o)));
        }

        transactions.sort((t1, t2) -> t1.getTransactionId().compareTo(t2.getTransactionId()));

        List<BalanceReportBean> result = new ArrayList<>();

        transactions.forEach(t -> {
            if (result.contains(t)) {
                t.setTransactionId(null);
                t.setTransactionTime(null);
                t.setGroupBalanceBefore(null);
                t.setGroupBalanceAfter(null);
                t.setBalanceBefore(null);
                t.setBalanceAfter(null);
                t.setCustomer(null);
            }
            result.add(t);
        });

        return result;
    }

    @Override
    public List<BalanceReportBean> monthlyCustomersTransactions(Integer groupId,
                                                                LocalDate day,
                                                                Integer monthsCount,
                                                                String type) {
        List<BalanceReportBean> transactions = new ArrayList<>();
        if (day == null) {
            day = LocalDate.now();
        }

        TMasterCustomerGroups group = new TMasterCustomerGroups(groupId);
        Date startDate = Date.from(day.minusMonths(monthsCount).atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date endDate = DateUtil.getEndOfDay(day);
        System.out.println("  ===Start => " + startDate.toString());
        System.out.println("  ===End => " + endDate.toString());
        if (type.equals("all") || type.equals("card")) {
            transactionService.findByGroupAndDate(
                    TransactionStatus.COMMITTED,
                    group,
                    startDate,
                    endDate
            ).forEach(t -> transactions.add(BalanceReportBean.toBean(t)));

            if (LocalDate.now().minusDays(7).isAfter(day)) {
                transactionService.findByGroupAndDateFromHistory(
                        TransactionStatus.COMMITTED,
                        group.getId(),
                        startDate,
                        endDate
                ).forEach(t -> transactions.add(BalanceReportBean.toBean(t)));
            }
        }

        if (type.equals("all") || type.equals("ding")) {
            dingTransactionService.findByGroupAndDate(
                    1,
                    group,
                    startDate,
                    endDate
            ).forEach(d -> transactions.add(BalanceReportBean.toBean(d)));
        }

        if (type.equals("all") || type.equals("mobitopup")) {
            List<MobitopupTransaction> mTransactions = mobitopupTransactionService.findByGroupAndDate(
                    0, group, startDate, endDate);
            mTransactions.forEach(m -> transactions.add(BalanceReportBean.toBean(m)));
        }

        if (type.equals("all") || type.equals("pinless")) {
            List<PinlessTransaction> pTransactions = pinlessTransactionService.findByGroupAndDate(
                    0, group, startDate, endDate);
            pTransactions.forEach(p -> transactions.add(BalanceReportBean.toBean(p)));
        }

        if (type.equals("all") || type.equals("mobileUnlockin")) {
            mobileUnlockingOrderService.findByGroupAndDate(
                    group,
                    startDate,
                    endDate
            ).forEach(o -> transactions.add(BalanceReportBean.toBean(o)));
        }

        transactions.sort((t1, t2) -> t1.getTransactionId().compareTo(t2.getTransactionId()));

        List<BalanceReportBean> result = new ArrayList<>();

        transactions.forEach(t -> {
            if (result.contains(t)) {
                t.setTransactionId(null);
                t.setTransactionTime(null);
                t.setGroupBalanceBefore(null);
                t.setGroupBalanceAfter(null);
                t.setBalanceBefore(null);
                t.setBalanceAfter(null);
                t.setCustomer(null);
            }
            result.add(t);
        });

        return result;
    }

    @Override
    public List<BalanceReportBean> dailyCustomersTransactionsByUsername(String username, Integer groupId, LocalDate day, String type) {
        List<BalanceReportBean> transactions = new ArrayList<>();
        if (day == null) {
            day = LocalDate.now();
        }

        TMasterCustomerGroups group = new TMasterCustomerGroups(groupId);
        Date startDate = DateUtil.getStartOfDay(day);
        Date endDate = DateUtil.getEndOfDay(day);

        if (type.equals("all") || type.equals("card")) {
            transactionService.findByGroupAndDate(
                    TransactionStatus.COMMITTED,
                    group,
                    startDate,
                    endDate
            ).forEach(t -> transactions.add(BalanceReportBean.toBean(t)));

            if (LocalDate.now().minusDays(7).isAfter(day)) {
                transactionService.findByGroupAndDateFromHistory(
                        TransactionStatus.COMMITTED,
                        group.getId(),
                        startDate,
                        endDate
                ).forEach(t -> transactions.add(BalanceReportBean.toBean(t)));
            }
        }

        if (type.equals("all") || type.equals("ding")) {
            dingTransactionService.findByGroupAndDate(
                    1,
                    group,
                    startDate,
                    endDate
            ).forEach(d -> transactions.add(BalanceReportBean.toBean(d)));
        }

        if (type.equals("all") || type.equals("mobitopup")) {
            List<MobitopupTransaction> mTransactions = mobitopupTransactionService.findByGroupAndDate(
                    0, group, startDate, endDate);
            mTransactions.forEach(m -> transactions.add(BalanceReportBean.toBean(m)));
        }

        if (type.equals("all") || type.equals("pinless")) {
            List<PinlessTransaction> pTransactions = pinlessTransactionService.findByGroupAndDate(
                    0, group, startDate, endDate);
            pTransactions.forEach(p -> transactions.add(BalanceReportBean.toBean(p)));
        }

        if (type.equals("all") || type.equals("mobileUnlockin")) {
            mobileUnlockingOrderService.findByGroupAndDate(
                    group,
                    startDate,
                    endDate
            ).forEach(o -> transactions.add(BalanceReportBean.toBean(o)));
        }

        transactions.sort((t1, t2) -> t1.getTransactionId().compareTo(t2.getTransactionId()));

        List<BalanceReportBean> result = new ArrayList<>();

        transactions.forEach(t -> {
            if (result.contains(t)) {
                t.setTransactionId(null);
                t.setTransactionTime(null);
                t.setGroupBalanceBefore(null);
                t.setGroupBalanceAfter(null);
                t.setBalanceBefore(null);
                t.setBalanceAfter(null);
                t.setCustomer(null);
            }
            result.add(t);
        });

        return result;
    }

    @Override
    public List<BalanceReportBean> monthlyCustomersTransactionsByUsername(String username, Integer groupId, LocalDate day, Integer monthsCount, String type) {
        List<BalanceReportBean> transactions = new ArrayList<>();
        if (day == null) {
            day = LocalDate.now();
        }

        TMasterCustomerGroups group = new TMasterCustomerGroups(groupId);
        Date startDate = Date.from(day.minusMonths(monthsCount).atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date endDate = DateUtil.getEndOfDay(day);

        if (type.equals("all") || type.equals("card")) {
            transactionService.findByGroupAndDate(
                    TransactionStatus.COMMITTED,
                    group,
                    startDate,
                    endDate
            ).forEach(t -> transactions.add(BalanceReportBean.toBean(t)));

            if (LocalDate.now().minusDays(7).isAfter(day)) {
                transactionService.findByGroupAndDateFromHistory(
                        TransactionStatus.COMMITTED,
                        group.getId(),
                        startDate,
                        endDate
                ).forEach(t -> transactions.add(BalanceReportBean.toBean(t)));
            }
        }

        if (type.equals("all") || type.equals("ding")) {
            dingTransactionService.findByGroupAndDate(
                    1,
                    group,
                    startDate,
                    endDate
            ).forEach(d -> transactions.add(BalanceReportBean.toBean(d)));
        }

        if (type.equals("all") || type.equals("mobitopup")) {
            List<MobitopupTransaction> mTransactions = mobitopupTransactionService.findByGroupAndDate(
                    0, group, startDate, endDate);
            mTransactions.forEach(m -> transactions.add(BalanceReportBean.toBean(m)));
        }

        if (type.equals("all") || type.equals("pinless")) {
            List<PinlessTransaction> pTransactions = pinlessTransactionService.findByGroupAndDate(
                    0, group, startDate, endDate);
            pTransactions.forEach(p -> transactions.add(BalanceReportBean.toBean(p)));
        }

        if (type.equals("all") || type.equals("mobileUnlockin")) {
            mobileUnlockingOrderService.findByGroupAndDate(
                    group,
                    startDate,
                    endDate
            ).forEach(o -> transactions.add(BalanceReportBean.toBean(o)));
        }

        transactions.sort((t1, t2) -> t1.getTransactionId().compareTo(t2.getTransactionId()));

        List<BalanceReportBean> result = new ArrayList<>();

        transactions.forEach(t -> {
            if (result.contains(t)) {
                t.setTransactionId(null);
                t.setTransactionTime(null);
                t.setGroupBalanceBefore(null);
                t.setGroupBalanceAfter(null);
                t.setBalanceBefore(null);
                t.setBalanceAfter(null);
                t.setCustomer(null);
            }
            result.add(t);
        });

        return result;
    }

    @Override
    public List<ProfitReportBean> getProfitReport(TransactionType type, Integer groupId, LocalDate fromDate, LocalDate toDate) {
        return getProfitReport(type, groupId, 0, fromDate, toDate);
    }

    @Override
    public List<ProfitReportBean> getProfitReport(TransactionType type, Integer groupId, Integer customerId, LocalDate fromDate, LocalDate toDate) {
        List<ProfitReportBean> result = Collections.emptyList();

        switch (type) {
            case TRANSACTION:
                result = getProfitReport(groupId, customerId, fromDate, toDate);
                if (groupId != 1 && !AuthenticationUtils.isMasterAdmin()) {
                    result.forEach(t -> {
                        t.setCostPrice(t.getGroupPrice().divide(new BigDecimal(t.getQuantity()), BigDecimal.ROUND_HALF_EVEN));
                    });
                }
                break;
            case WORLD_MOBILE_TOP_UP:
                result = getProfitReportForMobileTopup(groupId, customerId, fromDate, toDate);
                break;
            case MOBILE_UNLOCKING:
                result = getProfitReportForMobileUnlocking(groupId, customerId, fromDate, toDate);
                break;
        }

        result.sort((r1, r2) -> r1.getCustomer().compareTo(r2.getCustomer()));

        return result;
    }

    @Override
    public List<ProfitReportBean> getVatReport(TransactionType type, Integer groupId, Integer customerId, LocalDate fromDate, LocalDate toDate) {
        return getVatReport(groupId, customerId, fromDate, toDate);
    }

    @Override
    public List<VATReportProcedure> getVatByMonthReport(Integer groupId, Integer year, Integer month) {
        List<VATReportProcedure> result = new ArrayList<>();
        LocalDate date = LocalDate.of(year, month, 1);

        Session session = null;
        try {
            session = HibernateUtil.openSession();
            String strQuery = "call SP_VAT_Report('" + date.toString() + "', :groupId)";

            SQLQuery sqlQuery = session.createSQLQuery(strQuery);
            sqlQuery.addScalar("saleType", new IntegerType());
            sqlQuery.addScalar("group", new StringType());
            sqlQuery.addScalar("customer", new StringType());
            sqlQuery.addScalar("netSales", new BigDecimalType());
            sqlQuery.addScalar("vat", new BigDecimalType());
            sqlQuery.addScalar("totalSales", new BigDecimalType());
            sqlQuery.addScalar("profit", new BigDecimalType());
            sqlQuery.addScalar("vatOnProfit", new BigDecimalType());

            sqlQuery.setParameter("groupId", groupId);
            sqlQuery.setResultTransformer(Transformers.aliasToBean(VATReportProcedure.class));

            result = (List<VATReportProcedure>) sqlQuery.list();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }

        return result;
    }

    @Override
    public List<ProductSummaryReport> getProductSummaryReport(Integer groupId, LocalDate startDate, LocalDate endDate) {
        List<ProductSummaryReport> result = Collections.emptyList();

        Session session = null;
        try {
            session = HibernateUtil.openSession();
            String strQuery = "SELECT productId, SUM(transactions) AS transactions, SUM(totalCardsSold) AS totalCardsSold, ROUND(SUM(totalSalePrice), 2) AS totalSalePrice FROM ( " +
                    "( SELECT " +
                    "    tt.Product_ID as productId, " +
                    "    COUNT(DISTINCT tt.Transaction_ID) AS transactions, " +
                    "    SUM(tt.Quantity) AS totalCardsSold, " +
                    "    ROUND(SUM(tt.Unit_Purchase_Price), 2) AS totalSalePrice " +
                    "FROM " +
                    "    t_transactions tt, " +
                    "    t_master_customerinfo c " + (groupId == 0 ? ", t_master_customer_groups g " : "") +
                    "WHERE " +
                    "    tt.Committed = 1 " +
                    "        AND tt.Transaction_Time BETWEEN :startDate AND :endDate " +
                    "        AND tt.Customer_ID = c.Customer_ID " +
                    "        AND c.Customer_Group_ID = " + (groupId == 0 ? "g.Customer_Group_ID " : " :groupId ") +
                    "GROUP BY tt.Product_ID ) ";

            if (LocalDate.now().minusDays(7).isAfter(startDate)) {
                strQuery += "union " +
                        "( SELECT " +
                        "    tht.Product_ID as productId, " +
                        "    COUNT(DISTINCT tht.Transaction_ID) AS transactions, " +
                        "    SUM(tht.Quantity) AS totalCardsSold, " +
                        "    ROUND(SUM(tht.Unit_Purchase_Price), 2) AS totalSalePrice " +
                        "FROM " +
                        "    t_history_transactions tht, " +
                        "    t_master_customerinfo c " + (groupId == 0 ? ", t_master_customer_groups g " : "") +
                        "WHERE " +
                        "    tht.Committed = 1 " +
                        "        AND tht.Transaction_Time BETWEEN :startDate AND :endDate " +
                        "        AND tht.Customer_ID = c.Customer_ID " +
                        "        AND c.Customer_Group_ID = " + (groupId == 0 ? "g.Customer_Group_ID " : " :groupId ") +
                        "GROUP BY tht.Product_ID ) ";
            }

            if (LocalDate.of(2013, 5, 31).isAfter(startDate)) {
                strQuery += "union " +
                        "( SELECT " +
                        "    tht.Product_ID as productId, " +
                        "    COUNT(DISTINCT tht.Transaction_ID) AS transactions, " +
                        "    SUM(tht.Quantity) AS totalCardsSold, " +
                        "    ROUND(SUM(tht.Unit_Purchase_Price), 2) AS totalSalePrice " +
                        "FROM " +
                        "    t_history_transactions_2010_05_31__2013_01_01 tht, " +
                        "    t_master_customerinfo c " + (groupId == 0 ? ", t_master_customer_groups g " : "") +
                        "WHERE " +
                        "    tht.Committed = 1 " +
                        "        AND tht.Transaction_Time BETWEEN :startDate AND :endDate " +
                        "        AND tht.Customer_ID = c.Customer_ID " +
                        "        AND c.Customer_Group_ID = " + (groupId == 0 ? "g.Customer_Group_ID " : " :groupId ") +
                        "GROUP BY tht.Product_ID ) ";
            }

            strQuery += ") x GROUP BY productId";

            SQLQuery sqlQuery = session.createSQLQuery(strQuery);

            sqlQuery.addScalar("productId", new IntegerType());
            sqlQuery.addScalar("transactions", new IntegerType());
            sqlQuery.addScalar("totalCardsSold", new IntegerType());
            sqlQuery.addScalar("totalSalePrice", new BigDecimalType());

            if (groupId != 0) {
                sqlQuery.setParameter("groupId", groupId);
            }
            sqlQuery.setParameter("startDate", DateUtil.getStartOfDay(startDate));
            sqlQuery.setParameter("endDate", DateUtil.getEndOfDay(endDate));
            sqlQuery.setResultTransformer(Transformers.aliasToBean(ProductSummaryReport.class));

            result = (List<ProductSummaryReport>) sqlQuery.list();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }

        if (result != null && !result.isEmpty()) {
            List<TMasterProductinfo> products = productService.findAll();
            for (ProductSummaryReport report : result) {
                TMasterProductinfo product = productService.findByIdFromList(report.getProductId(), products);
                if (product != null) {
                    report.setProductName(product.getProductName());
                    report.setFaceValue(product.getProductFaceValue());
                    if (product.getCostPrice() != null) {
                        report.setTotalCostPrice(
                                product.getCostPrice().multiply(new BigDecimal(report.getTotalCardsSold()))
                        );
                    }
                }
            }

            result.sort((p1, p2) -> p1.getProductName().compareTo(p2.getProductName()));
        }

        return result;
    }

    @Override
    public List<CustomerBalanceReportBean> getCustomerBalanceReport(Integer groupId, LocalDate startDate, LocalDate endDate) {
        List<CustomerBalanceReportBean> beans = groupId == 0 ?
                repository.getCustomerBalanceReport(startDate, endDate) :
                repository.getCustomerBalanceReportByGroupId(groupId, startDate, endDate);

        List<CustomerBalanceReport> startDayReports = customerBalanceReportService.findByGroupIdAndDay(groupId, startDate);
        List<CustomerBalanceReport> endDayReports = customerBalanceReportService.findByGroupIdAndDay(groupId, endDate.plusDays(1));
        beans.forEach(b -> {
            CustomerBalanceReport startDayReport = customerBalanceReportService.findInListByCustomerId(b.getCustomerId(), startDayReports);
            CustomerBalanceReport endDayReport = customerBalanceReportService.findInListByCustomerId(b.getCustomerId(), endDayReports);
            b.setBalanceBefore(startDayReport != null ? startDayReport.getBalance() : new BigDecimal("0"));
            b.setBalanceAfter(endDayReport != null ? endDayReport.getBalance() : new BigDecimal("0"));
        });

        beans.sort((b1, b2) -> b1.getCustomerName().compareTo(b2.getCustomerName()));

        if (groupId == 0 && AuthenticationUtils.isMasterAdmin()) {
            List<GroupBalanceReport> startDayGroupReports = groupBalanceReportService.findByDay(startDate);
            List<GroupBalanceReport> endDayGroupReports = groupBalanceReportService.findByDay(endDate.plusDays(1));
            for (GroupBalanceReport report : startDayGroupReports) {
                CustomerBalanceReportBean bean = new CustomerBalanceReportBean();
                Integer rGroupId = report.getGroup().getId();
                Date start = DateUtil.getStartOfDay(startDate);
                Date end = DateUtil.getEndOfDay(endDate);

                bean.setCustomerId(report.getGroup().getId());
                bean.setCustomerName(report.getGroup().getName());
                bean.setBalanceBefore(report.getBalance());
                bean.setTopup(groupBalanceReportService.calcToupByGroupAndBetweenDates(rGroupId, start, end));
                bean.setSales(groupBalanceReportService.calcSalesByGroupAndBetweenDates(rGroupId, start, end));
                bean.setTransactions(groupBalanceReportService.calcTransactionsByGroupAndBetweenDates(rGroupId, start, end));
                bean.setQuantity(groupBalanceReportService.calcQuantityByGroupAndBetweenDates(rGroupId, start, end));

                GroupBalanceReport endDayGroupReport = groupBalanceReportService.findInListByGroupId(report.getGroup().getId(), endDayGroupReports);
                bean.setBalanceAfter(endDayGroupReport != null ? endDayGroupReport.getBalance() : new BigDecimal("0"));
                beans.add(bean);
            }
        }

        return beans;
    }

    @Override
    public Workbook exportVatByMonthReport(Integer groupId, Integer year, Integer month) {
        Workbook wb = new HSSFWorkbook();

        List<VATReportProcedure> data = this.getVatByMonthReport(groupId, year, month);
        List<VATReportProcedure> vat = new ArrayList<>();
        List<VATReportProcedure> noVat = new ArrayList<>();
        List<VATReportProcedure> local = new ArrayList<>();
        List<VATReportProcedure> ding = new ArrayList<>();

        data.forEach(d -> {
            switch (d.getSaleType()) {
                case 0:
                    vat.add(d);
                    break;
                case 1:
                    noVat.add(d);
                    break;
                case 2:
                    local.add(d);
                    break;
                case 3:
                    ding.add(d);
                    break;
            }
        });

        CellStyle style = wb.createCellStyle();
        Font font = wb.createFont();
        font.setFontHeightInPoints((short) 12);
        font.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
        style.setFont(font);

        int rowNumber = 0;
        Sheet sheet = wb.createSheet("new sheet");
        sheet.setColumnWidth(0, 12000);
        sheet.setColumnWidth(1, 5000);
        sheet.setColumnWidth(2, 5000);
        sheet.setColumnWidth(3, 5000);
        Row title = sheet.createRow(rowNumber++);
        title.setRowStyle(style);
        Cell cell = title.createCell(0);
        cell.setCellValue("Customer");
        cell.setCellStyle(style);
        Cell cell1 = title.createCell(1);
        cell1.setCellValue("Net Sales");
        cell1.setCellStyle(style);
        Cell cell2 = title.createCell(2);
        cell2.setCellValue("Vat");
        cell2.setCellStyle(style);
        Cell cell3 = title.createCell(3);
        cell3.setCellValue("Total Sales");
        cell3.setCellStyle(style);

        BigDecimal allNetSales = new BigDecimal("0");
        BigDecimal allVatSales = new BigDecimal("0");
        BigDecimal allTotalSales = new BigDecimal("0");

        if (!vat.isEmpty()) {
            sheet.createRow(rowNumber++);
            Row rowProduct = sheet.createRow(rowNumber++);
            Cell cellProduct = rowProduct.createCell(0);
            cellProduct.setCellStyle(style);
            cellProduct.setCellValue("VAT Product");
            BigDecimal netSales = new BigDecimal("0");
            BigDecimal vatSales = new BigDecimal("0");
            BigDecimal totalSales = new BigDecimal("0");
            for (VATReportProcedure r : vat) {
                Row row = sheet.createRow(rowNumber++);
                row.createCell(0).setCellValue(r.getCustomer());
                row.createCell(1).setCellValue(r.getNetSales().doubleValue());
                row.createCell(2).setCellValue(r.getVat().doubleValue());
                row.createCell(3).setCellValue(r.getTotalSales().doubleValue());
                netSales = netSales.add(r.getNetSales());
                vatSales = vatSales.add(r.getVat());
                totalSales = totalSales.add(r.getTotalSales());
            }
            Row rowTotal = sheet.createRow(rowNumber++);
            Cell totalCell = rowTotal.createCell(0);
            totalCell.setCellStyle(style);
            totalCell.setCellValue("Totals");
            Cell totalCell1 = rowTotal.createCell(1);
            totalCell1.setCellStyle(style);
            totalCell1.setCellValue(netSales.doubleValue());
            Cell totalCell2 = rowTotal.createCell(2);
            totalCell2.setCellStyle(style);
            totalCell2.setCellValue(vatSales.doubleValue());
            Cell totalCell3 = rowTotal.createCell(3);
            totalCell3.setCellStyle(style);
            totalCell3.setCellValue(totalSales.doubleValue());

            allNetSales = allNetSales.add(netSales);
            allVatSales = allVatSales.add(vatSales);
            allTotalSales = allTotalSales.add(totalSales);
        }

        if (!noVat.isEmpty()) {
            sheet.createRow(rowNumber++);
            Row rowProduct = sheet.createRow(rowNumber++);
            Cell cellProduct = rowProduct.createCell(0);
            cellProduct.setCellStyle(style);
            cellProduct.setCellValue("Non VAT Product");
            BigDecimal netSales = new BigDecimal("0");
            BigDecimal vatSales = new BigDecimal("0");
            BigDecimal totalSales = new BigDecimal("0");
            for (VATReportProcedure r : noVat) {
                Row row = sheet.createRow(rowNumber++);
                row.createCell(0).setCellValue(r.getCustomer());
                row.createCell(1).setCellValue(r.getNetSales().doubleValue());
                row.createCell(2).setCellValue(r.getVat().doubleValue());
                row.createCell(3).setCellValue(r.getTotalSales().doubleValue());
                netSales = netSales.add(r.getNetSales());
                vatSales = vatSales.add(r.getVat());
                totalSales = totalSales.add(r.getTotalSales());
            }
            Row rowTotal = sheet.createRow(rowNumber++);
            Cell totalCell = rowTotal.createCell(0);
            totalCell.setCellStyle(style);
            totalCell.setCellValue("Totals");
            Cell totalCell1 = rowTotal.createCell(1);
            totalCell1.setCellStyle(style);
            totalCell1.setCellValue(netSales.doubleValue());
            Cell totalCell2 = rowTotal.createCell(2);
            totalCell2.setCellStyle(style);
            totalCell2.setCellValue(vatSales.doubleValue());
            Cell totalCell3 = rowTotal.createCell(3);
            totalCell3.setCellStyle(style);
            totalCell3.setCellValue(totalSales.doubleValue());

            allNetSales = allNetSales.add(netSales);
            allVatSales = allVatSales.add(vatSales);
            allTotalSales = allTotalSales.add(totalSales);
        }

        if (!local.isEmpty()) {
            sheet.createRow(rowNumber++);
            Row rowProduct = sheet.createRow(rowNumber++);
            Cell cellProduct = rowProduct.createCell(0);
            cellProduct.setCellStyle(style);
            cellProduct.setCellValue("Local Product");
            BigDecimal netSales = new BigDecimal("0");
            BigDecimal vatSales = new BigDecimal("0");
            BigDecimal totalSales = new BigDecimal("0");
            for (VATReportProcedure r : local) {
                Row row = sheet.createRow(rowNumber++);
                row.createCell(0).setCellValue(r.getCustomer());
                row.createCell(1).setCellValue(r.getNetSales().doubleValue());
                row.createCell(2).setCellValue(r.getVat().doubleValue());
                row.createCell(3).setCellValue(r.getTotalSales().doubleValue());
                netSales = netSales.add(r.getNetSales());
                vatSales = vatSales.add(r.getVat());
                totalSales = totalSales.add(r.getTotalSales());
            }
            Row rowTotal = sheet.createRow(rowNumber++);
            Cell totalCell = rowTotal.createCell(0);
            totalCell.setCellStyle(style);
            totalCell.setCellValue("Totals");
            Cell totalCell1 = rowTotal.createCell(1);
            totalCell1.setCellStyle(style);
            totalCell1.setCellValue(netSales.doubleValue());
            Cell totalCell2 = rowTotal.createCell(2);
            totalCell2.setCellStyle(style);
            totalCell2.setCellValue(vatSales.doubleValue());
            Cell totalCell3 = rowTotal.createCell(3);
            totalCell3.setCellStyle(style);
            totalCell3.setCellValue(totalSales.doubleValue());

            allNetSales = allNetSales.add(netSales);
            allVatSales = allVatSales.add(vatSales);
            allTotalSales = allTotalSales.add(totalSales);
        }

        if (!ding.isEmpty()) {
            sheet.createRow(rowNumber++);
            Row rowProduct = sheet.createRow(rowNumber++);
            Cell cellProduct = rowProduct.createCell(0);
            cellProduct.setCellStyle(style);
            cellProduct.setCellValue("World Mobile Topup");
            BigDecimal netSales = new BigDecimal("0");
            BigDecimal vatSales = new BigDecimal("0");
            BigDecimal totalSales = new BigDecimal("0");
            for (VATReportProcedure r : ding) {
                Row row = sheet.createRow(rowNumber++);
                row.createCell(0).setCellValue(r.getCustomer());
                row.createCell(1).setCellValue(r.getNetSales().doubleValue());
                row.createCell(2).setCellValue(r.getVat().doubleValue());
                row.createCell(3).setCellValue(r.getTotalSales().doubleValue());
                netSales = netSales.add(r.getNetSales());
                vatSales = vatSales.add(r.getVat());
                totalSales = totalSales.add(r.getTotalSales());
            }
            Row rowTotal = sheet.createRow(rowNumber++);
            Cell totalCell = rowTotal.createCell(0);
            totalCell.setCellStyle(style);
            totalCell.setCellValue("Totals");
            Cell totalCell1 = rowTotal.createCell(1);
            totalCell1.setCellStyle(style);
            totalCell1.setCellValue(netSales.doubleValue());
            Cell totalCell2 = rowTotal.createCell(2);
            totalCell2.setCellStyle(style);
            totalCell2.setCellValue(vatSales.doubleValue());
            Cell totalCell3 = rowTotal.createCell(3);
            totalCell3.setCellStyle(style);
            totalCell3.setCellValue(totalSales.doubleValue());

            allNetSales = allNetSales.add(netSales);
            allVatSales = allVatSales.add(vatSales);
            allTotalSales = allTotalSales.add(totalSales);
        }

        Row grandTotal = sheet.createRow(rowNumber++);
        Cell totalCell = grandTotal.createCell(0);
        totalCell.setCellStyle(style);
        totalCell.setCellValue("Grand Totals");
        Cell totalCell1 = grandTotal.createCell(1);
        totalCell1.setCellStyle(style);
        totalCell1.setCellValue(allNetSales.doubleValue());
        Cell totalCell2 = grandTotal.createCell(2);
        totalCell2.setCellStyle(style);
        totalCell2.setCellValue(allVatSales.doubleValue());
        Cell totalCell3 = grandTotal.createCell(3);
        totalCell3.setCellStyle(style);
        totalCell3.setCellValue(allTotalSales.doubleValue());

        return wb;
    }

    @Override
    public String generateCustomerCommissionsReport(Integer customerId, LocalDate date) {
        GenerateOldInvoices invoices = new GenerateOldInvoices();
        invoices.setCountry("UK");
        invoices.setDuration(date.getYear(), date.getMonthValue() - 1, date.getYear(), date.getMonthValue() - 1);
        invoices.setCustomerID(customerId);
        invoices.setGenerateHTMLOutput(true);
        invoices.createInvoice();
        return invoices.m_strInvoiceReport;
    }

    @Override
    public List<DetailSales> getProductDetailSaleInfos(Integer productId, Date from, Date to) {
        return repository.getProductDetailSaleInfos(productId, from, to);
    }

    @Override
    public List<ReportBean> getStockReconciliationReport(LocalDate startDate, LocalDate endDate, Integer supplierId) {
        List<ReportBean> beans = new ArrayList<>();

        List<TMasterProductinfo> products = supplierId > 0 ? productService.findBySupplierId(supplierId) : productService.findAllActive();
        for (TMasterProductinfo product : products) {
            beans.add(getProductSaleInfo(product, startDate, endDate));
        }

        beans.sort(Comparator.comparing(ReportBean::getSupplierName));
        return beans;
    }

    private ReportBean getProductSaleInfo(TMasterProductinfo product, LocalDate startDate, LocalDate endDate) {
        Date from = DateUtil.getStartOfDay(startDate);
        Date to = DateUtil.getEndOfDay(endDate);

        List<TBatchInformation> batches = getBatchByProductId(product.getId(), from, to, true);
        ReportBean bean = new ReportBean();

        bean.setProductId(product.getId());
        bean.setProductName(product.getProductName());
        bean.setProductCostPrice(product.getCostPrice());
        bean.setSupplierName(product.getSupplier().getSupplierName());
        bean.setFaceValue(product.getProductFaceValue());

        Integer enteredQuantity = batches.stream()
                .filter(b -> b.getEntryTime().after(from) && b.getEntryTime().before(to))
                .mapToInt(TBatchInformation::getQuantity).sum();
        bean.setEnteredQuantity(enteredQuantity);

        for (TBatchInformation batch : batches) {
            ProductSaleInfo saleInfo = getBatchSaleInfo(batch.getSequenceId(), from, to);
            if (saleInfo != null) {
                ProductSaleInfo.init(saleInfo);
                if (!batch.getEntryTime().after(from)) {
                    bean.setBeginingQuantity(bean.getBeginingQuantity() + (batch.getQuantity() - saleInfo.getSalesUntilDate()));
                }
                bean.setSales(bean.getSales() + saleInfo.getSalesBetweenDate());
                bean.setTransactions(bean.getTransactions() + saleInfo.getTransactions());
                bean.setAvailableQuantity(bean.getAvailableQuantity() + (batch.getQuantity() - saleInfo.getSalesUntilDate() - saleInfo.getSalesBetweenDate()));
                bean.setSumPurchasePrice(
                        bean.getSumPurchasePrice()
                                .add(new BigDecimal(batch.getUnitPurchasePrice() + "")
                                        .multiply(new BigDecimal(saleInfo.getSalesBetweenDate() + "")))
                );
                bean.setSumSalePrice(
                        bean.getSumSalePrice()
                                .add(new BigDecimal(batch.getProbableSalePrice() + "")
                                        .multiply(new BigDecimal(saleInfo.getSalesBetweenDate() + "")))
                );
            }
        }

        return bean;
    }

    @Override
    public List<ReportBean> getSupplierSalesReport(Date from, Date to, Integer supplierId) {
        List<ReportBean> beans = new ArrayList<>();

        List<TMasterProductinfo> products = supplierId > 0 ?
                productService.findBySupplierId(supplierId) :
                productService.findAllActive();

        for (TMasterProductinfo product : products) {
            beans.add(getProductSaleInfo(product, from, to));
        }

        beans.removeIf(b -> b.getAvailableQuantity() == 0 && b.getSales() == 0);
        beans.sort(Comparator.comparing(ReportBean::getSupplierName));
        return beans;
    }

    private ReportBean getProductSaleInfo(TMasterProductinfo product, Date from, Date to) {
        List<TBatchInformation> batches = getBatchByProductId(product.getId(), from, to, false);
        ReportBean bean = new ReportBean();

        bean.setProductId(product.getId());
        bean.setProductName(product.getProductName());
        bean.setProductCostPrice(product.getCostPrice());
        bean.setSupplierName(product.getSupplier().getSupplierName());
        bean.setFaceValue(product.getProductFaceValue());

        Integer enteredQuantity = batches.stream()
                .filter(b -> b.getEntryTime().after(from) && b.getEntryTime().before(to))
                .mapToInt(TBatchInformation::getQuantity).sum();
        bean.setEnteredQuantity(enteredQuantity);

        for (TBatchInformation batch : batches) {
            if (!batch.getActive() && batch.getQuantity() == batch.getAvailableQuantity()) {
                continue;
            }
            ProductSaleInfo saleInfo = getBatchSaleInfo(batch.getSequenceId(), from, to);
            if (saleInfo != null) {
                ProductSaleInfo.init(saleInfo);
                if (!batch.getActive()) {
                    bean.setSales(bean.getSales() + saleInfo.getSalesBetweenDate());
                    bean.setTransactions(bean.getTransactions() + saleInfo.getTransactions());
                    bean.setSumPurchasePrice(bean.getSumPurchasePrice().add(new BigDecimal(batch.getUnitPurchasePrice() + "")
                            .multiply(new BigDecimal(saleInfo.getSalesBetweenDate() + ""))));
                    bean.setSumSalePrice(bean.getSumSalePrice().add(new BigDecimal(batch.getProbableSalePrice() + "")
                            .multiply(new BigDecimal(saleInfo.getSalesBetweenDate() + ""))));
                    continue;
                }

                bean.setBeginingQuantity(bean.getBeginingQuantity() + (batch.getQuantity() - saleInfo.getSalesUntilDate()));
                bean.setSales(bean.getSales() + saleInfo.getSalesBetweenDate());
                bean.setTransactions(bean.getTransactions() + saleInfo.getTransactions());
                bean.setAvailableQuantity(bean.getAvailableQuantity() + (batch.getQuantity() - saleInfo.getSalesUntilDate() - saleInfo.getSalesBetweenDate()));
                bean.setSumPurchasePrice(bean.getSumPurchasePrice().add(new BigDecimal(batch.getUnitPurchasePrice() + "")
                        .multiply(new BigDecimal(saleInfo.getSalesBetweenDate() + ""))));
                bean.setSumSalePrice(bean.getSumSalePrice().add(new BigDecimal(batch.getProbableSalePrice() + "")
                        .multiply(new BigDecimal(saleInfo.getSalesBetweenDate() + ""))));
            }
        }

        return bean;
    }

    @Override
    public ReportBean getBatchReportBySequenceId(Integer sequenceId) {
        ReportBean bean = new ReportBean();
        TBatchInformation batch = batchRepository.findOne(sequenceId);
        if (batch == null) {
            batch = batchRepository.findOneFromHistory(sequenceId);
        }
        if (batch == null) {
            return bean;
        }
        TMasterProductinfo productinfo = batch.getProduct();
        bean = getBatchSalesInfo(sequenceId);
        bean.setBatchInfoId(sequenceId);
        bean.setProductName(productinfo.getProductName());
        bean.setFaceValue(productinfo.getProductFaceValue());
        bean.setAvailableQuantity(batch.getAvailableQuantity());
        bean.setQuantity(batch.getQuantity());
        return bean;
    }

    public ReportBean getBatchSalesInfo(Integer batchId) {
        ReportBean bean = null;
        Session session = null;
        try {
            session = HibernateUtil.openSession();
            String strQuery = "SELECT " +
                    "    SUM(sales) AS sales, SUM(amount) AS amount " +
                    "FROM " +
                    "    (SELECT " +
                    "        SUM(tt.Quantity) AS sales, COUNT(tt.Quantity) AS amount " +
                    "    FROM " +
                    "        t_transactions tt " +
                    "    WHERE " +
                    "        tt.Batch_Sequence_ID = :batchId " +
                    "            AND tt.Committed = 1 " +
                    "    UNION " +
                    "    SELECT " +
                    "        SUM(tht.Quantity) AS sales, COUNT(tht.Quantity) AS amount " +
                    "    FROM " +
                    "        t_history_transactions tht " +
                    "    WHERE " +
                    "        tht.Batch_Sequence_ID = :batchId " +
                    "            AND tht.Committed = 1 " +
                    "    UNION " +
                    "    SELECT " +
                    "        SUM(tht2.Quantity) AS sales, COUNT(tht2.Quantity) AS amount " +
                    "    FROM " +
                    "        t_history_transactions_2010_05_31__2013_01_01 tht2 " +
                    "    WHERE " +
                    "        tht2.Batch_Sequence_ID = :batchId " +
                    "            AND tht2.Committed = 1) x ";
            SQLQuery sqlQuery = session.createSQLQuery(strQuery);
            sqlQuery.addScalar("sales", new IntegerType());
            sqlQuery.addScalar("amount", new IntegerType());
            sqlQuery.setParameter("batchId", batchId);
            sqlQuery.setMaxResults(1);
            sqlQuery.setResultTransformer(Transformers.aliasToBean(ReportBean.class));
            bean = (ReportBean) sqlQuery.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }
        return bean;
    }

    @Override
    public List<ProductSalesByGroup> getProductSalesByGroup(Integer supplierId, LocalDate startDate, LocalDate endDate) {
        List<ProductSalesByGroup> beans = null;
        Date from = DateUtil.getStartOfDay(startDate);
        Date to = DateUtil.getEndOfDay(endDate);

        Session session = null;
        try {
            session = HibernateUtil.openSession();
            String strQuery = "SELECT tmp.Product_ID AS productId, tmp.Product_Name AS productName, tmp.Product_Face_Value AS faceValue " +
                    "FROM t_master_productinfo tmp " +
                    "WHERE tmp.Product_Active_Status = 1 ";
            if (supplierId != 0) {
                strQuery += "AND tmp.Supplier_ID = :supplierId ";
            }
            SQLQuery sqlQuery = session.createSQLQuery(strQuery);
            sqlQuery.addScalar("productId", new IntegerType());
            sqlQuery.addScalar("productName", new StringType());
            sqlQuery.addScalar("faceValue", new FloatType());
            if (supplierId != 0) {
                sqlQuery.setParameter("supplierId", supplierId);
            }
            sqlQuery.setResultTransformer(Transformers.aliasToBean(ProductSalesByGroup.class));
            beans = sqlQuery.list();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }
        setSalesByGroups(beans, from, to, supplierId);
        return beans;
    }

    public void setSalesByGroups(List<ProductSalesByGroup> beans, Date from, Date to, Integer supplierId) {
        List<ReportBean> eezetelSales = getSalesByGroup(1, from, to, supplierId);
        List<ReportBean> gsmSales = getSalesByGroup(2, from, to, supplierId);
        List<ReportBean> kasGlobalSales = getSalesByGroup(4, from, to, supplierId);
        List<ReportBean> kupaySales = getSalesByGroup(10, from, to, supplierId);
        List<ReportBean> fastTelSales = getSalesByGroup(7, from, to, supplierId);
        for (ProductSalesByGroup salesByGroup : beans) {
            for (ReportBean bean : eezetelSales) {
                if (salesByGroup.getProductId().equals(bean.getProductId())) {
                    salesByGroup.setEezeetelSales(bean.getSales());
                    break;
                }
            }
            for (ReportBean bean : gsmSales) {
                if (salesByGroup.getProductId().equals(bean.getProductId())) {
                    salesByGroup.setGsmSales(bean.getSales());
                    break;
                }
            }
            for (ReportBean bean : kasGlobalSales) {
                if (salesByGroup.getProductId().equals(bean.getProductId())) {
                    salesByGroup.setKasGlobalSales(bean.getSales());
                    break;
                }
            }
            for (ReportBean bean : kupaySales) {
                if (salesByGroup.getProductId().equals(bean.getProductId())) {
                    salesByGroup.setKupaySales(bean.getSales());
                    break;
                }
            }
            for (ReportBean bean : fastTelSales) {
                if (salesByGroup.getProductId().equals(bean.getProductId())) {
                    salesByGroup.setFastTelSales(bean.getSales());
                    break;
                }
            }
            if (salesByGroup.getEezeetelSales() == null) salesByGroup.setEezeetelSales(0);
            if (salesByGroup.getGsmSales() == null) salesByGroup.setGsmSales(0);
            if (salesByGroup.getKasGlobalSales() == null) salesByGroup.setKasGlobalSales(0);
            if (salesByGroup.getKupaySales() == null) salesByGroup.setKupaySales(0);
            if (salesByGroup.getFastTelSales() == null) salesByGroup.setFastTelSales(0);
            salesByGroup.setSales(salesByGroup.getEezeetelSales() + salesByGroup.getGsmSales() +
                    salesByGroup.getKasGlobalSales() + salesByGroup.getKupaySales() + salesByGroup.getFastTelSales());
        }
    }

    public List<ReportBean> getSalesByGroup(Integer groupId, Date from, Date to, Integer supplierId) {
        List<ReportBean> beans = null;
        Session session = null;
        try {
            session = HibernateUtil.openSession();
            StringBuilder builder = new StringBuilder();
            builder.append("SELECT tt.Product_ID AS productId, sum(tt.Quantity) as sales ");
            builder.append("FROM t_transactions tt ");
            builder.append("INNER JOIN t_master_customerinfo tmc ON tmc.Customer_ID = tt.Customer_ID ");
            builder.append("INNER JOIN t_master_customer_groups tmcg ON tmcg.Customer_Group_ID = tmc.Customer_Group_ID ");
            builder.append("INNER JOIN t_master_productinfo tmp ON tmp.Product_ID = tt.Product_ID ");
            builder.append("WHERE  tmcg.Customer_Group_ID = :groupId ");
            builder.append("AND tt.Committed = 1 ");
            builder.append("AND tt.Transaction_Time BETWEEN :fromDate AND :toDate ");
            if (supplierId != 0) {
                builder.append("AND tmp.Supplier_ID = :supplierId ");
            }
            builder.append("GROUP BY tt.Product_ID");

            SQLQuery sqlQuery = session.createSQLQuery(builder.toString());
            sqlQuery.addScalar("productId", new IntegerType());
            sqlQuery.addScalar("sales", new IntegerType());
            sqlQuery.setParameter("groupId", groupId);
            sqlQuery.setParameter("fromDate", from);
            sqlQuery.setParameter("toDate", to);
            if (supplierId != 0) {
                sqlQuery.setParameter("supplierId", supplierId);
            }
            sqlQuery.setResultTransformer(Transformers.aliasToBean(ReportBean.class));
            beans = sqlQuery.list();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }
        return beans;
    }

    public List<TBatchInformation> getBatchByProductId(Integer productId, Date from, Date to, boolean onlyActive) {
        List<TBatchInformation> result = null;
        Session session = null;
        try {
            session = HibernateUtil.openSession();
            String sql = "SELECT * FROM t_batch_information tbi " +
                    "WHERE tbi.Batch_Activated_By_Supplier = 1 " +
                    "AND tbi.Batch_Ready_To_Sell = 1 " +
                    "AND tbi.Product_ID = :productId " +
                    "AND tbi.Batch_Upload_Status = 'SUCCESS-BatchUpdateInDB' " +
                    (onlyActive ? "AND tbi.IsBatchActive = 1 " : "") +
                    "AND tbi.Batch_Entry_Time < :toDate " +
                    "AND (tbi.Last_Touch_Time > :fromDate OR tbi.Available_Quantity > 0) " +
                    "UNION " +
                    "SELECT * FROM t_history_batch_information thbi " +
                    "WHERE thbi.Batch_Activated_By_Supplier = 1 " +
                    "AND thbi.Batch_Ready_To_Sell = 1 " +
                    "AND thbi.Product_ID = :productId " +
                    "AND thbi.Batch_Upload_Status = 'SUCCESS-BatchUpdateInDB' " +
                    (onlyActive ? "AND thbi.IsBatchActive = 1 " : "") +
                    "AND thbi.Batch_Entry_Time < :toDate " +
                    "AND (thbi.Last_Touch_Time > :fromDate OR thbi.Available_Quantity > 0) ";
            SQLQuery sqlQuery = session.createSQLQuery(sql);
            sqlQuery.addEntity(TBatchInformation.class);
            sqlQuery.setParameter("productId", productId);
            sqlQuery.setParameter("fromDate", from);
            sqlQuery.setParameter("toDate", to);
            result = sqlQuery.list();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }
        return result;
    }

    public ProductSaleInfo getBatchSaleInfo(Integer batchId, Date from, Date to) {
        ProductSaleInfo result = null;
        Session session = null;
        try {
            session = HibernateUtil.openSession();
            String sql = "SELECT SUM(salesBetweenDate) AS salesBetweenDate, SUM(salesUntilDate) AS salesUntilDate, SUM(transactions) AS transactions FROM (" +
                    "SELECT sum(tt.Quantity) AS salesBetweenDate, COUNT(DISTINCT tt.Transaction_ID) as transactions, " +
                    "(SELECT SUM(tt.Quantity) " +
                    "FROM t_transactions tt " +
                    "WHERE tt.Batch_Sequence_ID = :batchId " +
                    "AND tt.Committed = 1 " +
                    "AND tt.Transaction_Time < :fromDate ) AS salesUntilDate " +
                    "FROM t_transactions tt " +
                    "WHERE tt.Batch_Sequence_ID = :batchId " +
                    "AND tt.Committed = 1 " +
                    "AND tt.Transaction_Time  BETWEEN :fromDate AND :toDate " +
                    "UNION " +
                    "SELECT sum(tht.Quantity) AS salesBetweenDate, COUNT(DISTINCT tht.Transaction_ID) as transactions, " +
                    "(SELECT SUM(tht.Quantity) FROM t_history_transactions tht " +
                    "WHERE tht.Batch_Sequence_ID = :batchId " +
                    "AND tht.Committed = 1 " +
                    "AND tht.Transaction_Time < :fromDate) AS salesUntilDate " +
                    "FROM t_history_transactions tht " +
                    "WHERE tht.Batch_Sequence_ID = :batchId " +
                    "AND tht.Committed = 1 " +
                    "AND tht.Transaction_Time  BETWEEN :fromDate AND :toDate " +
                    "UNION " +
                    "SELECT sum(tht2.Quantity) AS salesBetweenDate, COUNT(DISTINCT tht2.Transaction_ID) as transactions, " +
                    "(SELECT SUM(tht2.Quantity) FROM t_history_transactions_2010_05_31__2013_01_01 tht2 " +
                    "WHERE tht2.Batch_Sequence_ID = :batchId " +
                    "AND tht2.Committed = 1 " +
                    "AND tht2.Transaction_Time < :fromDate) AS salesUntilDate " +
                    "FROM t_history_transactions_2010_05_31__2013_01_01 tht2 " +
                    "WHERE tht2.Batch_Sequence_ID = :batchId " +
                    "AND tht2.Committed = 1 " +
                    "AND tht2.Transaction_Time  BETWEEN :fromDate AND :toDate " +
                    ") x ";
            SQLQuery sqlQuery = session.createSQLQuery(sql);
            sqlQuery.addScalar("salesBetweenDate", new IntegerType());
            sqlQuery.addScalar("salesUntilDate", new IntegerType());
            sqlQuery.addScalar("transactions", new IntegerType());
            sqlQuery.setParameter("fromDate", from);
            sqlQuery.setParameter("toDate", to);
            sqlQuery.setParameter("batchId", batchId);
            sqlQuery.setResultTransformer(Transformers.aliasToBean(ProductSaleInfo.class));
            sqlQuery.setMaxResults(1);
            result = (ProductSaleInfo) sqlQuery.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }
        return result;
    }

    @Override
    public List<DetailSales> getProductsDetailSales(Integer supplierId, Integer productId, Date from, Date to) {
        List<DetailSales> result = new ArrayList<>();
        List<TMasterProductinfo> products = new ArrayList<>();
        if (supplierId == 0) {
            List<TMasterSupplierinfo> suppliers = supplierService.findActiveAndOrderByName();
            for (TMasterSupplierinfo supplier : suppliers) {
                products.addAll(supplier.getProducts());
            }
        } else if (productId == 0) {
            products = productService.findBySupplierId(supplierId);
        } else {
            products.add(productService.findOne(productId));
        }

        if (products.isEmpty()) return result;

        List<ProductSaleInfo> productSales = repository.getProductSaleInfos(
                products.stream().map(TMasterProductinfo::getId).collect(Collectors.toList()), from, to);

        for (ProductSaleInfo saleInfo : productSales) {
            TMasterProductinfo product = productService.findByIdFromList(saleInfo.getProductId(), products);

            DetailSales detailSales = DetailSales.findByProductId(saleInfo.getProductId(), result);
            if (detailSales == null) {
                detailSales = new DetailSales();
                detailSales.setProductId(saleInfo.getProductId());
                detailSales.setProductName(product.getProductName());
                detailSales.setFaceValue(product.getProductFaceValue());
                detailSales.setTransactions(0);
                detailSales.setSinglePurchases(0);
                detailSales.setMultiplepurchases(0);
                result.add(detailSales);
            }

            detailSales.setTransactions(detailSales.getTransactions() + saleInfo.getTransactions());
            if (saleInfo.getPurchaseType() == 1) {
                detailSales.setSinglePurchases(detailSales.getSinglePurchases() + saleInfo.getSalesBetweenDate());
            } else {
                detailSales.setMultiplepurchases(detailSales.getMultiplepurchases() + saleInfo.getSalesBetweenDate());
            }

            detailSales.setSales(detailSales.getSinglePurchases() + detailSales.getMultiplepurchases());
        }

        return result;
    }

    @Override
    public List<SalesReturn> getSalesReturnReport(Integer supplierId, LocalDate startDate, LocalDate endDate) {
        List<TMasterProductinfo> products = supplierId > 0 ?
                productService.findBySupplierId(supplierId) :
                productService.findAllActive();

        List<SalesReturn> result = products.stream().map(SalesReturn::new).collect(Collectors.toList());
        Date start = DateUtil.getStartOfDay(startDate);
        Date end = DateUtil.getEndOfDay(endDate);
        for (SalesReturn salesReturn : result) {
            List<TBatchInformation> batches = batchRepository.findDeactivatedBatchByProductId(salesReturn.getProductId());
            if (batches.isEmpty()) {
                continue;
            }
            Integer sales = transactionRepository.calcSumOfBatchSales(batches.stream().map(TBatchInformation::getSequenceId).collect(Collectors.toList()), start, end);
            salesReturn.setSales(sales == null ? 0 : sales);
        }

        result.sort(Comparator.comparing(SalesReturn::getSupplierName));
        return result;
    }

    public List<ProfitReportBean> getProfitReportForMobileTopup(Integer groupId, Integer customerId, LocalDate fromDate, LocalDate toDate) {
        List<ProfitReportBean> result = new ArrayList<>();

        Date start = DateUtil.getStartOfDay(fromDate);
        Date end = DateUtil.getEndOfDay(toDate);

        List<TDingTransactions> dingTransactions;
        List<MobitopupTransaction> mobitopupTransactions;

        if (customerId > 0) {
            dingTransactions = dingTransactionService.findByErrorCodeAndCustomerAndTransactionTimeBetween(
                    1, new TMasterCustomerinfo(customerId), start, end
            );
            mobitopupTransactions = mobitopupTransactionService.findByErrorCodeAndCustomerAndTransactionTimeBetween(
                    0, new TMasterCustomerinfo(customerId), start, end
            );
        } else {
            dingTransactions = dingTransactionService.findByGroupAndDate(
                    1, new TMasterCustomerGroups(groupId), start, end
            );
            mobitopupTransactions = mobitopupTransactionService.findByGroupAndDate(
                    0, new TMasterCustomerGroups(groupId), start, end
            );
        }

        Setting setting = settingService.findByType(SettingType.DIGICEL_JAMAICA_RETURN_PERCENT);
        BigDecimal retunrPercent = new BigDecimal(setting.getValue());

        dingTransactions.forEach(t -> result.add(ProfitReportBean.toBean(t, groupId, retunrPercent)));
        mobitopupTransactions.forEach(t -> result.add(ProfitReportBean.toBean(t)));

        return result;
    }

    public List<ProfitReportBean> getProfitReportForMobileUnlocking(Integer groupId, Integer customerId, LocalDate fromDate, LocalDate toDate) {
        List<ProfitReportBean> result = new ArrayList<>();

        Date start = DateUtil.getStartOfDay(fromDate);
        Date end = DateUtil.getEndOfDay(toDate);

        if (customerId > 0) {
            mobileUnlockingOrderService.findByCustomerAndCreatedDateBetween(
                    new TMasterCustomerinfo(customerId),
                    start,
                    end
            ).forEach(o -> result.add(ProfitReportBean.toBean(o)));
        } else {
            mobileUnlockingOrderService.findByGroupAndDate(
                    new TMasterCustomerGroups(groupId),
                    start,
                    end
            ).forEach(o -> result.add(ProfitReportBean.toBean(o)));
        }

        return result;
    }

    private List<ProfitReportBean> getProfitReport(Integer groupId, Integer customerId, LocalDate fromDate, LocalDate toDate) {
        List<ProfitReportBean> list = new ArrayList<>();
        String groupInQuery = " and c.Customer_Group_ID = :groupId ";
        String customerInQuery = " and c.Customer_ID = :customerId ";

        Session session = null;
        try {
            session = HibernateUtil.openSession();
            String strQuery = "( SELECT " +
                    "    c.Customer_Company_Name as customer, " +
                    "    p.Product_Name as product, " +
                    "    p.Product_Type_ID as productTypeId, " +
                    "    p.Caliculate_VAT as calculateVat, " +
                    "    p.Supplier_ID as supplierId, " +
                    "    p.COST_PRICE as costPrice, " +
                    "    count(t.Transaction_ID) as transactions, " +
                    "    sum(t.Quantity) as quantity, " +
                    "    ROUND(sum(t.Unit_Group_Price), 2) as groupPrice, " +
                    "    ROUND(sum(t.Secondary_Transaction_Price), 2) as agentPrice, " +
                    "    ROUND(sum(t.Unit_Purchase_Price), 2) as customerPrice " +
                    "FROM " +
                    "    t_transactions t, " +
                    "    t_master_productinfo p, " +
                    "    t_master_customerinfo c " +
                    "where " +
                    "    t.Transaction_Time between :fromDate and :toDate " +
                    "        and t.Committed = 1 " +
                    "        and t.Product_ID = p.Product_ID " +
                    "        and t.Customer_ID = c.Customer_ID ";
            if (groupId > 0) {
                strQuery += groupInQuery;
            }
            if (customerId > 0) {
                strQuery += customerInQuery;
            }
            strQuery += "group by c.Customer_ID, p.Product_ID order by c.Customer_Company_Name ) ";

            if (LocalDate.now().minusDays(7).isAfter(fromDate)) {
                strQuery += "union " +
                        "( SELECT " +
                        "    c.Customer_Company_Name as companyName, " +
                        "    p.Product_Name as product, " +
                        "    p.Product_Type_ID as productTypeId, " +
                        "    p.Caliculate_VAT as calculateVat, " +
                        "    p.Supplier_ID as supplierId, " +
                        "    p.COST_PRICE as costPrice, " +
                        "    count(t.Transaction_ID) as transactions, " +
                        "    sum(t.Quantity) as quantity, " +
                        "    ROUND(sum(t.Unit_Group_Price), 2) as groupPrice, " +
                        "    ROUND(sum(t.Secondary_Transaction_Price), 2) as agentPrice, " +
                        "    ROUND(sum(t.Unit_Purchase_Price), 2) as customerPrice " +
                        "FROM " +
                        "    t_history_transactions t, " +
                        "    t_master_productinfo p, " +
                        "    t_master_customerinfo c " +
                        "where " +
                        "    t.Transaction_Time between :fromDate and :toDate " +
                        "        and t.Committed = 1 " +
                        "        and t.Product_ID = p.Product_ID " +
                        "        and t.Customer_ID = c.Customer_ID ";
                if (groupId > 0) {
                    strQuery += groupInQuery;
                }
                if (customerId > 0) {
                    strQuery += customerInQuery;
                }
                strQuery += "group by c.Customer_ID, p.Product_ID order by c.Customer_Company_Name ) ";
            }

            if (LocalDate.of(2013, 5, 31).isAfter(fromDate)) {
                strQuery += "union " +
                        "( SELECT " +
                        "    c.Customer_Company_Name as companyName, " +
                        "    p.Product_Name as product, " +
                        "    p.Product_Type_ID as productTypeId, " +
                        "    p.Caliculate_VAT as calculateVat, " +
                        "    p.Supplier_ID as supplierId, " +
                        "    p.COST_PRICE as costPrice, " +
                        "    count(t.Transaction_ID) as transactions, " +
                        "    sum(t.Quantity) as quantity, " +
                        "    ROUND(sum(t.Unit_Group_Price), 2) as groupPrice, " +
                        "    ROUND(sum(t.Secondary_Transaction_Price), 2) as agentPrice, " +
                        "    ROUND(sum(t.Unit_Purchase_Price), 2) as customerPrice " +
                        "FROM " +
                        "    t_history_transactions_2010_05_31__2013_01_01 t, " +
                        "    t_master_productinfo p, " +
                        "    t_master_customerinfo c " +
                        "where " +
                        "    t.Transaction_Time between :fromDate and :toDate " +
                        "        and t.Committed = 1 " +
                        "        and t.Product_ID = p.Product_ID " +
                        "        and t.Customer_ID = c.Customer_ID " +
                        "        and c.Customer_Group_ID = :groupId ";
                if (groupId > 0) {
                    strQuery += groupInQuery;
                }
                if (customerId > 0) {
                    strQuery += customerInQuery;
                }
                strQuery += "group by c.Customer_ID, p.Product_ID order by c.Customer_Company_Name ) ";
            }

            SQLQuery sqlQuery = session.createSQLQuery(strQuery);
            sqlQuery.addScalar("customer", new StringType());
            sqlQuery.addScalar("product", new StringType());
            sqlQuery.addScalar("productTypeId", new IntegerType());
            sqlQuery.addScalar("calculateVat", new ShortType());
            sqlQuery.addScalar("supplierId", new IntegerType());
            sqlQuery.addScalar("costPrice", new BigDecimalType());
            sqlQuery.addScalar("transactions", new IntegerType());
            sqlQuery.addScalar("quantity", new IntegerType());
            sqlQuery.addScalar("groupPrice", new BigDecimalType());
            sqlQuery.addScalar("agentPrice", new BigDecimalType());
            sqlQuery.addScalar("customerPrice", new BigDecimalType());
            if (groupId > 0) {
                sqlQuery.setParameter("groupId", groupId);
            }
            if (customerId > 0) {
                sqlQuery.setParameter("customerId", customerId);
            }
            sqlQuery.setParameter("fromDate", DateUtil.getStartOfDay(fromDate));
            sqlQuery.setParameter("toDate", DateUtil.getEndOfDay(toDate));
            sqlQuery.setResultTransformer(Transformers.aliasToBean(ProfitReportBean.class));
            list = (List<ProfitReportBean>) sqlQuery.list();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }

        return list;
    }

    private List<ProfitReportBean> getVatReport(Integer groupId, Integer customerId, LocalDate fromDate, LocalDate toDate) {
        List<ProfitReportBean> result = getProfitReport(groupId, customerId, fromDate, toDate);

        List<TMasterSupplierinfo> suppliers = supplierService.findAll();
        List<TMasterProducttype> producttypes = productTypeService.findAll();

        result.forEach(p -> {
            p.setProductType(productTypeService.findInListById(p.getProductTypeId(), producttypes).getProductType());
            p.setSupplier(supplierService.findInListById(p.getSupplierId(), suppliers).getSupplierName());
        });

        if (groupId != 1 && !AuthenticationUtils.isMasterAdmin()) {
            result.forEach(t -> {
                t.setCostPrice(t.getGroupPrice().divide(new BigDecimal(t.getQuantity()), BigDecimal.ROUND_HALF_EVEN));
            });
        }

        result.sort((r1, r2) -> r1.getCustomer().compareTo(r2.getCustomer()));

        return result;
    }
}
