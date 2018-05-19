<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>

<%
    Integer nCustomerGroupID = (Integer) session.getAttribute("GROUP_ID");

    int nStartYear = Integer.parseInt(request.getParameter("start_year_number"));
    int nStartMonth = Integer.parseInt(request.getParameter("start_month_number"));
    int nEndYear = Integer.parseInt(request.getParameter("end_year_number"));
    int nEndMonth = Integer.parseInt(request.getParameter("end_month_number"));

    Calendar cal = Calendar.getInstance();
    cal.set(nEndYear, nEndMonth - 1, 1);
    int nMaxDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

    response.setContentType("text/xml");
    String xmlData = "<report>";

    String durationBegin = "'" + nStartYear + "-" + nStartMonth + "-01 00:00:00'";
    String durationEnd = "'" + nEndYear + "-" + nEndMonth + "-" + nMaxDay + " 00:00:00'";

    String strQuery = "SELECT t1.Customer_Company_Name,t2.Payment_Type,t2.Payment_Details,t2.Payment_Amount,t2.Payment_Date " +
            " FROM t_master_customer_credit t2, t_master_customerinfo t1 where t1.Customer_ID = t2.Customer_ID and " +
            " Credit_or_Debit = 1 and t1.Customer_Group_ID = " + nCustomerGroupID + " and " +
            " t2.Payment_Date >= " + durationBegin + " and t2.Payment_Date <= " + durationEnd +
            " order by Payment_Date desc";

    Session theSession = null;

    try {
        DecimalFormat ff = new DecimalFormat("0.00");
        theSession = HibernateUtil.openSession();

        SQLQuery sqlQuery = theSession.createSQLQuery(strQuery);
        sqlQuery.addScalar("Customer_Company_Name", new StringType());
        sqlQuery.addScalar("Payment_Type", new IntegerType());
        sqlQuery.addScalar("Payment_Details", new StringType());
        sqlQuery.addScalar("Payment_Amount", new FloatType());
        sqlQuery.addScalar("Payment_Date", new TimestampType());

        List report = sqlQuery.list();

        for (int i = 0; i < report.size(); i++) {
            Object[] oneRecord = (Object[]) report.get(i);
            if (oneRecord.length > 0) {
                String strCompanyName = (String) oneRecord[0];
                Integer nPaymentType = (Integer) oneRecord[1];
                String strPaymentDetails = (String) oneRecord[2];
                Float fAmount = (Float) oneRecord[3];
                Date paymentDate = (Date) oneRecord[4];

                xmlData += "<record ";
                xmlData += (" company_name = \"" + strCompanyName + "\" ");
                xmlData += (" payment_type = \"" + nPaymentType + "\" ");
                xmlData += (" payment_details = \"" + strPaymentDetails + "\" ");
                xmlData += (" payment_amount = \"" + fAmount + "\" ");
                xmlData += (" payment_date = \"" + paymentDate + "\" ");
                xmlData += "/>";
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        HibernateUtil.closeSession(theSession);
    }
    xmlData += "</report>";
    response.getWriter().println(xmlData);
%>