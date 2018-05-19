package com.eezeetel.entity;

import com.eezeetel.serializer.CustomerSerializer;
import com.eezeetel.serializer.WorldTopupGroupCommissionSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

/**
 * Created by Denis Dulyak on 13.07.2016.
 */
@Getter
@Setter
@Entity
@Table(name = "world_topup_customer_commission")
public class WorldTopupCustomerCommission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @JsonSerialize(using = WorldTopupGroupCommissionSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GROUP_COMMISSION_ID", nullable = false)
    private WorldTopupGroupCommission groupCommission;

    @JsonSerialize(using = CustomerSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CUSTOMER_ID", columnDefinition = "INT(10) UNSIGNED", nullable = false)
    private TMasterCustomerinfo customer;

    @Column(name = "GROUP_PERCENT", columnDefinition = "INT(11) NOT NULL DEFAULT 5")
    private Integer groupPercent;

    @Column(name = "AGENT_PERCENT", columnDefinition = "INT(11) NOT NULL DEFAULT 0")
    private Integer agentPercent;
}
