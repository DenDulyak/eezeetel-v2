package com.eezeetel.bean.report;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * Created by Denis Dulyak on 04.01.2017.
 */
@Getter
@Setter
public class ProductSummaryReport {

    private Integer productId;
    private String productName;
    private Float faceValue;
    private Integer transactions;
    private Integer totalCardsSold;
    private BigDecimal totalCostPrice;
    private BigDecimal totalSalePrice;
}
