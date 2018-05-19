package com.eezeetel.controller.masteradmin;

import com.eezeetel.entity.TBatchInformation;
import com.eezeetel.service.BatchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;

/**
 * Created by Denis Dulyak on 26.11.2015.
 */
@RestController
@RequestMapping("/masteradmin/batch")
public class BatchController {

    @Autowired
    private BatchService service;

    @RequestMapping(value = "/retune-cards-stock", method = RequestMethod.GET)
    public List<TBatchInformation> retuneCardsStock(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate start,
                                                    @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate end) {
        return service.getBatchForRetuneCardsStock(start, end);
    }
}
