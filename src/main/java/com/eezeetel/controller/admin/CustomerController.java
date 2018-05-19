package com.eezeetel.controller.admin;

import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.User;
import com.eezeetel.enums.FeatureType;
import com.eezeetel.service.CustomerService;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.AbstractMap;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Created by Denis Dulyak on 23.09.2015.
 */
@RestController("adminCustomerController")
@RequestMapping(value = "/admin/customer")
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    @RequestMapping(value = "/find-by-user", method = RequestMethod.GET)
    public ResponseEntity<List<TMasterCustomerinfo>> findByUser(HttpServletRequest request, @RequestParam String login) {
        Integer groupId = NumberUtils.toInt(request.getSession().getAttribute("GROUP_ID") + "");
        List<TMasterCustomerinfo> customers = customerService.findByGroupAndIntroducedBy(new TMasterCustomerGroups(groupId), new User(login));
        customers.sort(Comparator.comparing(TMasterCustomerinfo::getCompanyName));
        return ResponseEntity.ok(customers);
    }

    @RequestMapping(value = "/has-credit-limit", method = RequestMethod.GET)
    public ResponseEntity<Boolean> hasCreditLimit(@RequestParam Integer customerId) {
        TMasterCustomerinfo customer = customerService.findOne(customerId);

        if (customer != null) {
            return ResponseEntity.ok(customerService.hasFeature(customer, FeatureType.CREDIT_LIMIT));
        }

        return ResponseEntity.ok(Boolean.FALSE);
    }

    @RequestMapping(value = "/find-group-customers", method = RequestMethod.GET)
    public ResponseEntity<List<AbstractMap.SimpleEntry<Integer, String>>> findGroupCustomers(HttpSession session) {
        Integer groupId = NumberUtils.toInt(session.getAttribute("GROUP_ID") + "");
        return ResponseEntity.ok(customerService.convert(customerService.findByGroup(new TMasterCustomerGroups(groupId))));
    }

    @RequestMapping(value = "/find-by-agent", method = RequestMethod.GET)
    public ResponseEntity<Map<Integer, String>> findByAgent(HttpServletRequest request, @RequestParam String agent) {
        Integer groupId = NumberUtils.toInt(request.getSession().getAttribute("GROUP_ID") + "");
        List<TMasterCustomerinfo> customers = customerService.findByGroupAndIntroducedBy(new TMasterCustomerGroups(groupId), new User(agent));
        customers.sort(Comparator.comparing(TMasterCustomerinfo::getCompanyName));
        return ResponseEntity.ok(customers.stream().collect(Collectors.toMap(TMasterCustomerinfo::getId, TMasterCustomerinfo::getCompanyName)));
    }
}
