package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "t_sim_transactions")
public class TSimTransactions implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "SequenceID")
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "SIM_Card_SequenceID", nullable = false)
    private TSimCardsInfo simCard;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "User_ID", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Customer_ID", nullable = false)
    private TMasterCustomerinfo customer;

    @Column(name = "Transaction_ID", nullable = false)
    private long transactionId;

    @Column(name = "Transaction_Time", nullable = false)
    private Date transactionTime;

    @Column(name = "Customer_Commission", nullable = false)
    private float customerCommission;

    @Column(name = "Agent_Commission", nullable = false)
    private float agentCommission;

    @Column(name = "Group_Commission", nullable = false)
    private float groupCommission;

    @Column(name = "Eezeetel_Commission", nullable = false)
    private float eezeetelCommission;

    @Column(name = "Committed", nullable = false)
    private byte committed;

    @Column(name = "Post_Processing_Stage", nullable = false)
    private byte postProcessingStage;

    @Column(name = "Mobile_Topup_Transaction_ID")
    private Long mobileTopupTransactionId;
}