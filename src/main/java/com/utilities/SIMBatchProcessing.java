package com.utilities;

import com.eezeetel.util.HibernateUtil;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.exception.ConstraintViolationException;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.StringTokenizer;

public class SIMBatchProcessing implements Runnable {
    String m_strBatchFile = null;
    int m_nSequenceID = 0;
    String m_strBatchID = null;
    int m_nProductID = 0;
    int m_nMaxTopus = 0;

    SIMBatchProcessing(String strBatchFile) {
        this.m_strBatchFile = new String(strBatchFile);
    }

    void setSequenceID(int nSequenceID) {
        this.m_nSequenceID = nSequenceID;
    }

    void setBatchID(String strBatchID) {
        this.m_strBatchID = strBatchID;
    }

    void setProductID(int nProductID) {
        this.m_nProductID = nProductID;
    }

    void setMaxTopups(int nMaxTopus) {
        this.m_nMaxTopus = nMaxTopus;
    }

    public void run() {
        boolean bUploadSuccess = true;
        int nQuantity = 0;
        String uploadStatus = "SUCCESS-BatchUpdateInDB";
        if ((this.m_strBatchFile == null) || (this.m_strBatchFile.isEmpty())) {
            return;
        }
        Session theSession = null;

        File file = null;
        try {
            file = new File(this.m_strBatchFile);
            FileReader fr = new FileReader(file);

            BufferedReader br = new BufferedReader(fr);

            String strLine = null;
            while ((strLine = br.readLine()) != null) {
                if (strLine.matches("(?i)Batch.*")) {
                    break;
                }
                if (strLine.matches("(?i)Card.*")) {
                    break;
                }
            }
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();
            while ((strLine = br.readLine()) != null) {
                if (strLine.length() > 0) {
                    String strInsertQuery = "insert into t_sim_cards_info (Batch_Sequence_ID, Product_ID, Max_Topups, Remaining_Topups, sim_card_id, sim_card_pin) values ("
                            + this.m_nSequenceID + ", " + this.m_nProductID + "," + this.m_nMaxTopus + "," + this.m_nMaxTopus + ",";

                    StringTokenizer st = new StringTokenizer(strLine, " \t");
                    while (st.hasMoreTokens()) {
                        String strCardCode = st.nextToken();
                        String strCardPin = st.nextToken();

                        strInsertQuery = strInsertQuery + "'" + strCardCode + "', '" + strCardPin + "')";

                        SQLQuery query = theSession.createSQLQuery(strInsertQuery);
                        if (query.executeUpdate() > 0) {
                            nQuantity++;
                        }
                    }
                }
            }
            br.close();
            fr.close();

            theSession.getTransaction().commit();
        } catch (ConstraintViolationException e) {
            e.printStackTrace();
            theSession.getTransaction().rollback();
            bUploadSuccess = false;
            uploadStatus = "Duplicate_Batch";
        } catch (Exception e) {
            e.printStackTrace();
            theSession.getTransaction().rollback();
            bUploadSuccess = false;
            uploadStatus = "FAILED-BatchUpdateInDB";
        } finally {
            HibernateUtil.closeSession(theSession);
        }

        try {
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();

            String strQuery = "";
            if (bUploadSuccess) {
                strQuery =

                        "update t_batch_information set Quantity = " + nQuantity + " ,Available_Quantity = " + nQuantity
                                + " ,Batch_Upload_Status = '" + uploadStatus + "'" + " ,IsBatchActive = 1 " + " where SequenceID = "
                                + this.m_nSequenceID;
            } else {
                strQuery = "update t_batch_information set Batch_Upload_Status = '" + uploadStatus + "'"
                        + " where SequenceID = " + this.m_nSequenceID;
            }
            SQLQuery query = theSession.createSQLQuery(strQuery);
            query.executeUpdate();

            theSession.getTransaction().commit();
            if ((bUploadSuccess) && (file != null) && (!file.isDirectory())) {
                file.delete();
            }
        } catch (Exception e) {
            e.printStackTrace();
            theSession.getTransaction().rollback();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
    }

    public static void main(String[] args) {
    }
}
