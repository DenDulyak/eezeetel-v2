package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.Date;

/**
 * Created by Denis Dulyak on 07.02.2017.
 */
@Getter
@Setter
@Entity
@Table(name = "request_log", uniqueConstraints = {@UniqueConstraint(columnNames = {"user_id", "request_key"})})
public class RequestLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", columnDefinition = "VARCHAR(50) CHARACTER SET 'latin1'", nullable = false)
    private User user;

    @Column(name = "request_key", nullable = false)
    private Long key;

    @Column(name = "hex", nullable = false)
    private String hex;

    @Column(name = "date", nullable = false)
    private Date date;
}
