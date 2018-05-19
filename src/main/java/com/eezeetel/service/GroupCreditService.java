package com.eezeetel.service;

import com.eezeetel.entity.TMasterCustomerGroupCredit;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Date;

@Service
public interface GroupCreditService {

    TMasterCustomerGroupCredit findOne(Integer id);
    TMasterCustomerGroupCredit save(TMasterCustomerGroupCredit credit);
    BigDecimal calcGroupCreditAmountBetweenDates(Integer groupId, Date startDate, Date endDate);
}
