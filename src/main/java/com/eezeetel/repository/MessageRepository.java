package com.eezeetel.repository;

import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMessages;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * Created by Denis Dulyak on 30.12.2015.
 */
public interface MessageRepository extends JpaRepository<TMessages, Integer> {

    List<TMessages> findByGroupAndActiveTrue(TMasterCustomerGroups group);
}
