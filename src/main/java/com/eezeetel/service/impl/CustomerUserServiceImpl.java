package com.eezeetel.service.impl;

import com.eezeetel.entity.TCustomerUsers;
import com.eezeetel.repository.CustomerUserRepository;
import com.eezeetel.service.CustomerUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by Denis Dulyak on 01.10.2015.
 */
@Service
public class CustomerUserServiceImpl implements CustomerUserService {

    @Autowired
    private CustomerUserRepository repository;

    @Transactional(propagation = Propagation.REQUIRED)
    public TCustomerUsers findByLogin(String login) {
        return repository.findByUserLogin(login);
    }
}
