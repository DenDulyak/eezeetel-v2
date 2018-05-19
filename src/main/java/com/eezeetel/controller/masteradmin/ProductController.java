package com.eezeetel.controller.masteradmin;

import com.eezeetel.entity.TMasterProductinfo;
import com.eezeetel.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.List;

/**
 * Created by Denis Dulyak on 20.10.2016.
 */
@RestController("masterAdminProductController")
@RequestMapping("/masteradmin/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    @RequestMapping(value = "/find", method = RequestMethod.GET)
    public ResponseEntity<List<TMasterProductinfo>> findBySupplier(@RequestParam Integer supplierId) {
        return ResponseEntity.ok(
                supplierId > 0 ?
                        productService.findBySupplierId(supplierId) :
                        productService.findAllActive()
        );
    }

    @RequestMapping(value = "/update-cost-price", method = RequestMethod.GET)
    public ResponseEntity<TMasterProductinfo> updateCostPrice(@RequestParam Integer id, @RequestParam BigDecimal costPrice) {
        TMasterProductinfo product = productService.findOne(id);
        Assert.notNull(product, "Product with id - " + id + " not found.");

        product.setCostPrice(costPrice);
        return ResponseEntity.ok(productService.save(product));
    }
}
