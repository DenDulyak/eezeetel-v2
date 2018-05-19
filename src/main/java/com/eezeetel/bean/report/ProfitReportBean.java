package com.eezeetel.bean.report;

import com.eezeetel.entity.MobileUnlockingOrder;
import com.eezeetel.entity.MobitopupTransaction;
import com.eezeetel.entity.TDingTransactions;
import com.eezeetel.mobitopup.MobitopupUtil;
import com.eezeetel.util.PriceUtil;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * Created by Denis Dulyak on 03.11.2016.
 */
@Getter
@Setter
public class ProfitReportBean {

    private String customer;
    private String product;
    private Integer transactions;
    private Integer quantity;
    private BigDecimal costPrice;
    private BigDecimal groupPrice;
    private BigDecimal agentPrice;
    private BigDecimal customerPrice;

    private String provider;

    /*For Vat Report */
    private Integer productTypeId;
    private String productType;
    private Integer supplierId;
    private String supplier;
    private Short calculateVat;
    private Boolean localProduct;
    private BigDecimal netSales;
    private BigDecimal vat;
    private BigDecimal profit;

    public static ProfitReportBean toBean(TDingTransactions transaction, Integer groupId, BigDecimal returnPercent) {
        ProfitReportBean bean = new ProfitReportBean();

        bean.setCustomer(transaction.getCustomer().getCompanyName());
        bean.setProduct(transaction.getDestinationOperator());

        BigDecimal productSent = new BigDecimal(transaction.getProductSent() + "");
        Boolean isDigicel = MobitopupUtil.isDigicel(transaction.getDestinationCountryId(), transaction.getDestinationOperatorId());
        if (groupId == 0 && isDigicel) {
            bean.setCostPrice(productSent.subtract(PriceUtil.getPercent(productSent, returnPercent)));
            if (transaction.getCustomer().getGroup().getId() == 1) {
                bean.setGroupPrice(productSent.subtract(PriceUtil.getPercent(productSent, returnPercent)));
            } else {
                bean.setGroupPrice(new BigDecimal(transaction.getCostToGroup() + ""));
            }
        } else if (groupId == 1 && isDigicel) {
            bean.setCostPrice(productSent.subtract(PriceUtil.getPercent(productSent, returnPercent)));
            bean.setGroupPrice(productSent.subtract(PriceUtil.getPercent(productSent, returnPercent)));
        } else {
            bean.setCostPrice(productSent);
            bean.setGroupPrice(new BigDecimal(transaction.getCostToGroup() + ""));
        }

        bean.setAgentPrice(new BigDecimal(transaction.getCostToAgent() + ""));
        bean.setCustomerPrice(new BigDecimal(transaction.getCostToCustomer() + ""));
        bean.setProvider("Ding");

        return bean;
    }

    public static ProfitReportBean toBean(MobitopupTransaction transaction) {
        ProfitReportBean bean = new ProfitReportBean();

        bean.setCustomer(transaction.getCustomer().getCompanyName());
        bean.setProduct(transaction.getNetwork());
        bean.setCostPrice(transaction.getPrice());
        bean.setGroupPrice(transaction.getPrice().add(transaction.getEezeetelCommission()));
        bean.setAgentPrice(transaction.getPrice()
                        .add(transaction.getEezeetelCommission())
                        .add(transaction.getGroupCommission())
        );
        bean.setCustomerPrice(transaction.getPrice()
                        .add(transaction.getEezeetelCommission())
                        .add(transaction.getGroupCommission())
                        .add(transaction.getAgentCommission())
        );
        //todo: pinless
        bean.setProvider("Mobitopup");

        return bean;
    }

    public static ProfitReportBean toBean(MobileUnlockingOrder transaction) {
        ProfitReportBean bean = new ProfitReportBean();

        bean.setCustomer(transaction.getCustomer().getCompanyName());
        bean.setProduct(transaction.getMobileUnlocking().getTitle());
        bean.setCostPrice(transaction.getPrice());
        bean.setGroupPrice(transaction.getPrice().add(transaction.getEezeetelCommission()));
        bean.setAgentPrice(transaction.getPrice()
                        .add(transaction.getEezeetelCommission())
                        .add(transaction.getGroupCommission())
        );
        bean.setCustomerPrice(transaction.getPrice()
                        .add(transaction.getEezeetelCommission())
                        .add(transaction.getGroupCommission())
                        .add(transaction.getAgentCommission())
        );

        return bean;
    }
}
