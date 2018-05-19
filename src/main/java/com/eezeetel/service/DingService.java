package com.eezeetel.service;

import com.ding.DingMain;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface DingService {

    List<DingMain.AmountsAndCommission> getTickets(String iso, Integer groupId);
    List<DingMain.AmountsAndCommission> getTickets(String iso, Integer groupId, Integer customerId);
    List<DingMain.AmountsAndCommission> getTicketsByOperator(Integer countryId, String operatorCode, Integer groupId);
}
