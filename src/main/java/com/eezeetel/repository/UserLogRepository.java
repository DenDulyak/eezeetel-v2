package com.eezeetel.repository;

import com.eezeetel.entity.User;
import com.eezeetel.entity.TUserLog;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Created by Denis Dulyak on 13.01.2016.
 */
public interface UserLogRepository extends JpaRepository<TUserLog, Integer> {

    TUserLog findByUserAndSessionId(User user, String sessionId);
}
