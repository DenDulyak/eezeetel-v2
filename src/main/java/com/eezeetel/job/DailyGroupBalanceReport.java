package com.eezeetel.job;

import com.eezeetel.service.GroupBalanceReportService;
import lombok.extern.log4j.Log4j;
import org.quartz.*;
import org.springframework.scheduling.quartz.QuartzJobBean;

import java.time.LocalDate;
import java.util.Calendar;

/**
 * Created by Denis Dulyak on 16.01.2017.
 */
@Log4j
@PersistJobDataAfterExecution
@DisallowConcurrentExecution
public class DailyGroupBalanceReport extends QuartzJobBean {

    private GroupBalanceReportService service;

    @Override
    protected void executeInternal(JobExecutionContext context) throws JobExecutionException {
        JobDataMap dataMap = context.getJobDetail().getJobDataMap();
        service = (GroupBalanceReportService) dataMap.get("groupBalanceReportService");

        log.info("runGroupDailyReport start " + Calendar.getInstance().getTime().toString());
        service.runDailyReport(LocalDate.now());
        log.info("runGroupDailyReport. -- Done.");
    }
}
