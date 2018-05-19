package com.eezeetel.controller.masteradmin;

import com.ding.DingMain;
import com.eezeetel.entity.TDingTransactions;
import com.eezeetel.service.DingService;
import com.eezeetel.service.DingTransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;

/**
 * Created by Denis Dulyak on 22.08.2016.
 */
@RestController("masterAdminDingController")
@RequestMapping(value = "/masteradmin/ding")
public class DingController {

    @Autowired
    private DingService dingService;

    @Autowired
    private DingTransactionService dingTransactionService;

    @RequestMapping(value = "/get-balance", method = RequestMethod.GET)
    public ResponseEntity<Float> getBalance() {
        DingMain dingMain = new DingMain(1, "");
        return ResponseEntity.ok(dingMain.GetBalance());
    }

    @RequestMapping(value = "/get-products-by-iso", method = RequestMethod.GET)
    public ResponseEntity<List<DingMain.ProductDetails>> getProductsByIso(@RequestParam String iso) {
        DingMain dingMain = new DingMain(1, "");
        return ResponseEntity.ok(dingMain.getProductsByCountryISO(iso));
    }

    @RequestMapping(value = "/get-tickets", method = RequestMethod.GET)
    public ResponseEntity<List<DingMain.AmountsAndCommission>> getTickets(@RequestParam String iso, @RequestParam Integer groupId) {
        return ResponseEntity.ok(dingService.getTickets(iso, groupId));
    }

    @RequestMapping(value = "/get-tickets-by-operator", method = RequestMethod.GET)
    public ResponseEntity<List<DingMain.AmountsAndCommission>> getTicketsByOperator(@RequestParam Integer countryId, @RequestParam String operatorCode, @RequestParam Integer groupId) {
        return ResponseEntity.ok(dingService.getTicketsByOperator(countryId, operatorCode, groupId));
    }

    @RequestMapping(value = "/get-operators", method = RequestMethod.GET)
    public ResponseEntity<List<DingMain.OperatorDetails>> getOperators(@RequestParam String iso) {
        DingMain dingMain = new DingMain(1, "");
        return ResponseEntity.ok(dingMain.getOperators(iso));
    }

    @RequestMapping(value = "/transactions-by-day", method = RequestMethod.GET)
    public ResponseEntity<List<TDingTransactions>> transactionsBetweenDays(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDay,
                                                                           @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDay,
                                                                           @RequestParam Integer groupId, @RequestParam Integer type) {
        return ResponseEntity.ok(dingTransactionService.findTransactionsBetweenDays(startDay, endDay, groupId, type));
    }
}
