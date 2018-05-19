package com.eezeetel.bean.report;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * Created by Denis Dulyak on 05.12.2016.
 */
@Getter
@Setter
public class VATReportProcedure {

    private Integer saleType;
    private String group;
    private String customer;
    private BigDecimal netSales;
    private BigDecimal vat;
    private BigDecimal totalSales;
    private BigDecimal profit;
    private BigDecimal vatOnProfit;
}
