package com.eezeetel.bean.customer;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

/**
 * Created by Denis Dulyak on 14.10.2015.
 */
@Getter
@Setter
public class PrintSimTransaction {

    private Long transactionId;
    private Date transactionTime;
    private String productName;
    private String simCardPin;
    private String companyName;
    private Integer totalTopups = 0;
}
