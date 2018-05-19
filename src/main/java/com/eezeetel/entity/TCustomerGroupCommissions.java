package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "t_customer_group_commissions")
public class TCustomerGroupCommissions implements Serializable {

    @EmbeddedId
    private TCustomerGroupCommissionsId id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Product_ID", nullable = false, insertable = false, updatable = false)
    private TMasterProductinfo product;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Customer_Group_ID", nullable = false, insertable = false, updatable = false)
    private TMasterCustomerGroups group;

    // True - Percentage basis. False - Real Value
    @Column(name = "CommissionType", nullable = false)
    private byte commissionType;

    @Column(name = "Commission", nullable = false)
    private float commission;

    @Column(name = "Active_Status", nullable = false)
    private byte activeStatus;

    @Column(name = "Created_By", nullable = false)
    private String createdBy;

    @Column(name = "Creation_Time", nullable = false)
    private Date creationTime;

    @Column(name = "Last_Modified_Time", nullable = false)
    private Date lastModifiedTime;

    @Column(name = "Notes")
    private String notes;

    @Column(name = "Reserved_1")
    private Integer reserved1;

    @Column(name = "Reserved_2")
    private String reserved2;
}