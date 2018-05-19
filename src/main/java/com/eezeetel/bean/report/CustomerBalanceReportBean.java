package com.eezeetel.bean.report;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * Created by Denis Dulyak on 06.01.2017.
 */
@Getter
@Setter
public class CustomerBalanceReportBean {

    private Integer customerId;
    private String customerName;
    private BigDecimal balanceBefore;
    private BigDecimal balanceAfter;
    private BigDecimal topup;
    private BigDecimal sales;
    private Integer transactions;
    private Integer quantity;
}
