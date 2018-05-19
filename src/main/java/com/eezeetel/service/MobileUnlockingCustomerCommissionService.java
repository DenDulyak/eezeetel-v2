package com.eezeetel.service;

import com.eezeetel.entity.MobileUnlockingCommission;
import com.eezeetel.entity.MobileUnlockingCustomerCommission;
import com.eezeetel.entity.TMasterCustomerinfo;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Service
public interface MobileUnlockingCustomerCommissionService {

    MobileUnlockingCustomerCommission save(MobileUnlockingCustomerCommission commission);
    MobileUnlockingCustomerCommission findByCustomerAndMobileUnlockingCommission(TMasterCustomerinfo customer, MobileUnlockingCommission commission);
    List<MobileUnlockingCustomerCommission> findOrCreateBySupplierAndCustomer(Integer groupId, Integer supplierId, Integer customerId);
    List<MobileUnlockingCustomerCommission> findOrCreateBySupplierAndCustomer(Integer groupId, Integer supplierId, TMasterCustomerinfo customer);
    MobileUnlockingCustomerCommission updateCustomerCommission(Integer customerCommissionId, BigDecimal eezeetelCommission, BigDecimal agentCommission);
    List<MobileUnlockingCustomerCommission> updateTable(Map<String, String> map);
    List<MobileUnlockingCustomerCommission> copyCommissions(Integer customerFrom, Integer customerTo);
    List<MobileUnlockingCustomerCommission> copyCommissionsToCustomer(List<MobileUnlockingCustomerCommission> commissionsFrom, TMasterCustomerinfo toCustomer);
}
