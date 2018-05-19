package com.eezeetel.entity;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;

@Embeddable
public class TCustomerGroupCommissionsId implements Serializable {

    @Column(name = "Customer_Group_ID")
    private int customerGroupId;

    @Column(name = "Product_ID")
    private int productId;

    public TCustomerGroupCommissionsId() {
    }

    public TCustomerGroupCommissionsId(int customerGroupId, int productId) {
        this.customerGroupId = customerGroupId;
        this.productId = productId;
    }

    public int getCustomerGroupId() {
        return customerGroupId;
    }

    public void setCustomerGroupId(int customerGroupId) {
        this.customerGroupId = customerGroupId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public boolean equals(Object other) {
        if (this == other) return true;
        if (other == null) return false;
        if (!(other instanceof TCustomerGroupCommissionsId)) return false;
        TCustomerGroupCommissionsId castOther = (TCustomerGroupCommissionsId) other;
        return (getCustomerGroupId() == castOther.getCustomerGroupId()) && (getProductId() == castOther.getProductId());
    }

    public int hashCode() {
        int result = 17;
        result = 37 * result + getCustomerGroupId();
        result = 37 * result + getProductId();
        return result;
    }
}