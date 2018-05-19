package com.eezeetel.job;

import org.apache.commons.io.comparator.LastModifiedFileComparator;
import org.apache.log4j.Logger;
import org.quartz.DisallowConcurrentExecution;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.PersistJobDataAfterExecution;
import org.springframework.scheduling.quartz.QuartzJobBean;

import java.io.File;
import java.util.Arrays;

/**
 * Created by Denis Dulyak on 08.08.2016.
 */
@PersistJobDataAfterExecution
@DisallowConcurrentExecution
public class RemoveBackupFile extends QuartzJobBean {

    private static Logger log = Logger.getLogger(RemoveBackupFile.class);

    private static final long K = 1024;
    private static final long M = K * K;
    private static final long G = M * K;
    private static String BACKUP_DIR = "D:\\Installations\\Daily_Database_Backups";

    @Override
    protected void executeInternal(JobExecutionContext jobExecutionContext) throws JobExecutionException {
        File[] roots = File.listRoots();

        for (File root : roots) {
            if (root.getAbsolutePath().equals("D:\\")) {

                if (root.getFreeSpace() < G * 10) {
                    File[] backups = new File(BACKUP_DIR).listFiles();
                    if (backups != null && backups.length > 0) {
                        Arrays.sort(backups, LastModifiedFileComparator.LASTMODIFIED_COMPARATOR);

                        File fileToDelete = backups[0];

                        log.info("Delete file - " + fileToDelete.getAbsolutePath());
                        fileToDelete.delete();
                    }
                }

                break;
            }
        }
    }
}
