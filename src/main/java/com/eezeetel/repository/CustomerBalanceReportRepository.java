package com.eezeetel.repository;

import com.eezeetel.entity.CustomerBalanceReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

/**
 * Created by Denis Dulyak on 16.01.2017.
 */
@Repository
public interface CustomerBalanceReportRepository extends JpaRepository<CustomerBalanceReport, Integer> {

    List<CustomerBalanceReport> findByDay(Date day);
    List<CustomerBalanceReport> findByCustomerGroupIdAndDay(Integer groupId, Date day);
}
