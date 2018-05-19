package com.eezeetel.bean;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * Created by Denis Dulyak on 29.09.2015.
 */
@Getter
@Setter
public class ReportBean {

    private Integer batchInfoId = 0;
    private Integer productId;
    private String productName;
    private BigDecimal productCostPrice;
    private String supplierName;
    private Float faceValue;
    private Integer quantity = 0;
    private Integer beginingQuantity = 0;
    private Integer availableQuantity = 0;
    private Integer enteredQuantity = 0;
    private Integer sales = 0;
    private Integer transactions = 0;
    private BigDecimal sumPurchasePrice = new BigDecimal("0");
    private BigDecimal sumSalePrice = new BigDecimal("0");
    private Integer amount;
}
