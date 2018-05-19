package com.eezeetel.entity;

import com.eezeetel.enums.GroupStyle;
import com.eezeetel.serializer.CustomerSerializer;
import com.eezeetel.serializer.DateTimeSerializer;
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
@Table(name = "t_master_customer_groups")
public class TMasterCustomerGroups implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Customer_Group_ID")
    private Integer id;

    @JsonSerialize(using = CustomerSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Default_Customer_ID", nullable = false)
    private TMasterCustomerinfo defaultCustomer;

    @JsonSerialize(using = UserSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Created_By", nullable = false)
    private User createdBy;

    @Column(name = "Customer_Group_Name", nullable = false)
    private String name;

    @JsonSerialize(using = DateTimeSerializer.class)
    @Column(name = "Customer_Since", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date customerSince;

    @Column(name = "Notes")
    private String notes;

    @Column(name = "IsActive", nullable = false)
    private Boolean active;

    @Column(name = "Customer_Group_Balance", nullable = false, precision = 12)
    private Float customerGroupBalance;

    @Column(name = "Check_Aganinst_Group_Balance", nullable = false)
    private Boolean checkAganinstGroupBalance;

    @Column(name = "Apply_Default_Customer_Percentages", nullable = false)
    private Boolean applyDefaultCustomerPercentages;

    @Column(name = "Group_Address", nullable = false)
    private String groupAddress;

    @Column(name = "Group_City", nullable = false)
    private String groupCity;

    @Column(name = "Group_PinCode", nullable = false)
    private String groupPinCode;

    @Column(name = "Group_Phone", nullable = false)
    private String groupPhone;

    @Column(name = "Group_Mobile", nullable = false)
    private String groupMobile;

    @Column(name = "Group_Email_ID", nullable = false)
    private String groupEmailId;

    @Column(name = "Company_Reg_No", nullable = false)
    private String companyRegNo;

    @Column(name = "VAT_Reg_No", nullable = false)
    private String vatRegNo;

    @Column(name = "Sell_At_Face_Value", nullable = false)
    private Boolean sellAtFaceValue;

    @Column(name = "STYLE")
    @Enumerated(value = EnumType.ORDINAL)
    private GroupStyle style = GroupStyle.DEFAULT;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.ALL}, mappedBy = "group", fetch = FetchType.LAZY)
    private List<TMasterCustomerinfo> customers;

    public TMasterCustomerGroups() {
    }

    public TMasterCustomerGroups(Integer id) {
        this.id = id;
    }
}