<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>

<%@ include file="/common/imports.jsp" %>

<%
    String customer = request.getParameter("customer_id");
    String product = request.getParameter("product_id");
    String date = request.getParameter("report_date");
    String reportType = request.getParameter("reportSelector");
    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

    boolean bIsMonthly = false;
    if (reportType.compareToIgnoreCase("true") == 0)
        bIsMonthly = true;

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdfo = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MMM-dd");
    Date reqDate = sdf.parse(date);

    Calendar cal = Calendar.getInstance();
    cal.setTime(reqDate);

    String fromDate = "", toDate = "";
    String fromDateToDisplay = "", toDateToDisplay = "";

    if (bIsMonthly) {
        cal.set(Calendar.DAY_OF_MONTH, 1);
        fromDate = sdfo.format(cal.getTime());
        fromDateToDisplay = df.format(cal.getTime());
        cal.add(Calendar.MONTH, 1);
        toDate = sdfo.format(cal.getTime());
        toDateToDisplay = df.format(cal.getTime());
    } else {
        fromDate = sdfo.format(cal.getTime());
        cal.add(Calendar.DAY_OF_MONTH, 1);
        fromDateToDisplay = df.format(cal.getTime());
        toDate = sdfo.format(cal.getTime());
        toDateToDisplay = df.format(cal.getTime());
    }

    String customerPart = "";
    if (customer != null && !customer.isEmpty() && Integer.parseInt(customer) > 0)
        customerPart = " and t1.Customer_ID = " + customer;

    String productPart = "";
    if (product != null && !product.isEmpty() && Integer.parseInt(product) > 0)
        productPart = " and t3.Product_ID = " + product;

    String strQuery = "select Customer_Company_Name as company,count(*) as SIMs_Sold,  t4.Product_Name, " +
            "t4.Product_ID, t2.Customer_ID " +
            " from t_sim_transactions t1, t_master_customerinfo t2, t_sim_cards_info t3, " +
            " t_master_productinfo t4 where Mobile_Topup_Transaction_ID is null " +
            " and t1.SIM_Card_SequenceID = t3.SequenceID " +
            " and t1.Customer_ID = t2.Customer_ID " +
            " and t3.Product_ID = t4.Product_ID and t1.Transaction_Time >= '" + fromDate + "' " +
            " and t1.Transaction_Time < '" + toDate + "' " +
            customerPart + productPart + " and t2.Customer_Group_ID = " + nCustomerGroupID +
            " group by t1.Customer_ID, t3.Product_ID order by Customer_Company_Name, Product_Name";
    Session theSession = null;
    System.out.println(strQuery);
    try {
        theSession = HibernateUtil.openSession();

        SQLQuery query = theSession.createSQLQuery(strQuery);
        query.addScalar("company", new StringType());
        query.addScalar("SIMs_Sold", new IntegerType());
        query.addScalar("Product_Name", new StringType());
        query.addScalar("Customer_ID", new IntegerType());
        query.addScalar("Product_ID", new IntegerType());

        List records = query.list();
        String strResult = "<H3><center><u>SIM Report From " + fromDateToDisplay + " To " + toDateToDisplay + "</u></center></H3>";
        strResult += "<br><br><table border=1 width=\"75%\">";
        strResult += "<tr><td align=center>Customer</td><td align=center>Product</td><td align=center>Sims Sold</td><td>Un-Sold Quantity</td></tr>";
        int totalSimsSold = 0;
        String strProductIds = "";
        int nCustomerId = 0;
        String strCompanyName = null;
        for (int i = 0; i < records.size(); i++) {
            Object[] oneRecord = (Object[]) records.get(i);

            strCompanyName = (String) oneRecord[0];
            int nSimsSold = (Integer) oneRecord[1];
            String strProductName = (String) oneRecord[2];
            nCustomerId = (Integer) oneRecord[3];
            int nProductId = (Integer) oneRecord[4];

            strQuery = "select count(*) as Sims_Unsold from t_sim_cards_info where Is_Sold = 0 and "
                    + " Customer_ID = " + nCustomerId + " and Product_ID =  " + nProductId;
            System.out.println(strQuery);
            query = theSession.createSQLQuery(strQuery);
            query.addScalar("Sims_Unsold", new IntegerType());

            strProductIds += nProductId;
            if (i + 1 != records.size())
                strProductIds += ",";

            List unsoldList = query.list();
            int nSimsUnSold = 0;
            if (unsoldList.size() > 0) {
                nSimsUnSold = (Integer) unsoldList.get(0);
            }
            strResult += "<tr><td>" + strCompanyName + "</td>";
            strResult += "<td>" + strProductName + "</td>";
            strResult += "<td>" + nSimsSold + "</td>";
            strResult += "<td>" + nSimsUnSold + "</td></tr>";
            totalSimsSold += nSimsSold;
        }

        if (product.compareToIgnoreCase("0") == 0) {
            String strQuery1 = "select Product_Name, count(*) as unsold from t_sim_cards_info p1,t_master_productinfo p2 " +
                    " where p1.Product_ID = p2.Product_ID and p1.Is_Sold=0 and"
                    + " Customer_ID = " + nCustomerId;

            if (!strProductIds.isEmpty()) {
                strQuery1 += " and p2.Product_ID not in(" + strProductIds + ") "
                        + " group by p1.Product_ID";
            }
            System.out.println(strQuery1);
            SQLQuery squery = theSession.createSQLQuery(strQuery1);
            squery.addScalar("Product_Name", new StringType());
            squery.addScalar("unsold", new IntegerType());

            List NosoldProductList = squery.list();

            for (int i = 0; i < NosoldProductList.size(); i++) {
                Object[] oneRecord = (Object[]) NosoldProductList.get(i);
                String NSPList = (String) oneRecord[0];
                int UnsoldList = (Integer) oneRecord[1];
                strResult += "<tr><td>" + strCompanyName + "</td>";
                strResult += "<td>" + NSPList + "</td>";
                strResult += "<td>0</td>";
                strResult += "<td>" + UnsoldList + "</td></tr>";
            }
        }

        strResult += "<tr><td colspan=2><b>TOTAL</td> <td><b>" + totalSimsSold + "</td></tr>";
        strResult += "</table>";

        response.setContentType("text/html");
        response.getWriter().println(strResult);

    } catch (Exception e) {
        e.printStackTrace();
        String strResult = "<table></table>";
        response.setContentType("text/html");
        response.getWriter().println(strResult);
    } finally {
        HibernateUtil.closeSession(theSession);
    }
%>
