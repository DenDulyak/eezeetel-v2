package com.eezeetel.service;

import com.eezeetel.entity.TUserLog;
import com.eezeetel.entity.User;
import org.springframework.stereotype.Service;

@Service
public interface UserLogService {

    TUserLog save(TUserLog log);
    TUserLog findByUserAndSessionId(User user, String sessionId);
}
