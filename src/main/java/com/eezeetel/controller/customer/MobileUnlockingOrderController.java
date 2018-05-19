package com.eezeetel.controller.customer;

import com.eezeetel.entity.MobileUnlockingOrder;
import com.eezeetel.entity.TCustomerUsers;
import com.eezeetel.service.CustomerUserService;
import com.eezeetel.service.MobileUnlockingOrderService;
import com.eezeetel.util.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

/**
 * Created by Denis Dulyak on 09.02.2016.
 */
@RestController("customerMobileUnlockingOrderController")
@RequestMapping(value = "/customer/mobile-unlocking-order")
public class MobileUnlockingOrderController {

    @Autowired
    private MobileUnlockingOrderService service;

    @Autowired
    private CustomerUserService customerUserService;

    @RequestMapping(value = "/get", method = RequestMethod.GET)
    public ResponseEntity<MobileUnlockingOrder> get(@RequestParam Integer id) {
        return ResponseEntity.ok(service.findOne(id));
    }

    @RequestMapping(value = "/find-between-dates", method = RequestMethod.GET)
    public ResponseEntity<List<MobileUnlockingOrder>> productSummary(HttpServletRequest request,
                                                                     @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDay,
                                                                     @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDay) {
        TCustomerUsers customerUser = customerUserService.findByLogin(request.getRemoteUser());
        if (customerUser == null) {
            return ResponseEntity.badRequest().body(Collections.emptyList());
        }
        return ResponseEntity.ok(service.findByCustomerAndCreatedDateBetween(customerUser.getCustomer(),
                DateUtil.getStartOfDay(startDay), DateUtil.getEndOfDay(endDay)));
    }
}
