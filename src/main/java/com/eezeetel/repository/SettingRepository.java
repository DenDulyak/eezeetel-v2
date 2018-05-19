package com.eezeetel.repository;

import com.eezeetel.entity.Setting;
import com.eezeetel.enums.SettingType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Created by Denis Dulyak on 23.11.2016.
 */
@Repository
public interface SettingRepository extends JpaRepository<Setting, Integer> {

    Setting findByType(SettingType type);
}
