package com.eezeetel.repository;

import com.eezeetel.entity.RequestLog;
import com.eezeetel.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Created by Denis Dulyak on 07.02.2017.
 */
@Repository
public interface RequestLogRepository extends JpaRepository<RequestLog, Long> {

    RequestLog findByUserAndKey(User user, Long key);
}
