package com.eezeetel.repository;

import com.eezeetel.entity.Title;
import com.eezeetel.enums.TitleType;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Created by Denis Dulyak on 10.03.2016.
 */
public interface TitleRepository extends JpaRepository<Title, Integer> {

    Title findByType(TitleType type);
}
