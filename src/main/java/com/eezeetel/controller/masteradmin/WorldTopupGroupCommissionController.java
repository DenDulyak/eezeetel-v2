package com.eezeetel.controller.masteradmin;

import com.eezeetel.entity.WorldTopupGroupCommission;
import com.eezeetel.service.WorldTopupGroupCommissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by Denis Dulyak on 15.06.2016.
 */
@RestController("masterAdminWorldTopupGroupCommissionController")
@RequestMapping(value = "/masteradmin/world-topup-group-commission")
public class WorldTopupGroupCommissionController {

    @Autowired
    private WorldTopupGroupCommissionService service;

    @RequestMapping(value = "/find-by-country-and-group", method = RequestMethod.GET)
    public ResponseEntity<WorldTopupGroupCommission> findByCountryAndGroup(@RequestParam Integer countryId, @RequestParam Integer groupId) {
        return ResponseEntity.ok(service.findOrCreateByCountryIdAndGroupId(countryId, groupId));
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public ResponseEntity<WorldTopupGroupCommission> save(@RequestParam Integer countryId, @RequestParam Integer groupId, @RequestParam Integer percent) {
        WorldTopupGroupCommission commission = service.findOrCreateByCountryIdAndGroupId(countryId, groupId);
        commission.setPercent(percent);
        return ResponseEntity.ok(service.save(commission));
    }
}
