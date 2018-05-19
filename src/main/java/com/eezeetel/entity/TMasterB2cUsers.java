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
@Table(name = "t_master_b2c_users")
public class TMasterB2cUsers implements Serializable {

    @Id
    @Column(name = "EMail_ID")
    private String emailId;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Customer_Group_ID", nullable = false)
    private TMasterCustomerGroups group;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "User_Type_And_Privilege", nullable = false)
    private TMasterUserTypeAndPrivilege userType;

    @Column(name = "Mobile_Phone", nullable = false)
    private String mobilePhone;

    @Column(name = "User_First_Name", nullable = false)
    private String userFirstName;

    @Column(name = "User_Last_Name", nullable = false)
    private String userLastName;

    @Column(name = "User_Middle_Name")
    private String userMiddleName;

    @Column(name = "Address_Line_1")
    private String addressLine1;

    @Column(name = "Address_Line_2")
    private String addressLine2;

    @Column(name = "Address_Line_3")
    private String addressLine3;

    @Column(name = "City")
    private String city;

    @Column(name = "State")
    private String state;

    @Column(name = "Postal_Code")
    private String postalCode;

    @Column(name = "Country")
    private String country;

    @Column(name = "Alternate_Phone")
    private String alternatePhone;

    @Column(name = "Password", nullable = false)
    private String password;

    @Column(name = "Password_2", nullable = false)
    private String password2;

    @Column(name = "User_Active_Status", nullable = false)
    private short userActiveStatus;

    @Column(name = "User_Created_By", nullable = false)
    private String userCreatedBy;

    @Column(name = "User_Creation_Time", nullable = false)
    private Date userCreationTime;

    @Column(name = "User_Modified_Time", nullable = false)
    private Date userModifiedTime;

    @Column(name = "Notes")
    private String notes;

    @Column(name = "Verification_Code", nullable = false)
    private String verificationCode;

    @Column(name = "Verified_Or_Joined_On", nullable = false)
    private Date verifiedOrJoinedOn;

    @Column(name = "Is_Verifited", nullable = false)
    private byte isVerifited;

    @Column(name = "Customer_Balance", nullable = false)
    private float customerBalance;

    @OneToMany(cascade = {CascadeType.ALL}, targetEntity = TB2cTransactions.class, mappedBy = "b2cUser", fetch = FetchType.LAZY)
    private List<TB2cTransactions> tb2cTransactions;

    @OneToMany(cascade = {CascadeType.ALL}, targetEntity = TB2cCustomerCredit.class, mappedBy = "b2cUser", fetch = FetchType.LAZY)
    private List<TB2cCustomerCredit> tb2cCustomerCredits;
}