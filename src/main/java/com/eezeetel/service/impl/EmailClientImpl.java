package com.eezeetel.service.impl;

import com.eezeetel.service.EmailClient;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.mail.javamail.MimeMessagePreparator;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Log4j
@Service
public class EmailClientImpl implements EmailClient {

    @Autowired
    private JavaMailSender mailSender;

    @Override
    public boolean prepareAndSend(List<String> recipients, String from, String subject, String text, boolean html) {
        MimeMessagePreparator messagePreparator = mimeMessage -> {
            MimeMessageHelper messageHelper = new MimeMessageHelper(mimeMessage);
            messageHelper.setFrom(from);
            messageHelper.setTo(recipients.toArray(new String[recipients.size()]));
            messageHelper.setSubject(subject);
            messageHelper.setText(text, html);
        };
        try {
            mailSender.send(messagePreparator);
        } catch (MailException e) {
            e.printStackTrace();
            log.error("Email to " + recipients + " is not sent.");
            return false;
        }
        return true;
    }

    @Override
    public boolean prepareAndSend(String recipient, String from, String subject, String text, boolean html) {
        return prepareAndSend(Arrays.asList(recipient), from, subject, text, html);
    }
}
