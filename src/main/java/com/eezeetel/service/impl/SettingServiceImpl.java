package com.eezeetel.service.impl;

import com.eezeetel.entity.Setting;
import com.eezeetel.enums.SettingType;
import com.eezeetel.repository.SettingRepository;
import com.eezeetel.service.SettingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SettingServiceImpl implements SettingService {

    @Autowired
    private SettingRepository repository;

    @Override
    public Setting findByType(SettingType type) {
        Setting setting = repository.findByType(type);
        if (setting == null) {
            setting = create(type);
        }
        return setting;
    }

    private Setting create(SettingType type) {
        Setting setting = new Setting();
        setting.setType(type);
        setting.setValue(type.getDefaultVal());
        return repository.save(setting);
    }

    @Override
    public Setting updateValue(SettingType type, String value) {
        Setting setting = findByType(type);
        setting.setValue(value);
        return repository.save(setting);
    }
}
