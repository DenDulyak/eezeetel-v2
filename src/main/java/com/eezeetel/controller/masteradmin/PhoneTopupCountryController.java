package com.eezeetel.controller.masteradmin;

import com.eezeetel.entity.PhoneTopupCountry;
import com.eezeetel.service.PhoneTopupCountryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Created by Denis Dulyak on 13.06.2016.
 */
@RestController("masterAdminPhoneTopupCountryController")
@RequestMapping(value = "/masteradmin/phone-topup-country")
public class PhoneTopupCountryController {

    @Autowired
    private PhoneTopupCountryService service;

    @RequestMapping(value = "/find-all", method = RequestMethod.GET)
    public ResponseEntity<List<PhoneTopupCountry>> findAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @RequestMapping(value = "/find-one", method = RequestMethod.GET)
    public ResponseEntity<PhoneTopupCountry> findOne(@RequestParam Integer id) {
        return ResponseEntity.ok(service.findOne(id));
    }
}
