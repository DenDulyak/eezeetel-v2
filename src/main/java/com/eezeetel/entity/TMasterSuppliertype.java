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
@Table(name = "t_master_suppliertype")
public class TMasterSuppliertype implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name = "Supplier_Type_ID")
    private Short id;

    @Column(name = "Supplier_Type", nullable = false)
    private String supplierType;

    @Column(name = "Supplier_Type_Description")
    private String description;

    @Column(name = "Supplier_Type_Active_Status", nullable = false)
    private Boolean active;

    @Column(name = "Notes")
    private String notes;

    @Column(name = "Reserved_1")
    private Integer reserved1;

    @Column(name = "Reserved_2")
    private String reserved2;

    @Column(name = "IS_SIM")
    private Boolean isSim;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.ALL}, targetEntity = TMasterSupplierinfo.class, mappedBy = "supplierType", fetch = FetchType.LAZY)
    private List<TMasterSupplierinfo> suppliers;
}