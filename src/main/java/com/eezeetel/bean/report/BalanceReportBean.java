package com.eezeetel.bean.report;

import com.eezeetel.entity.*;
import com.eezeetel.serializer.DateTimeSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Objects;

/**
 * Created by Denis Dulyak on 19.09.2016.
 */
@Getter
@Setter
public class BalanceReportBean {

    private Long transactionId;
    @JsonSerialize(using = DateTimeSerializer.class)
    private Date transactionTime;
    private BigDecimal groupBalanceBefore;
    private BigDecimal groupBalanceAfter;
    private BigDecimal balanceBefore;
    private BigDecimal balanceAfter;
    private BigDecimal purchasePrice;
    private BigDecimal costToGroup;
    private BigDecimal costToAgent;
    private BigDecimal costToCustomer;
    private String productType;
    private String customer;
    private String productName;
    private BigDecimal retailPrice;
    private Integer quantity;

    public static BalanceReportBean toBean(TTransactions transaction) {
        BalanceReportBean bean = new BalanceReportBean();
        bean.setProductType(transaction.getProduct().getSupplier().getSupplierName());
        bean.setTransactionId(transaction.getTransactionId());
        bean.setTransactionTime(transaction.getTransactionTime());
        if (transaction.getGroupTransactionBalance() != null) {
            bean.setGroupBalanceBefore(transaction.getGroupTransactionBalance().getBalanceBefore());
            bean.setGroupBalanceAfter(transaction.getGroupTransactionBalance().getBalanceAfter());
        }
        if (transaction.getTransactionBalance() != null) {
            bean.setBalanceBefore(new BigDecimal(transaction.getTransactionBalance().getBalanceBeforeTransaction() + ""));
            bean.setBalanceAfter(new BigDecimal(transaction.getTransactionBalance().getBalanceAfterTransaction() + ""));
        }
        bean.setPurchasePrice(new BigDecimal(transaction.getBatchUnitPrice() + ""));
        bean.setCostToGroup(new BigDecimal(transaction.getUnitGroupPrice() + ""));
        bean.setCostToAgent(new BigDecimal(transaction.getSecondaryTransactionPrice() + ""));
        bean.setCostToCustomer(new BigDecimal(transaction.getUnitPurchasePrice() + ""));
        bean.setCustomer(transaction.getCustomer().getCompanyName());
        bean.setProductName(transaction.getProduct().getProductName() + " - " + transaction.getProduct().getProductFaceValue());
        bean.setRetailPrice(new BigDecimal(transaction.getProduct().getProductFaceValue() * transaction.getQuantity() + ""));
        bean.setQuantity(transaction.getQuantity());

        return bean;
    }

    public static BalanceReportBean toBean(TDingTransactions transaction) {
        BalanceReportBean bean = new BalanceReportBean();

        bean.setTransactionId(transaction.getTransactionId());
        bean.setTransactionTime(transaction.getTransactionTime());
        if (transaction.getGroupTransactionBalance() != null) {
            bean.setGroupBalanceBefore(transaction.getGroupTransactionBalance().getBalanceBefore());
            bean.setGroupBalanceAfter(transaction.getGroupTransactionBalance().getBalanceAfter());
        }
        if (transaction.getTransactionBalance() != null) {
            bean.setBalanceBefore(new BigDecimal(transaction.getTransactionBalance().getBalanceBeforeTransaction() + ""));
            bean.setBalanceAfter(new BigDecimal(transaction.getTransactionBalance().getBalanceAfterTransaction() + ""));
        }
        bean.setPurchasePrice(new BigDecimal(transaction.getCostToEezeeTel() + ""));
        bean.setCostToGroup(new BigDecimal(transaction.getCostToGroup() + ""));
        bean.setCostToAgent(new BigDecimal(transaction.getCostToAgent() + ""));
        bean.setCostToCustomer(new BigDecimal(transaction.getCostToCustomer() + ""));
        bean.setCustomer(transaction.getCustomer().getCompanyName());
        bean.setProductName("Mobile Topup");
        bean.setRetailPrice(new BigDecimal(transaction.getProductRequested() + ""));
        bean.setQuantity(1);

        return bean;
    }

