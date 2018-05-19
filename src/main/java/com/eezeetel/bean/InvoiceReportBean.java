package com.eezeetel.bean;

import com.eezeetel.bean.report.Total;

import java.math.BigDecimal;
import java.util.List;

/**
 * Created by ahorbat on 05.05.18.
 */
public class InvoiceReportBean {

    private BigDecimal nonVatSales;
    private BigDecimal netVatSales;
    private BigDecimal vat ;
    private List<InvoiceTransactionBean> transactions;
    private Total subTotal;
    private Total grandTotal;

    public Total getSubTotal() {
        return subTotal;
    }

    public void setSubTotal(Total subTotal) {
        this.subTotal = subTotal;
    }

    public Total getGrandTotal() {
        return grandTotal;
    }

    public void setGrandTotal(Total grandTotal) {
        this.grandTotal = grandTotal;
    }

    public List<InvoiceTransactionBean> getTransactions() {
        return transactions;
    }

    public void setTransactions(List<InvoiceTransactionBean> transactions) {
        this.transactions = transactions;
    }

    public BigDecimal getNonVatSales() {
        return nonVatSales;
    }

    public void setNonVatSales(BigDecimal nonVatSales) {
        this.nonVatSales = nonVatSales;
    }

    public BigDecimal getNetVatSales() {
        return netVatSales;
    }

    public void setNetVatSales(BigDecimal netVatSales) {
        this.netVatSales = netVatSales;
    }

    public BigDecimal getVat() {
        return vat;
    }

    public void setVat(BigDecimal vat) {
        this.vat = vat;
    }
}
