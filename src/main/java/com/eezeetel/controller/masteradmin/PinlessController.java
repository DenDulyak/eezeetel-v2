package com.eezeetel.controller.masteradmin;

import com.eezeetel.entity.PinlessTransaction;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.mobitopup.MobitopupMethod;
import com.eezeetel.mobitopup.response.MobitopupResponse;
import com.eezeetel.service.PinlessTransactionService;
import com.eezeetel.util.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;

import static com.eezeetel.mobitopup.MobitopupUtil.validate;

@RestController("masteradminPinlessController")
@RequestMapping(value = "/masteradmin/pinless")
public class PinlessController {

    @Autowired
    private PinlessTransactionService service;

    @Autowired
    private MobitopupMethod mobitopupMethod;

    @RequestMapping(value = "/find", method = RequestMethod.GET)
    public ResponseEntity<List<PinlessTransaction>> find(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDay,
                                                         @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDay,
                                                         @RequestParam(defaultValue = "0") Integer groupId) {
        return ResponseEntity.ok(service.findByGroupAndDate(0, new TMasterCustomerGroups(groupId), DateUtil.getStartOfDay(startDay), DateUtil.getEndOfDay(endDay)));
    }

    @RequestMapping(value = "/get-balance", method = RequestMethod.GET)
    public ResponseEntity<MobitopupResponse> getBalance() {
        return ResponseEntity.ok(validate(mobitopupMethod.getPinlessBalance()));
    }
}
