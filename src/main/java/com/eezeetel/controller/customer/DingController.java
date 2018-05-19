package com.eezeetel.controller.customer;

import com.ding.DingMain;
import com.eezeetel.entity.TCustomerUsers;
import com.eezeetel.entity.TDingTransactions;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.service.CustomerUserService;
import com.eezeetel.service.DingTransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.ServletContext;
import java.security.Principal;
import java.util.Collections;
import java.util.List;

/**
 * Created by Denis Dulyak on 08.06.2016.
 */
@RestController
@RequestMapping(value = "/customer/ding")
public class DingController {

    @Autowired
    private DingTransactionService service;

    @Autowired
    private CustomerUserService customerUserService;

    @Autowired
    private ServletContext context;

    @RequestMapping(value = "/find-by-number", method = RequestMethod.GET)
    public ResponseEntity<List<TDingTransactions>> findByNumber(Principal principal, @RequestParam String requesterPhone) {
        //return ResponseEntity.ok(service.findByRequesterPhone(principal.getName(), 1, requesterPhone));
        return ResponseEntity.ok(Collections.emptyList());
    }

    @RequestMapping(value = "/repeat", method = RequestMethod.POST)
    public ResponseEntity<DingMain.TopupResponse> repeat(@RequestParam Long id, Principal principal) {
        DingMain.TopupResponse response = new DingMain.TopupResponse();

        TDingTransactions transaction = service.findOne(id);

        TCustomerUsers customerUser = customerUserService.findByLogin(principal.getName());
        TMasterCustomerinfo custInfo = customerUser.getCustomer();
        TMasterCustomerGroups custGroup = custInfo.getGroup();
        float fAvailableBalance = custInfo.getCustomerBalance();
        Boolean enoughBalance = false;

        if (fAvailableBalance > transaction.getCostToCustomer()) {
            if (custGroup.getCheckAganinstGroupBalance()) {
                if (custGroup.getCustomerGroupBalance() > 500) {
                    enoughBalance = true;
                }
            } else {
                enoughBalance = true;
            }
        }

        if (enoughBalance) {
            DingMain dingService = new DingMain(custInfo.getId(), principal.getName());

            DingMain.PhoneNumberDetails phoneNumberDetail = dingService.GetDetailsForPhoneNumber(transaction.getDestinationPhone(), null, null);
            response = dingService.PerformTopUpOperation(transaction.getDestinationPhone(), transaction.getRequesterPhone(),
                    transaction.getDestinationCountryId(), transaction.getDestinationOperatorId(),
                    transaction.getSmsText(), transaction.getProductRequested(), phoneNumberDetail.isRangeOperator, context);
        }

        return ResponseEntity.ok(response);
    }
}
