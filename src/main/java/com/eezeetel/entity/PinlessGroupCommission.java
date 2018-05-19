package com.eezeetel.entity;

import com.eezeetel.serializer.GroupSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Getter
@Setter
@Entity
@Table(name = "pinless_group_commission")
public class PinlessGroupCommission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @JsonSerialize(using = GroupSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "group_id", columnDefinition = "INT(10) UNSIGNED", nullable = false)
    private TMasterCustomerGroups group;

    @Column(name = "percent", columnDefinition = "INT(11) NOT NULL DEFAULT 3")
    private Integer percent;
}
