package com.eezeetel.controller.customer;

import com.eezeetel.bean.ConfirmBean;
import com.eezeetel.bean.customer.Transaction;
import com.eezeetel.entity.*;
import com.eezeetel.service.*;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Created by Denis Dulyak on 12.10.2015.
 */
@RestController
@RequestMapping("/customer")
public class TransactionController {

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private SimTransactionService simTransactionService;

    @Autowired
    private CustomerUserService customerUserService;

    @Autowired
    private ProductService productService;

    @Autowired
    private DingTransactionService dingTransactionService;

    @Autowired
    private MobitopupTransactionService mobitopupTransactionService;

    @RequestMapping(value = "/transactions-by-day", method = RequestMethod.GET)
    public List<Transaction> getTransactionsByDay(HttpServletRequest request,
                                                  @RequestParam(defaultValue = "transaction") String type,
                                                  @RequestParam(defaultValue = "") String day) throws ParseException {
        List<Transaction> result = null;
        SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy");
        Integer customerId = customerUserService.findByLogin(request.getRemoteUser()).getCustomer().getId();
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.HOUR, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        if (day.isEmpty()) {
            calendar.setTime(new Date());
        } else {
            calendar.setTime(format.parse(day));
        }
        Date nextDay = DateUtils.addDays(calendar.getTime(), 1);
        switch (type) {
            case "transaction":
                result = transactionService.getTransactionsByCustomerAndDate(customerId, calendar.getTime(), nextDay);
                if (!result.isEmpty()) {
                    for (Transaction transaction : result) {
                        List<TTransactions> transactions = transactionService.findByTransactionId(transaction.getTransactionId());
                        if (!transactions.isEmpty()) {
                            transaction.setProducts(transactions.stream().map(t -> t.getProduct().getProductName()).collect(Collectors.toList()));
                        }
                    }
                }
                break;
            case "sim":
                result = transactionService.getSimTransactionsByCustomerAndDate(customerId, calendar.getTime(), nextDay);
                if (!result.isEmpty()) {
                    for (Transaction transaction : result) {
                        List<TSimTransactions> simTransactions = simTransactionService.findByTransactionId(transaction.getTransactionId());
                        if (!simTransactions.isEmpty()) {
                            transaction.setProducts(simTransactions.stream().map(st -> st.getSimCard().getProduct().getProductName()).collect(Collectors.toList()));
                        }
                    }
                }
                break;
            case "transfer":
                result = transactionService.getTransfertoTransactionsByCustomerAndDate(customerId, calendar.getTime(), nextDay);
                List<TDingTransactions> dingTransactions = dingTransactionService.findByErrorCodeAndCustomerAndTransactionTimeBetween(1, new TMasterCustomerinfo(customerId), calendar.getTime(), nextDay);
                List<MobitopupTransaction> mTransactions = mobitopupTransactionService.findByCustomerAndTransactionTime(new TMasterCustomerinfo(customerId), calendar.getTime(), nextDay);
                result.addAll(dingTransactions.stream().map(Transaction::new).collect(Collectors.toList()));
                result.addAll(mTransactions.stream().map(Transaction::new).collect(Collectors.toList()));
                break;
        }
        return result;
    }

    @RequestMapping(value = "/reprint-transaction", method = RequestMethod.GET)
    public ConfirmBean reprintTransaction(@RequestParam Long transactionId) {
        return productService.getPrintTransactionInfo(transactionId);
    }
}
