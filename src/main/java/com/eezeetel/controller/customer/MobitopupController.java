package com.eezeetel.controller.customer;

import com.eezeetel.entity.MobitopupTransaction;
import com.eezeetel.entity.TCustomerUsers;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.mobitopup.MobitopupMethod;
import com.eezeetel.mobitopup.MobitopupUtil;
import com.eezeetel.mobitopup.response.*;
import com.eezeetel.service.CustomerUserService;
import com.eezeetel.service.MobitopupTransactionService;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.util.Collections;
import java.util.List;

import static com.eezeetel.mobitopup.MobitopupUtil.validate;

/**
 * Created by Denis Dulyak on 22.03.2016.
 */
@RestController
@RequestMapping(value = "/customer/mobitopup")
public class MobitopupController {

    @Autowired
    private MobitopupMethod mobitopupMethod;

    @Autowired
    private MobitopupTransactionService transactionService;

    @Autowired
    private CustomerUserService customerUserService;

    @RequestMapping(value = "/get-balance", method = RequestMethod.GET)
    public ResponseEntity<MobitopupResponse> getBalance() {
        return ResponseEntity.ok(validate(mobitopupMethod.getBalance()));
    }

    @RequestMapping(value = "/get-countries", method = RequestMethod.GET)
    public ResponseEntity<MobitopupResponse> getCountries() {
        Country response = mobitopupMethod.getCountries();
        if (StringUtils.isNotEmpty(response.getCountries())) {
            response.setCountryList(MobitopupUtil.toMap(response.getCountries()));
        }
        return ResponseEntity.ok(validate(response));
    }

    @RequestMapping(value = "/get-networks", method = RequestMethod.GET)
    public ResponseEntity<Network> getNetworks(@RequestParam Integer countryId) {
        Network response = mobitopupMethod.getNetworks(countryId);
        if (response != null && StringUtils.isNotEmpty(response.getNetworks())) {
            response.setNetworkList(MobitopupUtil.toMap(response.getNetworks()));
        }
        return ResponseEntity.ok(validate(response));
    }

    @RequestMapping(value = "/get-tickets", method = RequestMethod.GET)
    public ResponseEntity<Ticket> getTickets(@RequestParam Integer networkId) {
        return ResponseEntity.ok(validate(mobitopupMethod.getTickets(networkId)));
    }

    @RequestMapping(value = "/check-number", method = RequestMethod.GET)
    public ResponseEntity<CheckNumber> checkNumber(@RequestParam String number) {
        return ResponseEntity.ok(validate(mobitopupMethod.checkNumber(number)));
    }

    @RequestMapping(value = "/topup", method = RequestMethod.POST)
    public ResponseEntity<MobitopupTransaction> topup(@RequestParam String destnumber, @RequestParam String srcnumber,
                                                      @RequestParam String product, @RequestParam String message,
                                                      Principal principal) {
        return ResponseEntity.ok(transactionService.topup(destnumber, srcnumber, product, message, principal.getName()));
    }

    @RequestMapping(value = "/find-by-number", method = RequestMethod.GET)
    public ResponseEntity<List<MobitopupTransaction>> findByNumber(Principal principal, @RequestParam String requesterPhone) {
        //return ResponseEntity.ok(transactionService.findByRequesterPhone(principal.getName(), 0, requesterPhone));
        return ResponseEntity.ok(Collections.emptyList());
    }

    @RequestMapping(value = "/repeat", method = RequestMethod.POST)
    public ResponseEntity<MobitopupTransaction> repeat(@RequestParam Integer id, Principal principal) {
        MobitopupTransaction transaction = transactionService.findOne(id);
        return ResponseEntity.ok(transactionService.topup(transaction.getDestinationPhone(), transaction.getRequesterPhone(),
                transaction.getProductRequested(), "", principal.getName()));
    }

    @RequestMapping(value = "/ottxbalance", method = RequestMethod.GET)
    public ResponseEntity<MobitopupResponse> ottxBalance(Principal principal, @RequestParam String number, @RequestParam String product) {
        TCustomerUsers customerUser = customerUserService.findByLogin(principal.getName());
        TMasterCustomerinfo customer = customerUser.getCustomer();

        if(!NumberUtils.isNumber(product)) {
            return ResponseEntity.ok(new Balance(10, "Incorrect ticket."));
        }
        if(customer.getCustomerBalance() <= 0 || customer.getCustomerBalance() < NumberUtils.toFloat(product)) {
            return ResponseEntity.ok(new Balance(10, "Your balance is low. Please request a topup as soon as possible."));
        }

        return ResponseEntity.ok(validate(mobitopupMethod.ottxBalance(number)));
    }

    @RequestMapping(value = "/check-number-v2", method = RequestMethod.GET)
    public ResponseEntity<CheckNumber> checkNumberV2(Principal principal, @RequestParam String number) {
        return ResponseEntity.ok(validate(transactionService.checkNumberV2(principal.getName(), number)));
    }

    @RequestMapping(value = "/topup-v2", method = RequestMethod.POST)
    public ResponseEntity<?> topupV2(Principal principal, @RequestParam String destnumber, @RequestParam String product) {
        try {
            return ResponseEntity.ok(transactionService.topupV2(destnumber, "2222222222", product, "", principal.getName()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE).body(e.getMessage());
        }
    }
}
