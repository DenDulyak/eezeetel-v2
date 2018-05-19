package com.eezeetel.service.impl;

import com.eezeetel.entity.Title;
import com.eezeetel.enums.TitleType;
import com.eezeetel.repository.TitleRepository;
import com.eezeetel.service.TitleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by Denis Dulyak on 10.03.2016.
 */
@Service
public class TitleServiceImpl implements TitleService {

    @Autowired
    private TitleRepository titleRepository;

    @Override
    public Title findByType(TitleType type) {
        return titleRepository.findByType(type);
    }

    @Override
    public Title updateByType(TitleType type, String text) {
        Title title = findByType(type);
        if (title == null) {
            title = new Title();
            title.setType(type);
        }
        title.setText(text);
        return titleRepository.save(title);
    }
}
