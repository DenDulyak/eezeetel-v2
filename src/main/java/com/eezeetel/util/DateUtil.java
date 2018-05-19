package com.eezeetel.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.Date;

/**
 * Created by Denis Dulyak on 19.09.2016.
 */
public class DateUtil {

    public static Date getStartOfDay(LocalDate date) {
        return Date.from(LocalDateTime.of(date, LocalTime.MIN).atZone(ZoneId.systemDefault()).toInstant());
    }

    public static Date getEndOfDay(LocalDate date) {
        return Date.from(LocalDateTime.of(date, LocalTime.MAX).atZone(ZoneId.systemDefault()).toInstant());
    }

    public static LocalDate getStartOfMonth(LocalDate date) {
        return date.withDayOfMonth(1);
    }

    public static LocalDate getEndOfMonth(LocalDate date) {
        return date.withDayOfMonth(date.lengthOfMonth());
    }

    public static LocalDate toLocalDate(Date date) {
        return date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
    }

    public static LocalDateTime toLocalDateTime(Date date) {
        return date.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
    }
}
