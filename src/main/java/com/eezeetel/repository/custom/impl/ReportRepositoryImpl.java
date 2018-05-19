package com.eezeetel.repository.custom.impl;

import com.eezeetel.bean.products.ProductSaleInfo;
import com.eezeetel.bean.report.CustomerBalanceReportBean;
import com.eezeetel.bean.report.DetailSales;
import com.eezeetel.repository.custom.ReportRepository;
import com.eezeetel.util.DateUtil;
import com.eezeetel.util.HibernateUtil;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.transform.Transformers;
import org.hibernate.type.*;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;

/**
 * Created by Denis Dulyak on 06.01.2017.
 */
@Repository
public class ReportRepositoryImpl implements ReportRepository {

    @Override
    public List<CustomerBalanceReportBean> getCustomerBalanceReport(LocalDate startDate, LocalDate endDate) {
        List<CustomerBalanceReportBean> result = Collections.emptyList();

        Session session = null;
        try {
            session = HibernateUtil.openSession();
            String strQuery = "select " +
                    "    cbr.customer_id as customerId, " +
                    "    c.Customer_Company_Name as customerName, " +
                    "    sum(cbr.topup) as topup, " +
                    "    sum(cbr.sales) as sales, " +
                    "    sum(cbr.transactions) as transactions, " +
                    "    sum(cbr.quantity) as quantity " +
                    "from " +
                    "    customer_balance_report cbr, " +
                    "    t_master_customerinfo c " +
                    "where " +
                    "    cbr.day between :startDay and :endDay " +
                    "        and cbr.customer_id = c.Customer_ID " +
                    "        and c.Customer_Group_ID in (1,2) " +
                    "group by cbr.customer_id ";

            SQLQuery sqlQuery = session.createSQLQuery(strQuery);
            sqlQuery.addScalar("customerId", new IntegerType());
            sqlQuery.addScalar("customerName", new StringType());
            sqlQuery.addScalar("topup", new BigDecimalType());
            sqlQuery.addScalar("sales", new BigDecimalType());
            sqlQuery.addScalar("transactions", new IntegerType());
            sqlQuery.addScalar("quantity", new IntegerType());

            sqlQuery.setParameter("startDay", DateUtil.getStartOfDay(startDate));
            sqlQuery.setParameter("endDay", DateUtil.getEndOfDay(endDate));
            sqlQuery.setResultTransformer(Transformers.aliasToBean(CustomerBalanceReportBean.class));

            result = (List<CustomerBalanceReportBean>) sqlQuery.list();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }

        return result;
    }

    @Override
    public List<CustomerBalanceReportBean> getCustomerBalanceReportByGroupId(Integer groupId, LocalDate startDate, LocalDate endDate) {
        List<CustomerBalanceReportBean> result = Collections.emptyList();

        Session session = null;
        try {
            session = HibernateUtil.openSession();
            String strQuery = "select " +
                    "    cbr.customer_id as customerId, " +
                    "    c.Customer_Company_Name as customerName, " +
                    "    sum(cbr.topup) as topup, " +
                    "    sum(cbr.sales) as sales, " +
                    "    sum(cbr.transactions) as transactions, " +
                    "    sum(cbr.quantity) as quantity " +
                    "from " +
                    "    customer_balance_report cbr, " +
                    "    t_master_customerinfo c " +
                    "where " +
                    "    cbr.day between :startDay and :endDay " +
                    "        and cbr.customer_id = c.Customer_ID " +
                    "        and c.Customer_Group_ID = :groupId " +
                    "group by cbr.customer_id ";

            SQLQuery sqlQuery = session.createSQLQuery(strQuery);
            sqlQuery.addScalar("customerId", new IntegerType());
            sqlQuery.addScalar("customerName", new StringType());
            sqlQuery.addScalar("topup", new BigDecimalType());
            sqlQuery.addScalar("sales", new BigDecimalType());
            sqlQuery.addScalar("transactions", new IntegerType());
            sqlQuery.addScalar("quantity", new IntegerType());

            sqlQuery.setParameter("startDay", DateUtil.getStartOfDay(startDate));
            sqlQuery.setParameter("endDay", DateUtil.getEndOfDay(endDate));
            sqlQuery.setParameter("groupId", groupId);
            sqlQuery.setResultTransformer(Transformers.aliasToBean(CustomerBalanceReportBean.class));

            result = (List<CustomerBalanceReportBean>) sqlQuery.list();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }

        return result;
    }

