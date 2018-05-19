package com.eezeetel.service.impl;

import com.eezeetel.entity.TMasterUserTypeAndPrivilege;
import com.eezeetel.repository.UserTypeRepository;
import com.eezeetel.service.UserTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by Denis Dulyak on 18.12.2015.
 */
@Service
public class UserTypeServiceImpl implements UserTypeService {

    @Autowired
    private UserTypeRepository userTypeRepository;

    @Override
    public List<TMasterUserTypeAndPrivilege> findAll() {
        return userTypeRepository.findAll();
    }

    @Override
    public TMasterUserTypeAndPrivilege findOne(Integer id) {
        return userTypeRepository.findOne(id.shortValue());
    }
}
