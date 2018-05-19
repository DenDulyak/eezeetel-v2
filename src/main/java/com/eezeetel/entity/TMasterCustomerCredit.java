package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "t_master_customer_credit")
public class TMasterCustomerCredit implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "Credit_ID")
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Customer_ID", nullable = false)
    private TMasterCustomerinfo customer;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Entered_By", nullable = false)
    private User enteredBy;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Collected_By", nullable = false)
    private User collectedBy;

    // 1 - cash, 2 - check, 3 - bank deposit, 4 - online transfer, 5 - card
    @Column(name = "Payment_Type", nullable = false)
    private byte paymentType;

    @Column(name = "Payment_Details")
    private String paymentDetails;

    @Column(name = "Payment_Amount", nullable = false)
    private float paymentAmount;

    @Column(name = "Payment_Date")
    private Date paymentDate;

    @Column(name = "Entered_Time", nullable = false)
    private Date enteredTime;

    // 1 - credit (customer paid), 2 - debit (customer NOT paid, but allowed to buy cards)
    @Column(name = "Credit_or_Debit", nullable = false)
    private byte creditOrDebit;

    // 1 - pending verification, 2 - processed
    @Column(name = "Credit_ID_Status", nullable = false)
    private byte creditIdStatus;

    @Column(name = "Notes")
    private String notes;
}