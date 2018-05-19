package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "t_user_log")
public class TUserLog implements Serializable {

    @EmbeddedId
    private TUserLogId id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "User_Login_ID", nullable = false, insertable = false, updatable = false)
    private User user;

    @Column(name = "Logout_Time")
    private Date logoutTime;

    @Column(name = "Login_Status", nullable = false)
    private byte loginStatus;

    @Column(name = "SessionID", nullable = false)
    private String sessionId;
}