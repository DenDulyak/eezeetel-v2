package com.eezeetel.repository;

import com.eezeetel.entity.PhoneTopupCountry;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.WorldTopupGroupCommission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Created by Denis Dulyak on 09.06.2016.
 */
@Repository
public interface WorldTopupGroupCommissionRepository extends JpaRepository<WorldTopupGroupCommission, Integer> {

    WorldTopupGroupCommission findByCountryAndGroup(PhoneTopupCountry country, TMasterCustomerGroups group);
}
