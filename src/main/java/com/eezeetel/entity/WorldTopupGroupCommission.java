package com.eezeetel.entity;

import com.eezeetel.serializer.GroupSerializer;
import com.eezeetel.serializer.PhoneTopupCountrySerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

/**
 * Created by Denis Dulyak on 09.06.2016.
 */
@Getter
@Setter
@Entity
@Table(name = "world_topup_group_commission")
public class WorldTopupGroupCommission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @JsonSerialize(using = PhoneTopupCountrySerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COUNTRY_ID", nullable = false)
    private PhoneTopupCountry country;

    @JsonSerialize(using = GroupSerializer.class)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GROUP_ID", columnDefinition = "INT(10) UNSIGNED", nullable = false)
    private TMasterCustomerGroups group;

    @Column(name = "PERCENT", columnDefinition = "INT(11) NOT NULL DEFAULT 3")
    private Integer percent;
}
