package com.eezeetel.entity;

import com.eezeetel.serializer.SupplierTyperSerializer;
import com.eezeetel.serializer.UserSerializer;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "t_master_supplierinfo")
public class TMasterSupplierinfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Supplier_ID")
    private Integer id;

    @JsonSerialize(using = SupplierTyperSerializer.class)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Supplier_Type_ID", nullable = false)
    private TMasterSuppliertype supplierType;

    @JsonSerialize(using = UserSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Supplier_Created_By_User_ID", nullable = false)
    private User user;

    @Column(name = "Supplier_Name", nullable = false)
    private String supplierName;

    @Column(name = "Supplier_Contact")
    private String supplierContact;

    @Column(name = "Supplier_Address_Line_1")
    private String supplierAddressLine1;

    @Column(name = "Supplier_Address_Line_2")
    private String supplierAddressLine2;

    @Column(name = "Supplier_Address_Line_3")
    private String supplierAddressLine3;

    @Column(name = "Supplier_City")
    private String supplierCity;

    @Column(name = "Supplier_State")
    private String supplierState;

    @Column(name = "Supplier_Postal_Code")
    private String supplierPostalCode;

    @Column(name = "Supplier_Country")
    private String supplierCountry;

    @Column(name = "Supplier_Primary_Phone")
    private String supplierPrimaryPhone;

    @Column(name = "Supplier_Secondary_Phone")
    private String supplierSecondaryPhone;

    @Column(name = "Supplier_Mobile_Phone")
    private String supplierMobilePhone;

    @Column(name = "Supplier_Website_Address")
    private String supplierWebsiteAddress;

    @Column(name = "Supplier_Email_ID")
    private String supplierEmailId;

    @Column(name = "Supplier_Introduced_By")
    private String supplierIntroducedBy;

    @Column(name = "Supplier_Active_Status", nullable = false)
    private Boolean active;

    @Column(name = "Supplier_Info_Modified_Time", nullable = false)
    private Date supplierInfoModifiedTime;

    @Column(name = "Supplier_Info_Creation_Time")
    private Date supplierInfoCreationTime;

    @Column(name = "Notes")
    private String notes;

    @Column(name = "Secondary_Supplier")
    private Short secondarySupplier;

    @Column(name = "Reserved_1")
    private Integer reserved1;

    @Column(name = "Supplier_Image")
    private String supplierImage;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.ALL}, mappedBy = "supplier", fetch = FetchType.LAZY)
    private List<TMasterProductinfo> products;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.ALL}, mappedBy = "supplier", fetch = FetchType.LAZY)
    private List<TBatchInformation> batches;
}