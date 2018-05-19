package com.eezeetel.repository;

import com.eezeetel.entity.TMasterProducttype;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Created by Denis Dulyak on 28.11.2016.
 */
@Repository
public interface ProductTypeRepository extends JpaRepository<TMasterProducttype, Short> {
}
