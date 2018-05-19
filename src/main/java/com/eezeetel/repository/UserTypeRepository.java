package com.eezeetel.repository;

import com.eezeetel.entity.TMasterUserTypeAndPrivilege;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

/**
 * Created by Denis Dulyak on 18.12.2015.
 */
public interface UserTypeRepository extends JpaRepository<TMasterUserTypeAndPrivilege, Integer> {

    @Query(value = "select t from TMasterUserTypeAndPrivilege t where t.id = ?1 ")
    public TMasterUserTypeAndPrivilege findOne(Short id);
}
