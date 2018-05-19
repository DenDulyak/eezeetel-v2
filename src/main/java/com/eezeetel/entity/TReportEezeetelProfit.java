package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "t_report_eezeetel_profit")
public class TReportEezeetelProfit implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "SequenceID")
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Customer_Group_ID", nullable = false)
    private TMasterCustomerGroups group;

    @Column(name = "Begin_Date", nullable = false)
    private Date beginDate;

    @Column(name = "End_Date", nullable = false)
    private Date endDate;

    @Column(name = "Total_Customers", nullable = false)
    private int totalCustomers;

    @Column(name = "Profit_From_Calling_Cards", nullable = false)
    private float profitFromCallingCards;

    @Column(name = "Profit_From_World_Mobile", nullable = false)
    private float profitFromWorldMobile;

    @Column(name = "Profit_From_Local_Mobile", nullable = false)
    private float profitFromLocalMobile;

    @Column(name = "profit_from_mobile_unlocking", nullable = false)
    private float profitFromMobileUnlocking;

    @Column(name = "profit_from_pinless", nullable = false)
    private float profitFromPinless;

    @Column(name = "Total_Cards", nullable = false)
    private int totalCards;

    @Column(name = "Total_World_Mobile_Transactions", nullable = false)
    private int totalWorldMobileTransactions;

    @Column(name = "Total_Local_Mobile_Transactions", nullable = false)
    private int totalLocalMobileTransactions;

    @Column(name = "total_mobile_unlocking_transactions", nullable = false)
    private int totalMobileUnlockingTransactions;

    @Column(name = "total_pinless_transactions", nullable = false)
    private int totalPinlessTransactions;
}