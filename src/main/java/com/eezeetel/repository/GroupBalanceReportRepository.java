package com.eezeetel.repository;

import com.eezeetel.entity.GroupBalanceReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * Created by Denis Dulyak on 16.01.2017.
 */
@Repository
public interface GroupBalanceReportRepository extends JpaRepository<GroupBalanceReport, Integer> {

    List<GroupBalanceReport> findByDay(Date day);

    @Query(value = "select sum(r.topup) from group_balance_report r where r.group_id = ?1 and r.day between ?2 and ?3 ", nativeQuery = true)
    BigDecimal calcToupByGroupAndBetweenDates(Integer groupId, Date startDate, Date endDate);

    @Query(value = "select sum(r.sales) from group_balance_report r where r.group_id = ?1 and r.day between ?2 and ?3 ", nativeQuery = true)
    BigDecimal calcSalesByGroupAndBetweenDates(Integer groupId, Date startDate, Date endDate);

    @Query(value = "select sum(r.transactions) from group_balance_report r where r.group_id = ?1 and r.day between ?2 and ?3 ", nativeQuery = true)
    Integer calcTransactionsByGroupAndBetweenDates(Integer groupId, Date startDate, Date endDate);

    @Query(value = "select sum(r.quantity) from group_balance_report r where r.group_id = ?1 and r.day between ?2 and ?3 ", nativeQuery = true)
    Integer calcQuantityByGroupAndBetweenDates(Integer groupId, Date startDate, Date endDate);
}
