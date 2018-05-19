package com.eezeetel.util;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.transaction.annotation.Transactional;

@Transactional
public class HibernateUtil {

    private static SessionFactory sessionFactory;

    public void setSessionFactory(SessionFactory sessionFactory){
        this.sessionFactory = sessionFactory;
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    //@Deprecated
    public static SessionFactory getSessionFactory(String country) {
        return sessionFactory;
    }

    public static Session openSession() {
        return sessionFactory.openSession();
    }

    public static void closeSession(Session session) {
        if (session != null) {
            session.close();
            session = null;
        }
    }
}