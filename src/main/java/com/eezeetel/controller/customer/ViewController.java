package com.eezeetel.controller.customer;

import com.eezeetel.customerapp.ProcessTransaction;
import com.eezeetel.entity.Feature;
import com.eezeetel.entity.TCustomerUsers;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.TMessages;
import com.eezeetel.enums.TitleType;
import com.eezeetel.service.*;
import com.google.common.collect.Lists;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.text.DecimalFormat;
import java.util.Collections;
import java.util.List;

/**
 * Created by Denis Dulyak on 26.10.2015.
 */
@Controller
@RequestMapping("/customer")
public class ViewController {

    @Autowired
    private CustomerUserService customerUserService;

    @Autowired
    private MessageService messageService;

    @Autowired
    private ProcessTransaction processTransaction;

    @Autowired
    private CallingCardPriceService callingCardPriceService;

    @Autowired
    private TitleService titleService;

    @RequestMapping(value = "/products", method = RequestMethod.GET)
    public String products(HttpServletRequest request, Model model) {
        TCustomerUsers customerUser = customerUserService.findByLogin(request.getRemoteUser());
        if(customerUser == null) {
            putNavAttributes(request, model, null);
            model.addAttribute("message", "");
            return "customer/ShowProducts";
        }
        List<TMessages> messages = Collections.emptyList();
        TMasterCustomerinfo customer = customerUser.getCustomer();
        if(customer.getCustomerFeatureId() == null) {
            customer.setCustomerFeatureId(1);
        }
        Object showMessage = request.getSession().getAttribute("SHOW_MESSAGE");
        if (showMessage != null) {
            request.getSession().removeAttribute("SHOW_MESSAGE");
            messages = messageService.findByGroup(customer.getGroup());
        }
        model.addAttribute("message", !messages.isEmpty() && messages.get(0).getMessage() != null ? messages.get(0).getMessage().trim() : "");
        for (Feature feature : customer.getFeatures()) {
            model.addAttribute(feature.getFeatureType().name(), feature.getFeatureType().name());
        }
        putNavAttributes(request, model, customer);
        model.addAttribute("callingCardPricesList", Lists.partition(callingCardPriceService.findAll(), 8));
        model.addAttribute("callingCardPriceTitle", titleService.findByType(TitleType.CALLING_CARDS_PRICES));
        return "customer/ShowProducts";
    }

    @RequestMapping(value = "/transactions", method = RequestMethod.GET)
    public String transactions(HttpServletRequest request, Model model) {
        putNavAttributes(request, model);
        return "customer/transaction/transactions";
    }

    @RequestMapping(value = "/request-credit", method = RequestMethod.GET)
    public String requestCredit(HttpServletRequest request, Model model) {
        putNavAttributes(request, model);
        return "customer/RequestCredit";
    }

    @RequestMapping(value = "/transactions-report", method = RequestMethod.GET)
    public String transactionsReport(HttpServletRequest request, Model model) {
        putNavAttributes(request, model);
        return "customer/ReportDailyCustomer";
    }

    @RequestMapping(value = "/credit-report", method = RequestMethod.GET)
    public String creditReport(HttpServletRequest request, Model model) {
        putNavAttributes(request, model);
        return "customer/CustomerCreditReport";
    }

    @RequestMapping(value = "/monthly-invoice", method = RequestMethod.GET)
    public String monthlyInvoiceReport(HttpServletRequest request, Model model, @RequestParam(required = false) String date) {
        request.setAttribute("date", date);
        putNavAttributes(request, model);
        return "customer/CustomerInvoice";
    }

    @RequestMapping(value = "/sim-commision-report", method = RequestMethod.GET)
    public String simCommisionReport(HttpServletRequest request, Model model, @RequestParam(required = false) String previous_month) {
        request.setAttribute("previous_month", previous_month);
        putNavAttributes(request, model);
        return "customer/sim/SIMReport";
    }

    @RequestMapping(value = "/change-password", method = RequestMethod.GET)
    public String changePassword(HttpServletRequest request, Model model) {
        putNavAttributes(request, model);
        return "customer/ChangePassword";
    }

    @RequestMapping(value = "/mobile-unlocking-orders", method = RequestMethod.GET)
    public String mobileUnlockingOrders(HttpServletRequest request, Model model) {
        putNavAttributes(request, model);
        return "customer/mobileunlocking/orders";
    }

    @RequestMapping(value = "/pinless-commision-report", method = RequestMethod.GET)
    public String pinlessCommisionReport(HttpServletRequest request, Model model) {
        putNavAttributes(request, model);
        return "customer/pinlessCommisionReport";
    }

    @RequestMapping(value = "/eezeetel-pinless", method = RequestMethod.GET)
    public String eezeetelPinless() {
        return "customer/ED/eezeetelPinless";
    }

    public void putNavAttributes(HttpServletRequest request, Model model) {
        TCustomerUsers customerUser = customerUserService.findByLogin(request.getRemoteUser());
        TMasterCustomerinfo customer = customerUser.getCustomer();
        putNavAttributes(request, model, customer);
    }

    public void putNavAttributes(HttpServletRequest request, Model model, TMasterCustomerinfo customer) {
        model.addAttribute("style", request.getSession().getAttribute("STYLE"));
        if(customer == null) {
            model.addAttribute("customerInfo", new TMasterCustomerinfo());
            model.addAttribute("customerBalance", "0.00");
            model.addAttribute("balanceStyle", "topmenu_balance_less");
            return;
        }

        model.addAttribute("customerInfo", customer);
        Float customerBalance = customer.getCustomerBalance();
        model.addAttribute("customerBalance", new DecimalFormat("0.00").format((double) customerBalance));
        model.addAttribute("balanceStyle", customerBalance < 50.0 ? "topmenu_balance_less" : "topmenu_balance_normal");

        // cancel unconfirmed transactions
        Object transaction = request.getSession().getAttribute("TRANSACTION_ID");
        if (transaction != null) {
            Long transactionId = NumberUtils.toLong(transaction.toString());
            if (transactionId != 0L) {
                processTransaction.cancel(transactionId);
            }
            request.getSession().removeAttribute("TRANSACTION_ID");
        }
    }
}
