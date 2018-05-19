package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "t_master_banks")
public class TMasterBanks implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Sequence_ID")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Customer_Group_ID", nullable = false)
    private TMasterCustomerGroups group;

    @Column(name = "Bank_Name", nullable = false)
    private String bankName;

    @Column(name = "Active_Bank", nullable = false)
    private byte activeBank;

    @Column(name = "Banking_Since", nullable = false)
    private Date bankingSince;

    @Column(name = "Sort_Code")
    private String sortCode;

    @Column(name = "Account_Number")
    private String accountNumber;

    @OneToMany(cascade = {CascadeType.ALL}, targetEntity = TCreditRequests.class, mappedBy = "bank", fetch = FetchType.LAZY)
    private List<TCreditRequests> creditRequests;
}