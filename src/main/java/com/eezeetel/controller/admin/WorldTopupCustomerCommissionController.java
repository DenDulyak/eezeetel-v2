package com.eezeetel.controller.admin;

import com.eezeetel.entity.WorldTopupCustomerCommission;
import com.eezeetel.service.WorldTopupCustomerCommissionService;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;

/**
 * Created by Denis Dulyak on 13.07.2016.
 */
@RestController("adminWorldTopupCustomerCommissionController")
@RequestMapping(value = "/admin/world-topup-customer-commission")
public class WorldTopupCustomerCommissionController {

    @Autowired
    private WorldTopupCustomerCommissionService service;

    @RequestMapping(value = "/find-by-country-and-customer", method = RequestMethod.GET)
    public ResponseEntity<WorldTopupCustomerCommission> findByCountryAndGroup(HttpSession session, @RequestParam Integer countryId, @RequestParam Integer customerId) {
        Integer groupId = NumberUtils.toInt(session.getAttribute("GROUP_ID") + "");
        return ResponseEntity.ok(service.findOrCreateByCountryIdAndGroupIdAndCustomerId(countryId, groupId, customerId));
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public ResponseEntity<WorldTopupCustomerCommission> save(HttpSession session,
                                                             @RequestParam Integer countryId, @RequestParam Integer customerId,
                                                             @RequestParam Integer groupPercent, @RequestParam Integer agentPercent) {
        Integer groupId = NumberUtils.toInt(session.getAttribute("GROUP_ID") + "");
        WorldTopupCustomerCommission commission = service.findOrCreateByCountryIdAndGroupIdAndCustomerId(countryId, groupId, customerId);
        commission.setAgentPercent(agentPercent);
        commission.setGroupPercent(groupPercent);
        return ResponseEntity.ok(service.save(commission));
    }
}
