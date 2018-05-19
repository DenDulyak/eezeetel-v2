package com.eezeetel.entity;

import com.eezeetel.serializer.CustomerSerializer;
import com.eezeetel.serializer.PinlessGroupCommissionSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Getter
@Setter
@Entity
@Table(name = "pinless_customer_commission")
public class PinlessCustomerCommission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @JsonSerialize(using = PinlessGroupCommissionSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "group_commission_id", nullable = false)
    private PinlessGroupCommission groupCommission;

    @JsonSerialize(using = CustomerSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", columnDefinition = "INT(10) UNSIGNED", nullable = false)
    private TMasterCustomerinfo customer;

    @Column(name = "group_percent", columnDefinition = "INT(11) NOT NULL DEFAULT 5")
    private Integer groupPercent;

    @Column(name = "agent_percent", columnDefinition = "INT(11) NOT NULL DEFAULT 0")
    private Integer agentPercent;
}
