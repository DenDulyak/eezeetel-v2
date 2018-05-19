package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.math.BigDecimal;

/**
 * Created by Denis Dulyak on 15.09.2016.
 */
@Getter
@Setter
@Entity
@Table(name = "group_transaction_balance")
public class GroupTransactionBalance {

    @Id
    @Column(name = "TRANSACTION_ID")
    private Long transactionId;

    @Column(name = "BALANCE_BEFORE", nullable = false)
    private BigDecimal balanceBefore;

    @Column(name = "BALANCE_AFTER", nullable = false)
    private BigDecimal balanceAfter;
}
