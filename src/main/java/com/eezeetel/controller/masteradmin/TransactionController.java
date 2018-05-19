package com.eezeetel.controller.masteradmin;

import com.eezeetel.bean.report.TransactionReportBean;
import com.eezeetel.entity.TCardInfo;
import com.eezeetel.entity.TTransactions;
import com.eezeetel.service.CardService;
import com.eezeetel.service.TransactionService;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * Created by Denis Dulyak on 07.12.2016.
 */
@RestController("masteradminTransactionController")
@RequestMapping("/masteradmin/transaction")
public class TransactionController {

    @Autowired
    private TransactionService service;

    @Autowired
    private CardService cardService;

    @RequestMapping(value = "/find-by-batch", method = RequestMethod.GET)
    public List<TTransactions> transactionsByBatchId(@RequestParam Integer id) {
        return service.findByBatch(id, true);
    }

    @RequestMapping(value = "/sales-retune", method = RequestMethod.GET)
    public List<TTransactions> salesRetune(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate start,
                                           @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate end) {
        return service.getSalesRetune(start, end);
    }

    @RequestMapping(value = "/find-by-card-pin", method = RequestMethod.GET)
    public ResponseEntity findByCardPin(@RequestParam String pin) {
        TCardInfo card = cardService.findByCardPin(pin);

        if (card == null) {
            return ResponseEntity.status(HttpStatus.ACCEPTED).body(JSONObject.quote("Card with PIN - '" + pin + "' not found."));
        }

        if (!card.getIsSold()) {
            return ResponseEntity.status(HttpStatus.ACCEPTED).body(JSONObject.quote("Card isn't sold yet."));
        }

        return ResponseEntity.status(HttpStatus.OK).body(service.findByCard(card));
    }

    @RequestMapping(value = "/product-transactions-report", method = RequestMethod.GET)
    public List<TransactionReportBean> productTransactionsReport(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate start,
                                                                 @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate end,
                                                                 @RequestParam Integer productId) {
        return service.findByProductIdAndDates(productId, start, end);
    }

    @RequestMapping(value = "/summary-by-batch", method = RequestMethod.GET)
    public Map<Integer, Map<String, Map.Entry<Integer, Integer>>> summaryReportByBatch(@RequestParam Integer id) {
        return service.getSummaryReportByBatch(id);
    }
}
