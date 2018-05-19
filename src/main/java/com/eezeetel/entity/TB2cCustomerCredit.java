package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "t_b2c_customer_credit")
public class TB2cCustomerCredit implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "Credit_ID")
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Email_ID", nullable = false)
    private TMasterB2cUsers b2cUser;

    @Column(name = "Mobile_Phone", nullable = false)
    private String mobilePhone;

    // 1 - cash, 2 - check, 3 - bank deposit, 4 - online transfer, 5 - card
    @Column(name = "Payment_Type", nullable = false)
    private byte paymentType;

    @Column(name = "Payment_Details")
    private String paymentDetails;

    @Column(name = "Payment_Amount", nullable = false)
    private float paymentAmount;

    @Column(name = "Payment_Date")
    private Date paymentDate;

    // 1 - credit (customer paid), 2 - debit (customer NOT paid, but allowed to buy cards)
    @Column(name = "Credit_or_Debit", nullable = false)
    private byte creditOrDebit;

    // 1 - pending verification, 2 - processed
    @Column(name = "Credit_ID_Status", nullable = false)
    private byte creditIdStatus;

    @Column(name = "Notes")
    private String notes;
}