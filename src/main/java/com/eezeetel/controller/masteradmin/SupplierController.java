package com.eezeetel.controller.masteradmin;

import com.eezeetel.entity.TMasterSupplierinfo;
import com.eezeetel.service.SupplierService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Created by Denis Dulyak on 20.10.2016.
 */
@RestController
@RequestMapping("/masteradmin/supplier")
public class SupplierController {

    @Autowired
    private SupplierService supplierService;

    @RequestMapping(value = "/find-all", method = RequestMethod.GET)
    public ResponseEntity<List<TMasterSupplierinfo>> findAll() {
        return ResponseEntity.ok(supplierService.findActiveAndOrderByName());
    }
}
