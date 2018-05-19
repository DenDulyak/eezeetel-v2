package com.eezeetel.service.impl;

import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMessages;
import com.eezeetel.repository.MessageRepository;
import com.eezeetel.service.GroupService;
import com.eezeetel.service.MessageService;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * Created by Denis Dulyak on 01.10.2015.
 */
@Service
public class MessageServiceImpl implements MessageService {

    @Autowired
    private MessageRepository repository;

    @Autowired
    private GroupService groupService;

    @Override
    public List<TMessages> findByGroup(TMasterCustomerGroups group) {
        return repository.findByGroupAndActiveTrue(group);
    }

    @Override
    public TMessages save(TMessages message) {
        return repository.save(message);
    }

    @Override
    public List<TMessages> setMessageToGroup(Integer groupId, String messageText) {
        TMasterCustomerGroups group = groupService.findOne(groupId);
        List<TMessages> messages = findByGroup(group);
        Date dateEntered = new Date();
        Date expiryDate = DateUtils.addDays(dateEntered, 1);

        if (!messages.isEmpty()) {
            for (TMessages message : messages) {
                message.setMessage(messageText);
                message.setExpiryDate(expiryDate);
            }
            messages = repository.save(messages);
        } else {
            TMessages message = new TMessages();
            message.setDateEntered(dateEntered);
            message.setMessage(messageText);
            message.setGroup(group);
            message.setExpiryDate(expiryDate);
            message.setActive(true);
            messages.add(save(message));
        }

        return messages;
    }

    @Override
    public void deleteFromGroup(TMasterCustomerGroups group) {
        repository.delete(findByGroup(group));
    }
}
