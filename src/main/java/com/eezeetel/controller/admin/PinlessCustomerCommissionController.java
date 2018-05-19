package com.eezeetel.controller.admin;

import com.eezeetel.entity.PinlessCustomerCommission;
import com.eezeetel.service.PinlessCustomerCommissionService;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.Map;

@RestController
@RequestMapping(value = "/admin/pinless-customer-commission")
public class PinlessCustomerCommissionController {

    @Autowired
    private PinlessCustomerCommissionService service;

    @RequestMapping(value = "/find-by-customer", method = RequestMethod.GET)
    public ResponseEntity<PinlessCustomerCommission> findByGroup(HttpSession session, @RequestParam Integer customerId) {
        Integer groupId = NumberUtils.toInt(session.getAttribute("GROUP_ID") + "");
        return ResponseEntity.ok(service.findByCustomerId(groupId, customerId));
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public ResponseEntity<PinlessCustomerCommission> save(@RequestBody Map<String, String> data) {
        return ResponseEntity.ok(service.update(NumberUtils.toInt(data.get("customerId")),
                NumberUtils.toInt(data.get("groupPercent")), NumberUtils.toInt(data.get("agentPercent"))));
    }

    @RequestMapping(value = "/copy", method = RequestMethod.POST)
    public ResponseEntity<Boolean> copy(@RequestBody Map<String, Object> data) {
        Integer customerIdFrom = NumberUtils.toInt(data.get("customerIdFrom") + "");
        Integer customerIdTo = NumberUtils.toInt(data.get("customerIdTo") + "", -1);
        Boolean groupCommission = (Boolean) data.getOrDefault("copyGropuCommission", false);
        Boolean agentCommission = (Boolean) data.getOrDefault("copyAgentCommission", false);
        if (customerIdFrom == 0 || customerIdTo < 0 || (!groupCommission && !agentCommission)) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(false);
        }
        service.copy(customerIdFrom, customerIdTo, groupCommission, agentCommission);
        return ResponseEntity.ok(true);
    }
}
