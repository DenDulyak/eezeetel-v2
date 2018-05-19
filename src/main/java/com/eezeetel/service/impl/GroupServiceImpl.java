package com.eezeetel.service.impl;

import com.eezeetel.bean.GroupBean;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.repository.GroupRepository;
import com.eezeetel.service.CustomerService;
import com.eezeetel.service.GroupService;
import com.eezeetel.service.UserService;
import org.apache.commons.lang.BooleanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * Created by Denis Dulyak on 17.09.2015.
 */
@Service
public class GroupServiceImpl implements GroupService {

    @Autowired
    private GroupRepository repository;

    @Autowired
    private UserService userService;

    @Autowired
    private CustomerService customerService;

    @Override
    public TMasterCustomerGroups findOne(Integer id) {
        return repository.findOne(id);
    }

    @Override
    public List<TMasterCustomerGroups> findAll() {
        return repository.findAll();
    }

    @Override
    public List<TMasterCustomerGroups> findAllActive() {
        return repository.findByActiveTrue();
    }

    @Override
    public List<TMasterCustomerGroups> findAllActiveAndCheckAganinstGroupBalance() {
        return repository.findByActiveTrueAndCheckAganinstGroupBalanceTrue();
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public TMasterCustomerGroups save(TMasterCustomerGroups group) {
        return repository.save(group);
    }

    @Override
    public TMasterCustomerGroups createOrUpdate(GroupBean bean) {
        TMasterCustomerGroups group;
        List<TMasterCustomerinfo> customerinfos = customerService.findByName(bean.getDefaultCustomerInfo());
        if (bean.getId() != null) {
            group = findOne(bean.getId());
            if (!group.getDefaultCustomer().getCompanyName().equals(bean.getDefaultCustomerInfo())) {
                if (!customerinfos.isEmpty()) {
                    group.setDefaultCustomer(customerinfos.get(0));
                }
            }
        } else {
            group = new TMasterCustomerGroups();
            group.setCreatedBy(userService.findByLogin(bean.getCreateBy()));
            if (!customerinfos.isEmpty()) {
                group.setDefaultCustomer(customerinfos.get(0));
            }
            group.setCustomerSince(new Date());
        }
        group.setName(bean.getName());
        group.setNotes(bean.getNotes());
        group.setActive(BooleanUtils.isTrue(bean.getActive()));
        group.setCustomerGroupBalance(bean.getBalance());
        group.setCheckAganinstGroupBalance(BooleanUtils.isTrue(bean.getCheckAganinstGroupBalance()));
        group.setApplyDefaultCustomerPercentages(BooleanUtils.isTrue(bean.getApplyDefaultCustomerPercentages()));
        group.setGroupAddress(bean.getAddress());
        group.setGroupCity(bean.getCity());
        group.setGroupPinCode(bean.getPinCode());
        group.setGroupPhone(bean.getPhone());
        group.setGroupMobile(bean.getMobile());
        group.setGroupEmailId(bean.getEmail());
        group.setCompanyRegNo(bean.getCompanyRegNo());
        group.setVatRegNo(bean.getVatRegNo());
        group.setSellAtFaceValue(BooleanUtils.isTrue(bean.getSellAtFaceValue()));
        group.setStyle(bean.getStyle());

        return save(group);
    }
}
