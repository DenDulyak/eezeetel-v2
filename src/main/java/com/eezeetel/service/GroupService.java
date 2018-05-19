package com.eezeetel.service;

import com.eezeetel.bean.GroupBean;
import com.eezeetel.entity.TMasterCustomerGroups;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface GroupService {

    TMasterCustomerGroups findOne(Integer id);
    List<TMasterCustomerGroups> findAll();
    List<TMasterCustomerGroups> findAllActive();
    List<TMasterCustomerGroups> findAllActiveAndCheckAganinstGroupBalance();
    TMasterCustomerGroups save(TMasterCustomerGroups group);
    TMasterCustomerGroups createOrUpdate(GroupBean bean);
}
