package com.eezeetel.controller.masteradmin;

import com.eezeetel.entity.Feature;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.enums.FeatureType;
import com.eezeetel.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.AbstractMap;
import java.util.List;

/**
 * Created by Denis Dulyak on 25.02.2016.
 */
@RestController("masterAdminCustomerController")
@RequestMapping(value = "/masteradmin/customer")
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    @RequestMapping(value = "/find-by-group", method = RequestMethod.GET)
    public ResponseEntity<List<AbstractMap.SimpleEntry<Integer, String>>> customersByGroup(@RequestParam(defaultValue = "0") Integer id) {
        if(id == 0) {
            return ResponseEntity.ok(customerService.convert(customerService.findAll(true)));
        }
        return ResponseEntity.ok(customerService.convert(customerService.findByGroup(new TMasterCustomerGroups(id))));
    }

    @RequestMapping(value = "/update-customer-features-by-group", method = RequestMethod.POST)
    public ResponseEntity<List<Feature>> updateCustomerFeaturesByGroup(@RequestParam Integer groupId, @RequestBody List<FeatureType> featureTypes) {
        return ResponseEntity.ok(customerService.updateCustomerFeaturesByGroup(groupId, featureTypes));
    }

    @RequestMapping(value = "/has-credit-limit", method = RequestMethod.GET)
    public ResponseEntity<Boolean> hasCreditLimit(@RequestParam Integer customerId) {
        TMasterCustomerinfo customer = customerService.findOne(customerId);
        return ResponseEntity.ok(
                customer != null ? customerService.hasFeature(customer, FeatureType.CREDIT_LIMIT) : false
        );
    }
}
