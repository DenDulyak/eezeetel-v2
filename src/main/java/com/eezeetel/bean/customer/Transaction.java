package com.eezeetel.bean.customer;

import com.eezeetel.entity.MobitopupTransaction;
import com.eezeetel.entity.TDingTransactions;
import com.eezeetel.entity.TTransactions;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Collections;
import java.util.Date;
import java.util.List;

/**
 * Created by Denis Dulyak on 12.10.2015.
 */
@Getter
@Setter
@NoArgsConstructor
public class Transaction {

    private Long transactionId;
    private Date transactionTime;
    private String userFirstName;
    private String userLastName;
    private List<String> products;

    public Transaction(TTransactions transaction) {
        this.transactionId = transaction.getTransactionId();
        this.transactionTime = transaction.getTransactionTime();
        this.userFirstName = transaction.getUser().getUserFirstName();
        this.userLastName = transaction.getUser().getUserLastName();
    }

    public Transaction(TDingTransactions transaction) {
        this.transactionId = transaction.getTransactionId();
        this.transactionTime = transaction.getTransactionTime();
        this.userFirstName = transaction.getUser().getUserFirstName();
        this.userLastName = transaction.getUser().getUserLastName();
        this.products = Collections.singletonList("Mobile Topup");
    }

    public Transaction(MobitopupTransaction transaction) {
        this.transactionId = transaction.getTransactionId();
        this.transactionTime = transaction.getTransactionTime();
        this.userFirstName = transaction.getUser().getUserFirstName();
        this.userLastName = transaction.getUser().getUserLastName();
        this.products = Collections.singletonList("Mobile Topup");
    }
}
