package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;

@Getter
@Setter
@Entity
@Table(name = "t_transaction_balance")
public class TTransactionBalance implements Serializable {

    @Id
    @Column(name = "Transaction_ID")
    private long transactionId;

    @Column(name = "Balance_Before_Transaction", nullable = false)
    private float balanceBeforeTransaction;

    @Column(name = "Balance_After_Transaction", nullable = false)
    private float balanceAfterTransaction;
}