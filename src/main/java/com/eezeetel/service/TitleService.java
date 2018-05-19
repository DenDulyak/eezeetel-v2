package com.eezeetel.service;

import com.eezeetel.entity.Title;
import com.eezeetel.enums.TitleType;
import org.springframework.stereotype.Service;

@Service
public interface TitleService {

    Title findByType(TitleType type);
    Title updateByType(TitleType type, String text);
}
