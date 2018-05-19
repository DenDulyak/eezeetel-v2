package com.eezeetel.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "t_master_customertype")
public class TMasterCustomertype implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "Customer_Type_ID")
    private Short id;

    @Column(name = "Customer_Type", nullable = false)
    private String customerType;

    @Column(name = "Customer_Type_Description")
    private String customerTypeDescription;

    @Column(name = "Customer_Type_Active_Status", nullable = false)
    private Short customerTypeActiveStatus;

    @Column(name = "Notes")
    private String notes;

    @Column(name = "Reserved_1")
    private Short reserved1;

    @Column(name = "Reserved_2")
    private String reserved2;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.ALL}, mappedBy = "customerType", fetch = FetchType.LAZY)
    private List<TMasterCustomerinfo> customers;
}