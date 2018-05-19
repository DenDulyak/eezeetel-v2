package com.eezeetel.bean.report;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

/**
 * Created by Denis Dulyak on 04.12.2015.
 */
@Getter
@Setter
public class RevokedTransaction {

    private String customerGroup;
    private String customerName;
    private Long transactionId;
    private Date transactionTime;
    private Float salePrice;
    private String productName;
    private String batchId;
    private String cardPin;
    private Date revokedDate;
    private String newCustomerGroup;
    private String newCustomerName;
    private Long newTransactionId;
    private Date newDate;
    private String credit;
    private String reject;
}
