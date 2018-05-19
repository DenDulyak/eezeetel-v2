package com.eezeetel.repository;

import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMasterCustomerinfo;
import com.eezeetel.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * Created by Denis Dulyak on 09.12.2015.
 */
public interface CustomerRepository extends JpaRepository<TMasterCustomerinfo, Integer> {

    List<TMasterCustomerinfo> findByGroup(TMasterCustomerGroups group);

    List<TMasterCustomerinfo> findByCompanyName(String name);

    List<TMasterCustomerinfo> findByGroupAndIntroducedByAndActiveTrue(TMasterCustomerGroups group, User introducedBy);

    List<TMasterCustomerinfo> findByActiveTrue();

    List<TMasterCustomerinfo> findByGroupAndActiveTrue(TMasterCustomerGroups group);
}
