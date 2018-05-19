package com.eezeetel.service.impl;

import com.eezeetel.entity.User;
import com.eezeetel.entity.TUserLog;
import com.eezeetel.repository.UserLogRepository;
import com.eezeetel.service.UserLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by Denis Dulyak on 13.01.2016.
 */
@Service
public class UserLogServiceImpl implements UserLogService {

    @Autowired
    private UserLogRepository userLogRepository;

    @Override
    public TUserLog save(TUserLog log) {
        return userLogRepository.save(log);
    }

    @Override
    public TUserLog findByUserAndSessionId(User user, String sessionId) {
        return userLogRepository.findByUserAndSessionId(user, sessionId);
    }
}
