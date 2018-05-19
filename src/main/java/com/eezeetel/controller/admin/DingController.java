package com.eezeetel.controller.admin;

import com.ding.DingMain;
import com.eezeetel.service.DingService;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * Created by Denis Dulyak on 05.09.2016.
 */
@RestController("adminDingController")
@RequestMapping(value = "/admin/ding")
public class DingController {

    @Autowired
    private DingService dingService;

    @RequestMapping(value = "/get-tickets", method = RequestMethod.GET)
    public ResponseEntity<List<DingMain.AmountsAndCommission>> getTickets(HttpSession session, @RequestParam String iso, @RequestParam Integer customerId) {
        Integer groupId = NumberUtils.toInt(session.getAttribute("GROUP_ID") + "");
        return ResponseEntity.ok(dingService.getTickets(iso, groupId, customerId));
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
}
