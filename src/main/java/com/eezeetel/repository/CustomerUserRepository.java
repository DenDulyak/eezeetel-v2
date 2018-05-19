package com.eezeetel.repository;

import com.eezeetel.entity.TCustomerUsers;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.stereotype.Repository;

import javax.persistence.LockModeType;

@Repository
public interface CustomerUserRepository extends JpaRepository<TCustomerUsers, Integer> {

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    TCustomerUsers findByUserLogin(String login);
}
