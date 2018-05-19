package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.math.BigDecimal;

/**
 * Created by Denis Dulyak on 15.12.2015.
 */
@Getter
@Setter
@Entity
@Table(name = "mobile_unlocking")
public class MobileUnlocking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @Column(name = "TITLE", nullable = false)
    private String title;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "SUPPLIER_ID", columnDefinition = "INT(10) UNSIGNED", nullable = false)
    private TMasterSupplierinfo supplier;

    @Column(name = "DELIVERY_TIME")
    private String deliveryTime;

    @Column(name = "PURCHASE_PRICE", nullable = false)
    private BigDecimal purchasePrice;

    @Column(name = "TRANSACTION_CONDITION", columnDefinition = "TEXT")
    private String transactionCondition;

    @Column(name = "NOTES")
    private String notes;

    @Column(name = "ACTIVE", nullable = false)
    private Boolean active;
}
