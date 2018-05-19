package com.eezeetel.bean.report;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * Created by Denis Dulyak on 21.12.2016.
 */
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class WorldMobileTopupSummary {

    private Integer transactions;
    private BigDecimal amount;
}
