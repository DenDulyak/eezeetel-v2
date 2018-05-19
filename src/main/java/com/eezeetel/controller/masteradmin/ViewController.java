package com.eezeetel.controller.masteradmin;

import com.eezeetel.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Created by Denis Dulyak on 30.01.2016.
 */
@Controller("masterAdminViewController")
@RequestMapping("/masteradmin")
public class ViewController {

    private static final String BASE_LAYOUT = "masteradmin/layout";

    @Autowired
    private UserTypeService userTypeService;

    @Autowired
    private GroupService groupService;

    @Autowired
    private MobileUnlockingService mobileUnlockingService;

    @Autowired
    private FeatureService featureService;

    @Autowired
    private SupplierService supplierService;

    @RequestMapping(value = "/user/type", method = RequestMethod.GET)
    public String type(Model model) {
        model.addAttribute("types", userTypeService.findAll());
        addBaseAttributes(model, "List, Modify, Delete or Activiate User Type", "ManageUserType.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/groups", method = RequestMethod.GET)
    public String group(Model model) {
        model.addAttribute("groups", groupService.findAll());
        addBaseAttributes(model, "Customer groups", "group.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/mobile-unlocking", method = RequestMethod.GET)
    public String mobileUnlocking(Model model) {
        model.addAttribute("mobileUnlockings", mobileUnlockingService.findAll());
        addBaseAttributes(model, "Mobile Unlocking", "mobileunlocking/MobileUnlocking.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/customers/pinless-group-commission", method = RequestMethod.GET)
    public String pinlessGroupCommission(Model model) {
        addBaseAttributes(model, "Pinless Group Commission", "customers/pinlessGroupCommission.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/customers/world-topup-group-commission", method = RequestMethod.GET)
    public String worldTopupGroupCommission(Model model) {
        addBaseAttributes(model, "World Mobile Topup Group Commission", "customers/worldTopupGroupCommission.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/mobile-unlocking/orders", method = RequestMethod.GET)
    public String mobileUnlockingOrders(Model model) {
        addBaseAttributes(model, "Mobile Unlocking Orders", "mobileunlocking/orders.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/mobile-unlocking/commission", method = RequestMethod.GET)
    public String mobileUnlockingCommision(Model model) {
        addBaseAttributes(model, "Mobile Unlocking Profit", "mobileunlocking/mobileUnlockingCommission.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/customers/setup-features", method = RequestMethod.GET)
    public String feature(Model model) {
        model.addAttribute("features", featureService.findAll());
        addBaseAttributes(model, "Setup Features", "customers/SetupFeatures.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/calling-card-price", method = RequestMethod.GET)
    public String callingCardPrice(Model model) {
        addBaseAttributes(model, "Calling Card Prices", "customers/callingCardPrice.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/by-sequence", method = RequestMethod.GET)
    public String bySequence(Model model) {
        addBaseAttributes(model, "Report by Sequence ID", "reports/bySequence.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/revoked-transactions", method = RequestMethod.GET)
    public String revokedTransactions(Model model) {
        addBaseAttributes(model, "Revoked Transactions Status and Report", "reports/revokedTransactions.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/stock-reconciliation", method = RequestMethod.GET)
    public String stockReconciliation(Model model) {
        model.addAttribute("suppliers", supplierService.findActiveAndOrderByName());
        addBaseAttributes(model, "Stock Reconciliation Report", "reports/stockReconciliation.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/sales-by-agent", method = RequestMethod.GET)
    public String productSalesByGroup(Model model) {
        addBaseAttributes(model, "Sales by Agent Report", "reports/salesByAgent.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/product-batches", method = RequestMethod.GET)
    public String productBatch(Model model) {
        addBaseAttributes(model, "Product Batches", "reports/productBatches.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/mobitopup-transactions", method = RequestMethod.GET)
    public String mobitopupTransactions(Model model) {
        addBaseAttributes(model, "Mobitopup Transactions", "reports/mobitopupTransactions.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/daily-customers-transactions", method = RequestMethod.GET)
    public String dailyCustomersTransactions(Model model) {
        addBaseAttributes(model, "Daily Customers Transactions", "reports/dailyCustomersTransactions.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/ding-transactions", method = RequestMethod.GET)
    public String dingTransactions(Model model) {
        addBaseAttributes(model, "Ding Transactions", "reports/dingTransactions.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/pinless-transactions", method = RequestMethod.GET)
    public String pinlessTransactions(Model model) {
        addBaseAttributes(model, "Pinless Transactions", "reports/pinlessTransactions.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/product-cost-price", method = RequestMethod.GET)
    public String productCostPrice(Model model) {
        addBaseAttributes(model, "Product with cost price", "reports/productCostPrice.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/sales-return", method = RequestMethod.GET)
    public String salesReturns(Model model) {
        addBaseAttributes(model, "Sales Return", "reports/salesReturn.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/detail-sales", method = RequestMethod.GET)
    public String detailSales(Model model) {
        addBaseAttributes(model, "Detail Sales Report", "reports/detailSales.jsp", false);
        model.addAttribute("suppliers", supplierService.findActiveAndOrderByName());
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/new-profit", method = RequestMethod.GET)
    public String newProfitReport(Model model) {
        addBaseAttributes(model, "New Profit Report", "reports/newProfitReport.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/vat-by-month", method = RequestMethod.GET)
    public String vatByMonth(Model model) {
        addBaseAttributes(model, "VAT By Month", "reports/vatByMonth.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/vat-by-customer", method = {RequestMethod.GET, RequestMethod.POST})
    public String vatByCustomer(Model model) {
        addBaseAttributes(model, "VAT Report", "VAT_Report_By_Customer.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/setting", method = RequestMethod.GET)
    public String setting(Model model) {
        addBaseAttributes(model, "Setting", "setting.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/retune-cards-stock", method = RequestMethod.GET)
    public String retuneCardsStock(Model model) {
        addBaseAttributes(model, "Retune Cards Stock", "transactions/retuneCardsStock.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/sales-retune", method = RequestMethod.GET)
    public String salesRetune(Model model) {
        addBaseAttributes(model, "Sales Retune", "transactions/salesRetune.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/correct-card-information", method = RequestMethod.GET)
    public String correctCardInformation(Model model) {
        addBaseAttributes(model, "Correct Card Information", "CorrectCardInfo.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/world-mobile-topup-summary-report", method = RequestMethod.GET)
    public String worldMobileTopupSummaryReport(Model model) {
        addBaseAttributes(model, "World Mobile Topup Summary Report", "reports/worldMobileTopupSummaryReport.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/all-transactions", method = RequestMethod.GET)
    public String allTransactions(Model model) {
        addBaseAttributes(model, "All Transactions Report", "reports/allTransactions.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/customer-balance", method = RequestMethod.GET)
    public String customerTopups(Model model) {
        addBaseAttributes(model, "Customer Balance Report", "reports/customerBalance.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/manage-product-sale-info", method = RequestMethod.GET)
    public String manageProductSaleInfo(Model model) {
        addBaseAttributes(model, "List, Modify, Delete or Activate Product Information", "ManageProductSaleInfo.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/new-product-sale-info", method = RequestMethod.GET)
    public String newProductSaleInfo(Model model) {
        addBaseAttributes(model, "New Product Sale Information", "NewProductSaleInfo.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/modify-product-sale-info", method = RequestMethod.GET)
    public String modifyProductSaleInfo(Model model) {
        addBaseAttributes(model, "Modify Product Sale Information", "ModifyProductSaleInfo.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/manage-supplier", method = RequestMethod.GET)
    public String manageSupplier(Model model) {
        addBaseAttributes(model, "List, Modify, Delete or Activate Supplier Information", "ManageSupplierInfo.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/new-supplier", method = RequestMethod.GET)
    public String newSupplier(Model model) {
        addBaseAttributes(model, "New Supplier Information", "NewSupplierInfo.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/modify-supplier", method = RequestMethod.GET)
    public String modifySupplier(Model model) {
        addBaseAttributes(model, "Modify Supplier Information", "ModifySupplierInfo.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/supplier-payment", method = RequestMethod.GET)
    public String supplierPayment(Model model) {
        model.addAttribute("suppliers", supplierService.findActiveAndOrderByName());
        addBaseAttributes(model, "Supplier Payment Report", "reports/supplierPayment.jsp");
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/new-batch", method = RequestMethod.GET)
    public String newBatch(Model model) {
        addBaseAttributes(model, "New Batch Information", "NewBatchInfo.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/modify-batch", method = RequestMethod.GET)
    public String modifyBatch(Model model) {
        addBaseAttributes(model, "Modify Batch Information", "ModifyBatchInfo.jsp", false);
        return BASE_LAYOUT;
    }

    private void addBaseAttributes(Model model, String title, String content) {
        addBaseAttributes(model, title, content, true);
    }

    private void addBaseAttributes(Model model, String title, String content, Boolean useAngular) {
        model.addAttribute("title", title);
        model.addAttribute("content", content);
        model.addAttribute("useAngular", useAngular);
    }
}
