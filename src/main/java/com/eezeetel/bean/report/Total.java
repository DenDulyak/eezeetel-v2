package com.eezeetel.bean.report;

/**
 * Created by ahorbat on 05.05.18.
 */
public class Total {
    private Integer quantity = 0;
    private float amount = 0;
    private Double commission = 0.0;

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Float getAmount() {
        return amount;
    }

    public void setAmount(Float amount) {
        this.amount = amount;
    }

    public Double getCommission() {
        return commission;
    }

    public void setCommission(Double commission) {
        this.commission = commission;
    }
}
