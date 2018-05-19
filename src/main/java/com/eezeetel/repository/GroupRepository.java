package com.eezeetel.repository;

import com.eezeetel.entity.TMasterCustomerGroups;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * Created by Denis Dulyak on 09.12.2015.
 */
public interface GroupRepository extends JpaRepository<TMasterCustomerGroups, Integer> {

    List<TMasterCustomerGroups> findByActiveTrue();

    List<TMasterCustomerGroups> findByActiveTrueAndCheckAganinstGroupBalanceTrue();
}
