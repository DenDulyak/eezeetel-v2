package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by Denis Dulyak on 23.12.2015.
 */
@Getter
@Setter
@Entity
@Table(name = "mobile_unlocking_customer_commission")
public class MobileUnlockingCustomerCommission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CUSTOMER_ID", columnDefinition = "INT(10) UNSIGNED", nullable = false)
    private TMasterCustomerinfo customer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MOBILE_UNLOCKING_COMMISSION_ID", nullable = false)
    private MobileUnlockingCommission mobileUnlockingCommission;

    @Column(name = "GROUP_COMMISSION", nullable = false)
    private BigDecimal groupCommission;

    @Column(name = "AGENT_COMMISSION", nullable = false)
    private BigDecimal agentCommission;

    @Column(name = "CREATED_DATE", nullable = false)
    private Date createdDate;

    @Column(name = "UPDATED_DATE")
    private Date updatedDate;

    public MobileUnlockingCustomerCommission() {
        this.createdDate = new Date();
        this.groupCommission = new BigDecimal("0");
        this.agentCommission = new BigDecimal("0");
    }
}
