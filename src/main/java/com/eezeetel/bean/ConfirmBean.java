package com.eezeetel.bean;

import com.eezeetel.enums.TransactionType;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * Created by Denis Dulyak on 10.09.2015.
 */
@Getter
@Setter
public class ConfirmBean {

    private boolean success;
    private String message;
    private String error;
    private List products;
    private String customerCompanyName;
    private Long transactionId;
    private String transactionTime;
    private TransactionType transactionType;
}
