package com.commons;

import com.eezeetel.enums.FeatureType;
import com.eezeetel.util.HibernateUtil;
import org.apache.catalina.realm.JDBCRealm;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.type.StandardBasicTypes;

import java.util.List;

public class DatabaseHelper {
    String m_strCountry = "";

    public void setCountry(String strCountry) {
        this.m_strCountry = strCountry;
    }

    public boolean executeQuery(String strQuery) {
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();
            SQLQuery query = theSession.createSQLQuery(strQuery);
            query.executeUpdate();
            theSession.getTransaction().commit();
        } catch (Exception e) {
            theSession.getTransaction().rollback();
            e.printStackTrace();
            return false;
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return true;
    }

    public boolean removeFeaturesFromCustomer(Integer customerId) {
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();
            SQLQuery query = theSession.createSQLQuery("DELETE FROM customer_feature WHERE CUSTOMER_ID = " + customerId);
            query.executeUpdate();
            theSession.getTransaction().commit();
        } catch (Exception e) {
            theSession.getTransaction().rollback();
            e.printStackTrace();
            return false;
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return true;
    }

    public boolean addFeaturesToCustomer(Integer customerId, List<FeatureType> featureTypes) {
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();
            for (FeatureType type : featureTypes) {
                theSession.createSQLQuery(
                        "INSERT INTO customer_feature (FEATURE_ID, CUSTOMER_ID) " +
                                "VALUES ((SELECT ID FROM feature WHERE FEATURE_TYPE = " + type.ordinal() + "), " + customerId + ")"
                ).executeUpdate();
            }
            theSession.getTransaction().commit();
        } catch (Exception e) {
            theSession.getTransaction().rollback();
            e.printStackTrace();
            return false;
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return true;
    }

    public boolean executeMultipleQuery(String strQuery1, String strQuery2) {
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();

            SQLQuery query = theSession.createSQLQuery(strQuery1);
            query.executeUpdate();

            query = theSession.createSQLQuery(strQuery2);
            query.executeUpdate();

            theSession.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            assert theSession != null;
            theSession.getTransaction().rollback();
            return false;
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return true;
    }

    public boolean updateUserPassword(String strUser, String strPassword, String strNewPassword) {
        if ((strUser == null) || (strUser.isEmpty())) {
            return false;
        }
        if ((strPassword == null) || (strPassword.isEmpty())) {
            return false;
        }
        if ((strNewPassword == null) || (strNewPassword.isEmpty())) {
            return false;
        }
        String strEncryptedOldPassword = JDBCRealm.Digest(strPassword, "MD5", "utf8");
        String strEncryptedNewPassword = JDBCRealm.Digest(strNewPassword, "MD5", "utf8");

        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();

            String strQuery = "update t_master_users set Password = '" + strEncryptedNewPassword + "', Password_2 = '" + strNewPassword + "'"
                    + " where User_Login_ID = '" + strUser + "'" + "and Password = '" + strEncryptedOldPassword + "'"
                    + " and User_Active_Status = 1";

            SQLQuery query = theSession.createSQLQuery(strQuery);
            int nRows = query.executeUpdate();

            theSession.getTransaction().commit();
            if (nRows == 1) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return false;
    }

    public String checkForLatestSession(String strUserID, String currentSessionID) {
        Session theSession = null;
        String strSessionId = null;
        try {
            theSession = HibernateUtil.openSession();
            String strQuery = "select SessionID from t_user_log where User_Login_ID = '" + strUserID + "' "
                    + " and Login_Status = 1 and SessionID != '" + currentSessionID + "'"
                    + " and Login_Time > (select Login_Time from t_user_log where " + " User_Login_ID = '" + strUserID
                    + "' and Login_Status = 1 " + " and SessionID = '" + currentSessionID + "')";

            SQLQuery query = theSession.createSQLQuery(strQuery);
            query.addScalar("SessionID", StandardBasicTypes.STRING);
            List list = query.list();
            if (list.size() > 0) {
                strSessionId = (String) list.get(0);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return strSessionId;
    }

    public int insertAndGetBatchSequenceID(String strQuery) {
        Session theSession = null;
        int nSequenceID = 0;
        try {
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();

            SQLQuery query = theSession.createSQLQuery(strQuery);
            query.executeUpdate();

            strQuery = "select max(SequenceID) from t_batch_information";

            query = theSession.createSQLQuery(strQuery);
            List listSequenceID = query.list();
            if (listSequenceID.size() > 0) {
                Object oneResult = listSequenceID.get(0);
                if (oneResult != null) {
                    nSequenceID = ((Integer) oneResult).intValue();
                } else {
                    throw new Exception();
                }
            } else {
                throw new Exception();
            }
            theSession.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            theSession.getTransaction().rollback();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return nSequenceID;
    }

    public boolean InsertNewContact(String strQuery, String ipAddress) {
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
            theSession.beginTransaction();

            String strCheckQuery = "select count(*) as HowMany from t_new_contacts where (Addressed = 0 OR Addressed = 2)and Remote_Address = '"
                    + ipAddress + "'";
            SQLQuery query = theSession.createSQLQuery(strCheckQuery);
            query.addScalar("HowMany", StandardBasicTypes.INTEGER);
            List alreadyThere = query.list();
            if (alreadyThere.size() > 0) {
                Integer howMany = (Integer) alreadyThere.get(0);
                if (howMany.intValue() <= 0) {
                    query = theSession.createSQLQuery(strQuery);
                    query.executeUpdate();
                }
            }
            theSession.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            theSession.getTransaction().rollback();
            return false;
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return true;
    }

    public int GetCustomerGroupID(String strUser) {
        Session session = null;
        try {
            session = HibernateUtil.openSession();
            String strQuery = "select Customer_Group_ID from t_master_users where User_Login_ID = '" + strUser + "'";
            SQLQuery query = session.createSQLQuery(strQuery);
            query.addScalar("Customer_Group_ID", StandardBasicTypes.INTEGER);
            List alreadyThere = query.list();
            if (alreadyThere.size() > 0) {
                Integer groupID = (Integer) alreadyThere.get(0);
                if (groupID != null) return groupID.intValue();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            HibernateUtil.closeSession(session);
        }
        return 0;
    }

    public int GetCustomerGroupID(int nCustomerID) {
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();
            String strQuery = "select Customer_Group_ID from t_master_customerinfo where Customer_ID = " + nCustomerID;
            SQLQuery query = theSession.createSQLQuery(strQuery);
            query.addScalar("Customer_Group_ID", StandardBasicTypes.INTEGER);
            List alreadyThere = query.list();
            if (alreadyThere.size() > 0) {
                Integer groupID = (Integer) alreadyThere.get(0);
                return groupID.intValue();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return 0;
    }

    public String GetCustomerGroupName(int nCustomerGroupID) {
        Session theSession = null;
        try {
            theSession = HibernateUtil.openSession();

            String strQuery = "select Customer_Group_Name from t_master_customer_groups where Customer_Group_ID = " + nCustomerGroupID;
            SQLQuery query = theSession.createSQLQuery(strQuery);
            query.addScalar("Customer_Group_Name", StandardBasicTypes.STRING);
            List alreadyThere = query.list();
            if (alreadyThere.size() > 0) {
                return (String) alreadyThere.get(0);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return "Unknwon";
    }
}
