package com.eezeetel.entity;

import com.eezeetel.enums.SettingType;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

/**
 * Created by Denis Dulyak on 23.11.2016.
 */
@Getter
@Setter
@Entity
@Table(name = "setting")
public class Setting {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @Column(name = "TYPE", unique = true, nullable = false)
    @Enumerated(value = EnumType.ORDINAL)
    private SettingType type;

    @Column(name = "VALUE", nullable = false)
    private String value;
}
