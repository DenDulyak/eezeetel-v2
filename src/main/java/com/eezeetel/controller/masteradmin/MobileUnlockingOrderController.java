package com.eezeetel.controller.masteradmin;

import com.eezeetel.entity.MobileUnlockingOrder;
import com.eezeetel.service.MobileUnlockingOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by Denis Dulyak on 30.01.2016.
 */
@RestController
@RequestMapping(value = "/masteradmin/mobile-unlocking-order")
public class MobileUnlockingOrderController {

    @Autowired
    private MobileUnlockingOrderService service;

    @RequestMapping(value = "/find-by-status", method = RequestMethod.GET)
    public Page<MobileUnlockingOrder> findAll(Pageable pageable, @RequestParam Integer status) {
        return service.findByStatus(status, pageable);
    }

    @RequestMapping(value = "/get", method = RequestMethod.GET)
    public ResponseEntity<MobileUnlockingOrder> get(@RequestParam Integer id) {
        return ResponseEntity.ok(service.findOne(id));
    }

    @RequestMapping(value = "/assign", method = RequestMethod.POST)
    public ResponseEntity<MobileUnlockingOrder> assign(@RequestParam Integer orderId, @RequestParam String login) {
        return ResponseEntity.ok(service.assign(orderId, login));
    }
}
