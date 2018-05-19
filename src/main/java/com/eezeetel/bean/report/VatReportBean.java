package com.eezeetel.bean.report;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * Created by Denis Dulyak on 28.11.2016.
 */
@Getter
@Setter
public class VatReportBean {

    private String customer;
    private String product;
    private String productType;
    private String supplierName;

    private Integer transactions;
    private Integer quantity;

    private BigDecimal costPrice;
    private BigDecimal groupPrice;
    private BigDecimal agentPrice;
    private BigDecimal customerPrice;
}
