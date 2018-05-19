package com.eezeetel.bean;

import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.enums.GroupStyle;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;

/**
 * Created by Denis Dulyak on 17.09.2015.
 */
@Getter
@Setter
public class GroupBean {

    private Integer id;
    private String defaultCustomerInfo;
    private String createBy;
    private String name;
    private Date customerSince;
    private String notes;
    private Boolean active;
    private float balance;
    private Boolean checkAganinstGroupBalance;
    private Boolean applyDefaultCustomerPercentages;
    private String address;
    private String city;
    private String pinCode;
    private String phone;
    private String mobile;
    private String email;
    private String companyRegNo;
    private String vatRegNo;
    private Boolean sellAtFaceValue;
    private GroupStyle style = GroupStyle.DEFAULT;

    public static GroupBean toBean(TMasterCustomerGroups group) {
        GroupBean bean = new GroupBean();
        bean.setId(group.getId());
        bean.setDefaultCustomerInfo(group.getDefaultCustomer().getCompanyName());
        bean.setCreateBy(group.getCreatedBy().getLogin());
        bean.setName(group.getName());
        bean.setCustomerSince(group.getCustomerSince());
        bean.setNotes(group.getNotes());
        bean.setActive(group.getActive());
        bean.setBalance(group.getCustomerGroupBalance());
        bean.setCheckAganinstGroupBalance(group.getCheckAganinstGroupBalance());
        bean.setApplyDefaultCustomerPercentages(group.getApplyDefaultCustomerPercentages());
        bean.setAddress(group.getGroupAddress());
        bean.setCity(group.getGroupCity());
        bean.setPinCode(group.getGroupPinCode());
        bean.setPhone(group.getGroupPhone());
        bean.setMobile(group.getGroupMobile());
        bean.setEmail(group.getGroupEmailId());
        bean.setCompanyRegNo(group.getCompanyRegNo());
        bean.setVatRegNo(group.getVatRegNo());
        bean.setSellAtFaceValue(group.getSellAtFaceValue());
        bean.setStyle(group.getStyle());
        return bean;
    }
}
