package com.eezeetel.service;

import com.eezeetel.entity.RequestLog;
import com.eezeetel.entity.User;
import org.springframework.stereotype.Service;

@Service
public interface RequestLogService {

    boolean existsByUserAndKey(User user, Long key);
    RequestLog addLog(User user, Long key, String md5);
}
