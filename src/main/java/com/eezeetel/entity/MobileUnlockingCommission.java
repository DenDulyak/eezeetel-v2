package com.eezeetel.entity;

import com.eezeetel.serializer.DateTimeSerializer;
import com.eezeetel.serializer.GroupSerializer;
import com.eezeetel.serializer.MobileUnlockingSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by Denis Dulyak on 17.12.2015.
 */
@Getter
@Setter
@Entity
@Table(name = "mobile_unlocking_commission")
public class MobileUnlockingCommission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @JsonSerialize(using = GroupSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GROUP_ID", columnDefinition = "INT(10) UNSIGNED", nullable = false)
    private TMasterCustomerGroups group;

    @JsonSerialize(using = MobileUnlockingSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MOBILE_UNLOCKING_ID", nullable = false)
    private MobileUnlocking mobileUnlocking;

    @Column(name = "COMMISSION", nullable = false)
    private BigDecimal commission;

    @JsonSerialize(using = DateTimeSerializer.class)
    @Column(name = "CREATED_DATE", nullable = false)
    private Date createdDate;

    @JsonSerialize(using = DateTimeSerializer.class)
    @Column(name = "UPDATED_DATE")
    private Date updatedDate;

    public MobileUnlockingCommission() {
        createdDate = new Date();
        commission = new BigDecimal("0");
    }
}
