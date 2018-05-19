package com.eezeetel.service;

import com.eezeetel.entity.TMasterUserTypeAndPrivilege;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface UserTypeService {

    List<TMasterUserTypeAndPrivilege> findAll();
    TMasterUserTypeAndPrivilege findOne(Integer id);
}
