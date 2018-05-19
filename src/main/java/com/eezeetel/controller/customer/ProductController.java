package com.eezeetel.controller.customer;

import com.eezeetel.bean.ConfirmBean;
import com.eezeetel.bean.ProductBean;
import com.eezeetel.service.ProductService;
import lombok.extern.log4j.Log4j;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * Created by Denis Dulyak on 07.09.2015.
 */
@Log4j
@RestController
@RequestMapping("/customer")
public class ProductController {

    @Autowired
    private ProductService productService;

    @RequestMapping(value = "/products-by-supplier/{supplierId}", method = RequestMethod.GET)
    public ResponseEntity<List<ProductBean>> productsBySupplier(@PathVariable Integer supplierId) {
        List<ProductBean> products = productService.getProductsBySupplier(supplierId);
        products.forEach(p -> {
            String img = p.getImg();
            if (img != null && img.contains("Product_Images")) {
                p.setImg(img.replace("Product_Images", "images"));
            }
        });
        return ResponseEntity.ok(products);
    }

    @RequestMapping(value = "/process", method = RequestMethod.POST)
    public ResponseEntity<ConfirmBean> process(HttpServletRequest request, @RequestParam String products) {
        return ResponseEntity.ok(productService.process(request, Arrays.asList(products.split("-")),""));
    }

    @RequestMapping(value = "/confirm", method = RequestMethod.POST)
    public ResponseEntity<ConfirmBean> confirm(HttpSession session) {
        ConfirmBean bean = new ConfirmBean();
        bean.setSuccess(false);
        Object transaction = session.getAttribute("TRANSACTION_ID");
        if (transaction != null) {
            Long transactionId = NumberUtils.toLong(transaction.toString());
            session.removeAttribute("TRANSACTION_ID");
            if (transactionId != 0L) {
                bean = productService.confirm(transactionId, false);
            }
        } else {
            bean.setMessage("Transaction not found.");
            log.info("Transaction not found.");
        }
        return ResponseEntity.ok(bean);
    }

    @RequestMapping(value = "/bulk", method = RequestMethod.POST)
    public void bulkDownload(HttpServletResponse response, @RequestParam(defaultValue = "0") Long transactionId) throws IOException {
        response.setContentType("application/octet-stream");
        String fileName = String.format("Transaction_%s.xls", transactionId);
        String headerValue = String.format("attachment; filename=\"%s\"", fileName);

        response.setHeader("Content-Disposition", headerValue);

        Workbook workbook = productService.getFileForBulkDownload(transactionId);
        workbook.write(response.getOutputStream());
    }
}
