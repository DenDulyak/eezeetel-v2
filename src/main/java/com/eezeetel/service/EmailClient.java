package com.eezeetel.service;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface EmailClient {

    boolean prepareAndSend(List<String> recipients, String from, String subject, String text, boolean html);
    boolean prepareAndSend(String recipient, String from, String subject, String text, boolean html);
}