    public static BalanceReportBean toBean(MobitopupTransaction transaction) {
        BalanceReportBean bean = new BalanceReportBean();

        bean.setTransactionId(transaction.getTransactionId());
        bean.setTransactionTime(transaction.getTransactionTime());
        if (transaction.getGroupTransactionBalance() != null) {
            bean.setGroupBalanceBefore(transaction.getGroupTransactionBalance().getBalanceBefore());
            bean.setGroupBalanceAfter(transaction.getGroupTransactionBalance().getBalanceAfter());
        }
        if (transaction.getTransactionBalance() != null) {
            bean.setBalanceBefore(new BigDecimal(transaction.getTransactionBalance().getBalanceBeforeTransaction() + ""));
            bean.setBalanceAfter(new BigDecimal(transaction.getTransactionBalance().getBalanceAfterTransaction() + ""));
        }
        bean.setPurchasePrice(transaction.getPrice());
        bean.setCostToGroup(transaction.getPrice().add(transaction.getEezeetelCommission()));
        bean.setCostToAgent(bean.getCostToGroup().add(transaction.getGroupCommission()));
        bean.setCostToCustomer(bean.getCostToAgent().add(transaction.getAgentCommission()));
        bean.setCustomer(transaction.getCustomer().getCompanyName());
        bean.setProductName("Mobitopup");
        bean.setRetailPrice(transaction.getRetailPrice());
        bean.setQuantity(1);

        return bean;
    }

    public static BalanceReportBean toBean(PinlessTransaction transaction) {
        BalanceReportBean bean = new BalanceReportBean();

        bean.setTransactionId(transaction.getTransactionId());
        bean.setTransactionTime(transaction.getTransactionTime());
        if (transaction.getGroupTransactionBalance() != null) {
            bean.setGroupBalanceBefore(transaction.getGroupTransactionBalance().getBalanceBefore());
            bean.setGroupBalanceAfter(transaction.getGroupTransactionBalance().getBalanceAfter());
        }
        if (transaction.getTransactionBalance() != null) {
            bean.setBalanceBefore(new BigDecimal(transaction.getTransactionBalance().getBalanceBeforeTransaction() + ""));
            bean.setBalanceAfter(new BigDecimal(transaction.getTransactionBalance().getBalanceAfterTransaction() + ""));
        }
        bean.setPurchasePrice(transaction.getPrice());
        bean.setCostToGroup(transaction.getPrice().add(transaction.getEezeetelCommission()));
        bean.setCostToAgent(bean.getCostToGroup().add(transaction.getGroupCommission()));
        bean.setCostToCustomer(bean.getCostToAgent().add(transaction.getAgentCommission()));
        bean.setCustomer(transaction.getCustomer().getCompanyName());
        bean.setProductName("Pinless");
        bean.setRetailPrice(transaction.getRetailPrice());
        bean.setQuantity(1);

        return bean;
    }

    public static BalanceReportBean toBean(MobileUnlockingOrder transaction) {
        BalanceReportBean bean = new BalanceReportBean();

        bean.setTransactionId(transaction.getTransactionId());
        bean.setTransactionTime(transaction.getCreatedDate());
        if (transaction.getTransactionBalance() != null) {
            bean.setBalanceBefore(new BigDecimal(transaction.getTransactionBalance().getBalanceBeforeTransaction() + ""));
            bean.setBalanceAfter(new BigDecimal(transaction.getTransactionBalance().getBalanceAfterTransaction() + ""));
        }
        bean.setPurchasePrice(transaction.getPrice());
        bean.setCostToGroup(transaction.getPrice().add(transaction.getEezeetelCommission()));
        bean.setCostToAgent(bean.getCostToGroup().add(transaction.getGroupCommission()));
        bean.setCostToCustomer(bean.getCostToAgent().add(transaction.getAgentCommission()));
        bean.setCustomer(transaction.getCustomer().getCompanyName());
        bean.setProductName(transaction.getMobileUnlocking().getTitle());
        bean.setRetailPrice(transaction.getSellingPrice());
        bean.setQuantity(1);

        return bean;
    }

    @Override
    public boolean equals(Object object) {
        boolean sameSame = false;

        if (object != null && object instanceof BalanceReportBean) {
            sameSame = Objects.equals(this.transactionId, ((BalanceReportBean) object).getTransactionId());
        }

        return sameSame;
    }
}
