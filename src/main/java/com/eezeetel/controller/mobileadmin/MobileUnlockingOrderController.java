package com.eezeetel.controller.mobileadmin;

import com.eezeetel.entity.MobileUnlockingOrder;
import com.eezeetel.service.MobileUnlockingOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * Created by Denis Dulyak on 04.02.2016.
 */
@RestController("mobileaAdminMobileUnlockingOrderController")
@RequestMapping(value = "/mobileadmin/mobile-unlocking-order")
public class MobileUnlockingOrderController {

    @Autowired
    private MobileUnlockingOrderService mobileUnlockingOrderService;

    @RequestMapping(value = "/reject", method = RequestMethod.POST)
    public ResponseEntity<MobileUnlockingOrder> assign(@RequestParam Integer orderId) {
        return ResponseEntity.ok(mobileUnlockingOrderService.reject(orderId));
    }

    @RequestMapping(value = "/get", method = RequestMethod.GET)
    public ResponseEntity<MobileUnlockingOrder> get(@RequestParam Integer id) {
        return ResponseEntity.ok(mobileUnlockingOrderService.findOne(id));
    }

    @RequestMapping(value = "/edit", method = RequestMethod.POST)
    public ResponseEntity<MobileUnlockingOrder> edit(@ModelAttribute MobileUnlockingOrder order) {
        return ResponseEntity.ok(mobileUnlockingOrderService.editOrder(order));
    }
}
