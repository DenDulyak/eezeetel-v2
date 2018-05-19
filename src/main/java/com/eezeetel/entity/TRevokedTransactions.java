package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "t_revoked_transactions")
public class TRevokedTransactions implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "Sequence_ID")
    private Integer id;

    @Column(name = "Original_Sequence_ID", nullable = false)
    private long originalSequenceId;

    @Column(name = "Original_Transaction_ID", nullable = false)
    private long originalTransactionId;

    @Column(name = "Card_Sequence_ID", nullable = false)
    private long cardSequenceId;

    @Column(name = "Revoked_Date", nullable = false)
    private Date revokedDate;

    @Column(name = "New_Sequence_ID")
    private Long newSequenceId;

    @Column(name = "New_Transction_ID")
    private Long newTransctionId;

    @Column(name = "Sold_Again_Status", nullable = false)
    private byte soldAgainStatus;
}