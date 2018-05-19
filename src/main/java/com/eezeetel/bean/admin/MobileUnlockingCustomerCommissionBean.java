package com.eezeetel.bean.admin;

import com.eezeetel.entity.MobileUnlockingCustomerCommission;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * Created by Denis Dulyak on 24.12.2015.
 */
@Getter
@Setter
@NoArgsConstructor
public class MobileUnlockingCustomerCommissionBean {

    private Integer id;
    private String mobileUnlocking;
    private BigDecimal unitPrice;
    private BigDecimal groupCommission;
    private BigDecimal agentCommission;

    public static MobileUnlockingCustomerCommissionBean toBean(MobileUnlockingCustomerCommission commission) {
        MobileUnlockingCustomerCommissionBean bean = new MobileUnlockingCustomerCommissionBean();
        bean.setId(commission.getId());
        bean.setMobileUnlocking(commission.getMobileUnlockingCommission().getMobileUnlocking().getTitle());
        bean.setUnitPrice(commission.getMobileUnlockingCommission().getCommission().add(commission.getMobileUnlockingCommission().getMobileUnlocking().getPurchasePrice()));
        bean.setGroupCommission(commission.getGroupCommission());
        bean.setAgentCommission(commission.getAgentCommission());
        return bean;
    }
}
