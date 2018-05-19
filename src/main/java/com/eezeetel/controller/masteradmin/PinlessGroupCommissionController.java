package com.eezeetel.controller.masteradmin;

import com.eezeetel.entity.PinlessGroupCommission;
import com.eezeetel.service.PinlessGroupCommissionService;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping(value = "/masteradmin/pinless-group-commission")
public class PinlessGroupCommissionController {

    @Autowired
    private PinlessGroupCommissionService service;

    @RequestMapping(value = "/find-by-group", method = RequestMethod.GET)
    public ResponseEntity<PinlessGroupCommission> findByGroup(@RequestParam Integer groupId) {
        return ResponseEntity.ok(service.findByGroupId(groupId));
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public ResponseEntity<PinlessGroupCommission> save(@RequestBody Map<String, String> data) {
        return ResponseEntity.ok(service.update(
                NumberUtils.toInt(data.get("groupId")), NumberUtils.toInt(data.get("percent"))));
    }
}
