package com.eezeetel.bean.mobileUnlocking;

import com.eezeetel.entity.MobileUnlocking;
import com.eezeetel.entity.MobileUnlockingCommission;
import com.eezeetel.entity.MobileUnlockingCustomerCommission;
import com.eezeetel.entity.TMasterCustomerinfo;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * Created by Denis Dulyak on 15.12.2015.
 */
@Getter
@Setter
public class MobileUnlockingBean {

    private Integer id;
    private String title;
    private Integer supplierId;
    private String deliveryTime;
    private BigDecimal purchasePrice;
    private BigDecimal sellingPrice;
    private String transactionCondition;
    private String notes;
    private Boolean active;

    private String customerName;
    private String customerMobileNumber;
    private String customerNotes;

    public static MobileUnlockingBean toBean(MobileUnlocking mobileUnlocking) {
        MobileUnlockingBean bean = new MobileUnlockingBean();
        bean.setId(mobileUnlocking.getId());
        bean.setTitle(mobileUnlocking.getTitle());
        bean.setSupplierId(mobileUnlocking.getSupplier().getId());
        bean.setDeliveryTime(mobileUnlocking.getDeliveryTime());
        bean.setPurchasePrice(mobileUnlocking.getPurchasePrice());
        bean.setTransactionCondition(mobileUnlocking.getTransactionCondition());
        bean.setNotes(mobileUnlocking.getNotes());
        bean.setActive(mobileUnlocking.getActive());
        return bean;
    }

    public static MobileUnlockingBean toBean(MobileUnlocking mobileUnlocking, MobileUnlockingCommission commission, MobileUnlockingCustomerCommission customerCommission, TMasterCustomerinfo customer) {
        MobileUnlockingBean bean = toBean(mobileUnlocking);

        BigDecimal sellingPrice = mobileUnlocking.getPurchasePrice()
                .add(commission.getCommission())
                .add(customerCommission.getGroupCommission())
                .add(customerCommission.getAgentCommission());

        bean.setSellingPrice(sellingPrice);
        bean.setCustomerName(customer.getCompanyName());
        bean.setCustomerMobileNumber(customer.getMobilePhone());
        bean.setCustomerNotes(customer.getNotes());
        return bean;
    }
}
