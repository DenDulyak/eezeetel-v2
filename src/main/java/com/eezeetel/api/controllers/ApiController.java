package com.eezeetel.api.controllers;

import com.eezeetel.api.responses.BaseResponse;
import com.eezeetel.api.responses.Product;
import com.eezeetel.api.responses.ProductResponse;
import com.eezeetel.api.responses.PurchaseResporse;
import com.eezeetel.api.services.ApiService;
import lombok.extern.log4j.Log4j;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Objects;

@Log4j
@RestController
@RequestMapping("/api")
public class ApiController {

    @Autowired
    private ApiService service;

    @RequestMapping(value = "/balance", method = RequestMethod.GET)
    public ResponseEntity<BaseResponse> balance(@RequestParam(required = false, defaultValue = "") String login,
                                                @RequestParam(required = false) Long key,
                                                @RequestParam(required = false) String md5) {
        return ResponseEntity.ok(service.getBalance(login, key, md5));
    }

    @RequestMapping(value = "/suppliers", method = RequestMethod.GET)
    public ResponseEntity<ProductResponse<Product>> suppliers(@RequestParam(required = false, defaultValue = "") String login,
                                                              @RequestParam(required = false) Long key,
                                                              @RequestParam(required = false) String md5) {
        return ResponseEntity.ok(service.getSuppliers(login, key, md5));
    }

    @RequestMapping(value = "/products", method = RequestMethod.GET)
    public ResponseEntity<ProductResponse<Product>> products(@RequestParam(required = false, defaultValue = "") String login,
                                                             @RequestParam(required = false) Long key,
                                                             @RequestParam(required = false) String md5,
                                                             @RequestParam(required = false) Integer supplierId) {
        return ResponseEntity.ok(service.getProducts(login, key, md5, supplierId));
    }

    @RequestMapping(value = "/purchase", method = RequestMethod.GET)
    public ResponseEntity<PurchaseResporse> purchase(@RequestParam(required = false, defaultValue = "") String login,
                                                     @RequestParam(required = false) Long key,
                                                     @RequestParam(required = false) String md5,
                                                     @RequestParam(required = false, defaultValue = "0") Integer productId) {
        if(Objects.equals(login, "eezeedemo")) {
            return ResponseEntity.ok(service.purchasetest(login, key, md5, productId));
        }

        return ResponseEntity.ok(service.purchase(login, key, md5, productId));
    }

    @RequestMapping(value = "/purchase", method = RequestMethod.POST)
    public ResponseEntity<PurchaseResporse> purchasePost(@RequestBody(required = false) Map<String, String> data) {
        String login = "";
        Long key = null;
        String md5 = null;
        Integer productId = 0;
        if (data != null && !data.isEmpty()) {
            login = data.get("login");
            key = NumberUtils.toLong(data.get("key"));
            md5 = data.get("md5");
            productId = NumberUtils.toInt(data.get("productId"));
            if(login == null) login = "";
            if(key == 0L) key = null;
        }

        if(Objects.equals(login, "eezeedemo")) {
            return ResponseEntity.ok(service.purchasetest(login, key, md5, productId));
        }

        return ResponseEntity.ok(service.purchase(login, key, md5, productId));
    }
}
