package com.eezeetel.bean.mobileUnlocking;

import com.eezeetel.entity.MobileUnlockingOrder;
import com.eezeetel.enums.OrderStatus;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * Created by Denis Dulyak on 27.01.2016.
 */
@Getter
@Setter
public class MobileUnlockingOrderBean {

    private Integer id;
    private Integer mobileUnlockingId;
    private String mobileUnlockingTitle;
    private String user;
    private String assigned;
    private Long transactionId;
    private String imei;
    private List<String> imeis;
    private String code;
    private BigDecimal price;
    private String shopKeeperName;
    private String customerEmail;
    private String mobileNumber;
    private OrderStatus status;
    private Date createdDate;
    private Date updatedDate;
    private String notes;

    public static MobileUnlockingOrderBean toBean(MobileUnlockingOrder order) {
        MobileUnlockingOrderBean bean = new MobileUnlockingOrderBean();
        bean.setId(order.getId());
        bean.setMobileUnlockingId(order.getMobileUnlocking().getId());
        bean.setMobileUnlockingTitle(order.getMobileUnlocking().getTitle());
        bean.setUser(order.getUser().getLogin());
        bean.setAssigned(order.getAssigned() == null ? "" : order.getAssigned().getLogin());
        bean.setTransactionId(order.getTransactionId());
        bean.setImei(order.getImei());
        bean.setCode(order.getCode());
        bean.setPrice(order.getPrice());
        bean.setShopKeeperName(order.getUser().getCustomerUsers().get(0).getCustomer().getCompanyName());
        bean.setCustomerEmail(order.getCustomerEmail());
        bean.setMobileNumber(order.getMobileNumber());
        bean.setStatus(order.getStatus());
        bean.setCreatedDate(order.getCreatedDate());
        bean.setUpdatedDate(order.getUpdatedDate());
        bean.setNotes(order.getNotes() == null ? "" : order.getNotes());
        return bean;
    }
}
