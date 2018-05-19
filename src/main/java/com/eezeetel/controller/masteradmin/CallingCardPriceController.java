package com.eezeetel.controller.masteradmin;

import com.eezeetel.bean.masteradmin.CallingCardPriceBean;
import com.eezeetel.entity.CallingCardPrice;
import com.eezeetel.entity.Title;
import com.eezeetel.enums.TitleType;
import com.eezeetel.service.CallingCardPriceService;
import com.eezeetel.service.TitleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * Created by Denis Dulyak on 07.03.2016.
 */
@RestController
@RequestMapping("/masteradmin/calling-card-price")
public class CallingCardPriceController {

    @Autowired
    private CallingCardPriceService callingCardPriceService;

    @Autowired
    private TitleService titleService;

    @RequestMapping(value = "/find-all", method = RequestMethod.GET)
    public Page<CallingCardPrice> findAll(Pageable pageable) {
        return callingCardPriceService.findAll(pageable);
    }

    @RequestMapping(value = "/get", method = RequestMethod.GET)
    public ResponseEntity<CallingCardPrice> get(@RequestParam Integer id) {
        return ResponseEntity.ok(callingCardPriceService.findOne(id));
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public ResponseEntity<CallingCardPrice> save(@ModelAttribute CallingCardPriceBean bean) {
        return ResponseEntity.ok(callingCardPriceService.createOrUpdate(bean));
    }

    @RequestMapping(value = "/delete", method = RequestMethod.GET)
    public void delete(@RequestParam Integer id) {
        callingCardPriceService.delete(id);
    }

    @RequestMapping(value = "/get-title", method = RequestMethod.GET)
    public ResponseEntity<Title> getTitle() {
        return ResponseEntity.ok(titleService.findByType(TitleType.CALLING_CARDS_PRICES));
    }

    @RequestMapping(value = "/update-title", method = RequestMethod.POST)
    public ResponseEntity<Title> updateTitle(@RequestParam String title) {
        return ResponseEntity.ok(titleService.updateByType(TitleType.CALLING_CARDS_PRICES, title));
    }
}
