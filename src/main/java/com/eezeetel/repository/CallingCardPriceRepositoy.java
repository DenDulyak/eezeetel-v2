package com.eezeetel.repository;

import com.eezeetel.entity.CallingCardPrice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Created by Denis Dulyak on 07.03.2016.
 */
@Repository
public interface CallingCardPriceRepositoy extends JpaRepository<CallingCardPrice, Integer> {
}
