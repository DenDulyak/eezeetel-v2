package com.eezeetel.entity;

import com.eezeetel.enums.TitleType;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

/**
 * Created by Denis Dulyak on 10.03.2016.
 */
@Getter
@Setter
@Entity
@Table(name = "title")
public class Title {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @Column(name = "TEXT", nullable = false)
    private String text;

    @Column(name="TYPE")
    @Enumerated(value = EnumType.ORDINAL)
    private TitleType type;
}