    @Override
    public List<ProductSaleInfo> getProductSaleInfos(List<Integer> productIds, Date from, Date to) {
        List<ProductSaleInfo> result = null;
        Session session = null;
        try {
            session = HibernateUtil.openSession();
            String sql = "SELECT tt.Product_ID as productId, tt.Quantity AS purchaseType, SUM(tt.Quantity) AS salesBetweenDate, COUNT(DISTINCT tt.Transaction_ID) AS transactions " +
                    "FROM t_transactions tt " +
                    "WHERE tt.Product_ID in (:productIds) " +
                    "AND tt.Committed = 1 " +
                    "AND tt.Transaction_Time BETWEEN :fromDate AND :toDate " +
                    "GROUP BY tt.Product_ID, tt.Quantity " +
                    "UNION " +
                    "SELECT tht.Product_ID as productId, tht.Quantity AS purchaseType, SUM(tht.Quantity) AS salesBetweenDate, COUNT(DISTINCT tht.Transaction_ID) AS transactions " +
                    "FROM t_history_transactions tht " +
                    "WHERE tht.Product_ID in (:productIds) " +
                    "AND tht.Committed = 1 " +
                    "AND tht.Transaction_Time BETWEEN :fromDate AND :toDate " +
                    "GROUP BY tht.Product_ID, tht.Quantity ";

            Calendar date2013 = Calendar.getInstance();
            date2013.set(2013, Calendar.JANUARY, 1);

            if (date2013.getTime().after(from)) {
                sql += "UNION " +
                        "SELECT tht2.Product_ID as productId, tht2.Quantity AS purchaseType, SUM(tht2.Quantity) AS salesBetweenDate, COUNT(DISTINCT tht2.Transaction_ID) AS transactions " +
                        "FROM t_history_transactions_2010_05_31__2013_01_01 tht2 " +
                        "WHERE tht2.Product_ID in (:productIds) " +
                        "AND tht2.Committed = 1 " +
                        "AND tht2.Transaction_Time BETWEEN :fromDate AND :toDate " +
                        "GROUP BY tht2.Product_ID, tht2.Quantity ";
            }

            SQLQuery sqlQuery = session.createSQLQuery(sql);
            sqlQuery.addScalar("purchaseType", new IntegerType());
            sqlQuery.addScalar("salesBetweenDate", new IntegerType());
            sqlQuery.addScalar("transactions", new IntegerType());
            sqlQuery.addScalar("productId", new IntegerType());
            sqlQuery.setParameter("fromDate", from);
            sqlQuery.setParameter("toDate", to);
            sqlQuery.setParameterList("productIds", productIds);
            sqlQuery.setResultTransformer(Transformers.aliasToBean(ProductSaleInfo.class));
            result = sqlQuery.list();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }
        return result;
    }

    @Override
    public List<DetailSales> getProductDetailSaleInfos(Integer productId, Date from, Date to) {
        List<DetailSales> result = null;
        Session session = null;
        try {
            session = HibernateUtil.openSession();
            String sql = "SELECT tt.Transaction_ID AS transactionId, tt.Transaction_Time AS transactionTime, SUM(tt.Quantity) AS sales, " +
                    "ROUND(sum(tt.Unit_Purchase_Price), 2) AS purchasePrice, tmc.Customer_Company_Name AS customer, tt.User_ID AS userName " +
                    "FROM t_transactions tt, t_master_customerinfo tmc " +
                    "WHERE tt.Product_ID = :productId " +
                    "AND tt.Committed = 1 " +
                    "AND tt.Transaction_Time BETWEEN :fromDate AND :toDate " +
                    "AND tmc.Customer_ID =  tt.Customer_ID " +
                    "GROUP BY tt.Transaction_ID " +
                    "UNION " +
                    "SELECT tht.Transaction_ID AS transactionId, tht.Transaction_Time AS transactionTime, SUM(tht.Quantity) AS sales, " +
                    "ROUND(sum(tht.Unit_Purchase_Price), 2) AS purchasePrice, tmc.Customer_Company_Name AS customer, tht.User_ID AS userName " +
                    "FROM t_history_transactions tht, t_master_customerinfo tmc " +
                    "WHERE tht.Product_ID = :productId " +
                    "AND tht.Committed = 1 " +
                    "AND tht.Transaction_Time BETWEEN :fromDate AND :toDate " +
                    "AND tmc.Customer_ID =  tht.Customer_ID " +
                    "GROUP BY tht.Transaction_ID ";

            Calendar date2013 = Calendar.getInstance();
            date2013.set(2013, Calendar.JANUARY, 1);

            if (date2013.getTime().after(from)) {
                sql += "UNION " +
                        "SELECT tht2.Transaction_ID AS transactionId, tht2.Transaction_Time AS transactionTime, SUM(tht2.Quantity) AS sales, " +
                        "ROUND(sum(tht2.Unit_Purchase_Price), 2) AS purchasePrice, tmc.Customer_Company_Name AS customer, tht2.User_ID AS userName " +
                        "FROM t_history_transactions_2010_05_31__2013_01_01 tht2, t_master_customerinfo tmc " +
                        "WHERE tht2.Product_ID = :productId " +
                        "AND tht2.Committed = 1 " +
                        "AND tht2.Transaction_Time BETWEEN :fromDate AND :toDate " +
                        "AND tmc.Customer_ID =  tht2.Customer_ID " +
                        "GROUP BY tht2.Transaction_ID ";
            }

            SQLQuery sqlQuery = session.createSQLQuery(sql);
            sqlQuery.addScalar("transactionId", new IntegerType());
            sqlQuery.addScalar("transactionTime", new DateType());
            sqlQuery.addScalar("sales", new IntegerType());
            sqlQuery.addScalar("purchasePrice", new FloatType());
            sqlQuery.addScalar("customer", new StringType());
            sqlQuery.addScalar("userName", new StringType());
            sqlQuery.setParameter("fromDate", from);
            sqlQuery.setParameter("toDate", to);
            sqlQuery.setParameter("productId", productId);
            sqlQuery.setResultTransformer(Transformers.aliasToBean(DetailSales.class));
            result = sqlQuery.list();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(session);
        }
        return result;
    }
}
