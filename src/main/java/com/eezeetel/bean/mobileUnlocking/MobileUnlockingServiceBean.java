package com.eezeetel.bean.mobileUnlocking;

import com.eezeetel.entity.MobileUnlockingCustomerCommission;
import com.eezeetel.entity.TMasterSupplierinfo;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Created by Denis Dulyak on 28.12.2015.
 */
@Getter
@Setter
public class MobileUnlockingServiceBean {

    private String seriviceName;
    private List<MobileUnlockingBean> mobileUnlockings;

    public static MobileUnlockingServiceBean toBean(TMasterSupplierinfo supplierinfo, List<MobileUnlockingCustomerCommission> commissions) {
        MobileUnlockingServiceBean bean = new MobileUnlockingServiceBean();
        bean.setSeriviceName(supplierinfo.getSupplierName());
        bean.setMobileUnlockings(commissions
                .stream()
                .map(commission ->
                        MobileUnlockingBean.toBean(commission.getMobileUnlockingCommission().getMobileUnlocking()))
                .collect(Collectors.toList()));
        return bean;
    }
}
