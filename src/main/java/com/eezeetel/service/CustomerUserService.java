package com.eezeetel.service;

import com.eezeetel.entity.TCustomerUsers;
import org.springframework.stereotype.Service;

@Service
public interface CustomerUserService {

    TCustomerUsers findByLogin(String login);
}
