package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "t_report_customer_credit")
public class TReportCustomerCredit implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Sequence_ID")
    private Integer id;

    @Column(name = "Begin_Date", nullable = false)
    private Date beginDate;

    @Column(name = "End_Date", nullable = false)
    private Date endDate;

    @Column(name = "Customer_ID", nullable = false)
    private int customerId;

    @Column(name = "Customer_Group_ID", nullable = false)
    private int customerGroupId;

    @Column(name = "Total_Credit_So_Far", nullable = false)
    private float totalCreditSoFar;

    @Column(name = "Total_Debit_On_End_Date", nullable = false)
    private float totalDebitOnEndDate;

    @Column(name = "Balance_On_End_Date", nullable = false)
    private float balanceOnEndDate;
}