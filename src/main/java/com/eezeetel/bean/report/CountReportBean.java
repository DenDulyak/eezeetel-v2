package com.eezeetel.bean.report;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class CountReportBean {

    private Integer transactions;
    private Integer quantity;
    private BigDecimal price;
}
