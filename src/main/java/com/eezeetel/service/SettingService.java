package com.eezeetel.service;

import com.eezeetel.entity.Setting;
import com.eezeetel.enums.SettingType;
import org.springframework.stereotype.Service;

@Service
public interface SettingService {

    Setting findByType(SettingType type);
    Setting updateValue(SettingType type, String value);
}
