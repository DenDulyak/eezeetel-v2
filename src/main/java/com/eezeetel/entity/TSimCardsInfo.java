package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "t_sim_cards_info")
public class TSimCardsInfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "SequenceID")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Product_ID", nullable = false)
    private TMasterProductinfo product;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Batch_Sequence_ID", nullable = false)
    private TBatchInformation batch;

    @Column(name = "Customer_Group_ID")
    private Integer customerGroupId;

    @Column(name = "Customer_ID")
    private Integer customerId;

    @Column(name = "sim_card_id", nullable = false)
    private String simCardId;

    @Column(name = "sim_card_pin", nullable = false)
    private String simCardPin;

    @Column(name = "Is_Sold", nullable = false)
    private Boolean isSold;

    @Column(name = "Transaction_ID")
    private Long transactionId;

    @Column(name = "Max_Topups", nullable = false)
    private byte maxTopups;

    @Column(name = "Remaining_Topups", nullable = false)
    private byte remainingTopups;

    @OneToMany(cascade = {CascadeType.ALL}, targetEntity = TSimTransactions.class, mappedBy = "simCard", fetch = FetchType.LAZY)
    private List<TSimTransactions> simTransactions;
}