package com.eezeetel.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by Denis Dulyak on 22.12.2015.
 */
@Controller("adminViewController")
@RequestMapping("/admin")
public class ViewController {

    private static final String BASE_LAYOUT = "admin/layout";

    @RequestMapping(method = RequestMethod.GET)
    public String admin(HttpServletRequest request, Model model) {
        putModelAttributes(request, model);
        return "admin/AdminMain";
    }

    @RequestMapping(value = "/customerinfo", method = RequestMethod.GET)
    public String customer(HttpServletRequest request, Model model) {
        putModelAttributes(request, model);
        return "admin/Customers/ManageCustomerInfo";
    }

    @RequestMapping(value = "/daily-customers-transactions", method = RequestMethod.GET)
    public String dailyCustomersTransactions(HttpServletRequest request, Model model) {
        putModelAttributes(request, model, "Daily Customers Transactions", "Reports/dailyCustomersTransactions.jsp", true);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/profit-report", method = RequestMethod.GET)
    public String profitReport(HttpServletRequest request, Model model) {
        putModelAttributes(request, model, "New Profit Report", "Reports/newProfitReport.jsp", true);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/vat-report", method = RequestMethod.GET)
    public String vatReport(HttpServletRequest request, Model model) {
        putModelAttributes(request, model, "Vat Report", "Reports/vatReport.jsp", true);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/change-password", method = RequestMethod.GET)
    public String changePassword(HttpServletRequest request, Model model) {
        putModelAttributes(request, model, "Change Password", "Users/ChangePassword.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/accounts/pinless-customer-commission", method = RequestMethod.GET)
    public String pinlessGroupCommission(HttpServletRequest request, Model model) {
        putModelAttributes(request, model, "Pinless Customer Commission", "Accounts/pinlessCustomerCommission.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/mobile-unlocking/commission", method = RequestMethod.GET)
    public String mobileUnlockingCommision(HttpServletRequest request, Model model) {
        putModelAttributes(request, model, "Mobile Unlocking Profit", "Accounts/mobileUnlockingCustomerCommission.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/world-topup-customer-commission", method = RequestMethod.GET)
    public String worldTopupCustomerCommission(HttpServletRequest request, Model model) {
        putModelAttributes(request, model, "World Topup Customer Commission", "Customers/worldTopupCustomerCommission.jsp", false);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/customer-balance", method = RequestMethod.GET)
    public String customerBalance(HttpServletRequest request, Model model) {
        putModelAttributes(request, model, "Customer Balance Report", "Reports/customerBalance.jsp", true);
        return BASE_LAYOUT;
    }

    @RequestMapping(value = "/report/customer-commissions", method = RequestMethod.GET)
    public String customerCommissionsReport(HttpServletRequest request, Model model) {
        putModelAttributes(request, model, "Customer Commissions Report", "Reports/customerCommissions.jsp", false);
        return BASE_LAYOUT;
    }

    private void putModelAttributes(HttpServletRequest request, Model model) {
        putModelAttributes(request, model, "", "", true);
    }

    private void putModelAttributes(HttpServletRequest request, Model model, String title, String content, Boolean useAngular) {
        model.addAttribute("groupId", request.getSession().getAttribute("GROUP_ID"));
        model.addAttribute("isGroupAdmin", request.isUserInRole("Group_Admin"));
        model.addAttribute("userName", request.getRemoteUser());
        model.addAttribute("title", title);
        model.addAttribute("content", content);
        model.addAttribute("useAngular", useAngular);
    }
}
