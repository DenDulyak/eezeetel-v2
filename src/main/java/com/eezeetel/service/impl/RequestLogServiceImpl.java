package com.eezeetel.service.impl;

import com.eezeetel.entity.RequestLog;
import com.eezeetel.entity.User;
import com.eezeetel.repository.RequestLogRepository;
import com.eezeetel.service.RequestLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;

/**
 * Created by Denis Dulyak on 07.02.2017.
 */
@Service
public class RequestLogServiceImpl implements RequestLogService {

    @Autowired
    private RequestLogRepository repository;

    @Override
    public boolean existsByUserAndKey(User user, Long key) {
        return repository.findByUserAndKey(user, key) != null;
    }

    @Override
    public RequestLog addLog(User user, Long key, String md5) {
        RequestLog log = new RequestLog();
        log.setUser(user);
        log.setKey(key);
        log.setHex(md5);
        log.setDate(new Date());
        return repository.save(log);
    }
}
