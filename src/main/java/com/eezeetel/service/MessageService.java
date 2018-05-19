package com.eezeetel.service;

import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMessages;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface MessageService {

    List<TMessages> findByGroup(TMasterCustomerGroups group);
    TMessages save(TMessages message);
    List<TMessages> setMessageToGroup(Integer groupId, String messageText);
    void deleteFromGroup(TMasterCustomerGroups group);
}
