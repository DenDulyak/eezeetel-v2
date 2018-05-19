package com.eezeetel.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;

@Getter
@Setter
@Embeddable
public class TAgentCommissionId implements Serializable {

    @Column(name = "Agent_ID")
    private String agentId;

    @Column(name = "Product_ID")
    private int productId;

    public TAgentCommissionId() {
    }

    public TAgentCommissionId(String agentId, int productId) {
        this.agentId = agentId;
        this.productId = productId;
    }

    public boolean equals(Object other) {
        if (this == other) return true;
        if (other == null) return false;
        if (!(other instanceof TAgentCommissionId)) return false;
        TAgentCommissionId castOther = (TAgentCommissionId) other;

        return ((getAgentId() == castOther.getAgentId()) || (
                (getAgentId() != null) && (castOther.getAgentId() != null) &&
                (getAgentId().equals(castOther.getAgentId())))) &&
                (getProductId() == castOther.getProductId());
    }

    public int hashCode() {
        int result = 17;
        result = 37 * result + (
		getAgentId() == null ? 0 : getAgentId().hashCode());
        result = 37 * result + getProductId();
        return result;
    }
}