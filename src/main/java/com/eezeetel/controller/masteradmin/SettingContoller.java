package com.eezeetel.controller.masteradmin;

import com.eezeetel.entity.Setting;
import com.eezeetel.enums.SettingType;
import com.eezeetel.service.SettingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by Denis Dulyak on 23.11.2016.
 */
@RestController
@RequestMapping("/masteradmin/setting")
public class SettingContoller {

    @Autowired
    private SettingService service;

    @RequestMapping(value = "/find-by-type", method = RequestMethod.GET)
    public ResponseEntity<Setting> findByType(@RequestParam Integer type) {
        return ResponseEntity.ok(service.findByType(SettingType.values()[type]));
    }

    @RequestMapping(value = "/update-by-type", method = RequestMethod.POST)
    public ResponseEntity<Setting> updateByType(@RequestParam Integer type, @RequestParam String value) {
        return ResponseEntity.ok(service.updateValue(SettingType.values()[type], value));
    }
}
