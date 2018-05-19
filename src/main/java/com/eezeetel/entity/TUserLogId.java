package com.eezeetel.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;
import java.util.Date;
import java.util.Objects;

@Getter
@Setter
@NoArgsConstructor
@Embeddable
public class TUserLogId implements Serializable {

    @Column(name = "User_Login_ID")
    private String userLoginId;

    @Column(name = "Login_Time")
    private Date loginTime;

    public TUserLogId(String userLoginId, Date loginTime) {
        this.userLoginId = userLoginId;
        this.loginTime = loginTime;
    }

    public boolean equals(Object other) {
        if (this == other) return true;
        if (other == null) return false;
        if (!(other instanceof TUserLogId)) return false;
        TUserLogId castOther = (TUserLogId) other;

        return ((Objects.equals(getUserLoginId(), castOther.getUserLoginId())) || (
                (getUserLoginId() != null) && (castOther.getUserLoginId() != null) &&
                        (getUserLoginId().equals(castOther.getUserLoginId())))) && (
                (getLoginTime() == castOther.getLoginTime()) || (
                        (getLoginTime() != null) &&
                                (castOther.getLoginTime() != null) &&
                                (getLoginTime().equals(castOther.getLoginTime()))));
    }

    public int hashCode() {
        int result = 17;
        result = 37 * result + (getUserLoginId() == null ? 0 : getUserLoginId().hashCode());
        result = 37 * result + (getLoginTime() == null ? 0 : getLoginTime().hashCode());
        return result;
    }
}