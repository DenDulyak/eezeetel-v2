package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "t_b2c_transactions")
public class TB2cTransactions implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "Sequence_ID")
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Product_ID", nullable = false)
    private TMasterProductinfo product;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Email_ID", nullable = false)
    private TMasterB2cUsers b2cUser;

    @Column(name = "Transaction_ID", nullable = false)
    private long transactionId;

    @Column(name = "Batch_Sequence_ID", nullable = false)
    private int batchSequenceId;

    @Column(name = "Mobile_Phone", nullable = false)
    private String mobilePhone;

    @Column(name = "Quantity", nullable = false)
    private int quantity;

    @Column(name = "Unit_Purchase_Price", nullable = false)
    private float unitPurchasePrice;

    @Column(name = "Agent_Price", nullable = false)
    private float agentPrice;

    @Column(name = "Committed", nullable = false)
    private byte committed;

    @Column(name = "Transaction_Time", nullable = false)
    private Date transactionTime;

    @Column(name = "Unit_Group_Price", nullable = false)
    private float unitGroupPrice;

    @Column(name = "Batch_Unit_Price", nullable = false)
    private float batchUnitPrice;

    @Column(name = "Post_Processing_Stage", nullable = false)
    private byte postProcessingStage;
}