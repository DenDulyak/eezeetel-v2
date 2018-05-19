package com.eezeetel.service;

import com.eezeetel.entity.PinlessGroupCommission;
import org.springframework.stereotype.Service;

@Service
public interface PinlessGroupCommissionService {

    PinlessGroupCommission findByGroupId(Integer groupId);
    PinlessGroupCommission update(Integer groupId, Integer percent);
}
