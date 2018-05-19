package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;

@Getter
@Setter
@Entity
@Table(name = "t_card_info")
public class TCardInfo implements Serializable {

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

    @Column(name = "card_id", nullable = false)
    private String cardId;

    @Column(name = "card_pin", nullable = false)
    private String cardPin;

    @Column(name = "Transaction_ID")
    private Long transactionId;

    @Column(name = "IsSold", nullable = false)
    private Boolean isSold;

    public TCardInfo() {
    }

    public TCardInfo(Long id) {
        this.id = id;
    }
}