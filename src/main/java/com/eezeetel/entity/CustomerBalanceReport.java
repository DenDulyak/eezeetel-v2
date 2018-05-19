package com.eezeetel.entity;

import com.eezeetel.serializer.CustomerSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "customer_balance_report", uniqueConstraints = @UniqueConstraint(columnNames = {"customer_id", "day"}))
public class CustomerBalanceReport {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonSerialize(using = CustomerSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", columnDefinition = "INT(10) UNSIGNED", nullable = false)
    private TMasterCustomerinfo customer;

    @Temporal(TemporalType.DATE)
    @Column(nullable = false)
    private Date day;

    /* Balance at the beginning of the day */
    @Column(nullable = false)
    private BigDecimal balance;

    @Column(nullable = false)
    private BigDecimal topup;

    @Column(nullable = false)
    private BigDecimal sales;

    @Column(nullable = false)
    private Integer transactions;

    @Column(nullable = false)
    private Integer quantity;

    public CustomerBalanceReport(TMasterCustomerinfo customer, Date day) {
        this.customer = customer;
        this.day = day;
        this.balance = new BigDecimal(customer.getCustomerBalance() + "").setScale(2, BigDecimal.ROUND_HALF_EVEN);
        this.topup = new BigDecimal("0.00");
        this.sales = new BigDecimal("0.00");
        this.transactions = 0;
        this.quantity = 0;
    }
}
