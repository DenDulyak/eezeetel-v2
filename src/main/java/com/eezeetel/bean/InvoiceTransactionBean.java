package com.eezeetel.bean;

import com.eezeetel.bean.report.Total;

/**
 * Created by ahorbat on 05.05.18.
 */
public class InvoiceTransactionBean {
    private Integer serialNumber = 0;
    private String product;
    private String productType;
    private float retail_price = 0;
    private Integer quantity = 0;
    private float amount = 0;
    private Double commission = 0.0;


    public String getProductType() {
        return productType;
    }

    public void setProductType(String productType) {
        this.productType = productType;
    }

    public Integer getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(Integer serialNumber) {
        this.serialNumber = serialNumber;
    }

    public String getProduct() {
        return product;
    }

    public void setProduct(String product) {
        this.product = product;
    }

    public float getRetail_price() {
        return retail_price;
    }

    public void setRetail_price(float retail_price) {
        this.retail_price = retail_price;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public float getAmount() {
        return amount;
    }

    public void setAmount(float amount) {
        this.amount = amount;
    }

    public Double getCommission() {
        return commission;
    }

    public void setCommission(Double commission) {
        this.commission = commission;
    }
}
