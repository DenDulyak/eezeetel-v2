package com.eezeetel.controller.customer;

import com.eezeetel.service.PinlessTransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.time.LocalDate;
import java.util.Map;

@RestController
@RequestMapping("/customer/pinless")
public class PinlessController {

    @Autowired
    private PinlessTransactionService service;

    @RequestMapping(value = "/month-transactions", method = RequestMethod.GET)
    public Map<String, Double> monthTransactions(Principal principal, @RequestParam @DateTimeFormat(pattern = "dd-MM-yyyy") LocalDate month) {
        return service.getMonthTransactions(month, principal.getName());
    }
}
