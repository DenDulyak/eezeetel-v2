package com.eezeetel.service;

import com.eezeetel.entity.TMasterCustomerCredit;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by Denis Dulyak on 12.01.2017.
 */
@Service
public interface CustomerCreditService {

    Page<TMasterCustomerCredit> findByGroupAndEnteredTime(Integer groupId, Integer customerId, Date enteredTime, Integer status, PageRequest pageRequest);
    BigDecimal calcCustomerCreditAmountBetweenDates(Integer customerId, Date startDate, Date endDate);
}
