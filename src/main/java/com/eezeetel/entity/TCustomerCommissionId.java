package com.eezeetel.entity;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;

@Embeddable
public class TCustomerCommissionId implements Serializable {

    @Column(name = "Customer_ID")
    private int customerId;

    @Column(name = "Product_ID")
    private int productId;

    public TCustomerCommissionId() {
    }

    public TCustomerCommissionId(int customerId, int productId) {
        this.customerId = customerId;
        this.productId = productId;
    }

    public int getCustomerId() {
        return this.customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getProductId() {
        return this.productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public boolean equals(Object other) {
        if (this == other) return true;
        if (other == null) return false;
        if (!(other instanceof TCustomerCommissionId)) return false;
        TCustomerCommissionId castOther = (TCustomerCommissionId) other;
        return (getCustomerId() == castOther.getCustomerId()) && (getProductId() == castOther.getProductId());
    }

    public int hashCode() {
        int result = 17;
        result = 37 * result + getCustomerId();
        result = 37 * result + getProductId();
        return result;
    }
}