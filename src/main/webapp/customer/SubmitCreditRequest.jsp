<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ include file="/common/imports.jsp" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    response.addHeader("Pragma", "no-cache");
    response.addHeader("Expires", "-1");

    String strRequestAmount = request.getParameter("request_amount");
    String strAmountDeposited = request.getParameter("amount_deposited");
    String strPaymentType = request.getParameter("payment_type");
    String strBankName = request.getParameter("bank_name");
    String strRequestDetails = request.getParameter("request_details");
    String strTheYear = request.getParameter("the_year");
    String strTheMonth = request.getParameter("the_month");
    String strTheDay = request.getParameter("the_day");
    String strTheHour = request.getParameter("the_hour");

    String requestUserID = request.getRemoteUser();
    String strCustomerID = request.getParameter("customer_id");

    int nCustomerID = 0;
    if (strCustomerID != null)
        nCustomerID = Integer.parseInt(strCustomerID);
    int nAmountDeposited = 0;
    float fRequestAmount = 0.0f;
    if (strRequestAmount != null && !strRequestAmount.isEmpty())
        fRequestAmount = Float.parseFloat(strRequestAmount);
    if (strAmountDeposited != null && !strAmountDeposited.isEmpty())
        nAmountDeposited = Integer.parseInt(strAmountDeposited);

    int nPaymentType = 0;
    int nBankId = 1;
    String strPayDate = null;

    if (nAmountDeposited == 1) {
        if (strPaymentType != null && !strPaymentType.isEmpty())
            nPaymentType = Integer.parseInt(strPaymentType);

        if (strBankName != null && !strBankName.isEmpty())
            nBankId = Integer.parseInt(strBankName);

        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.YEAR, Integer.parseInt(strTheYear));
        cal.set(Calendar.MONTH, Integer.parseInt(strTheMonth));
        cal.set(Calendar.DAY_OF_MONTH, Integer.parseInt(strTheDay));
        cal.set(Calendar.HOUR_OF_DAY, Integer.parseInt(strTheHour));
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        strPayDate = "'" + sdf.format(cal.getTime()) + "'";
    }

    Session theSession = null;
    boolean bNoMoreSubmission = false;
    int nCustomerGroupID = 0;
    try {
        theSession = HibernateUtil.openSession();
        String strUserId = (String) request.getRemoteUser();
        String strCompanyName = "";
        List creditRequests = null;

        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, -60);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String strCurTime = sdf.format(cal.getTime());

        String strQuery1 = "from TCreditRequests where Request_Date > '" + strCurTime + "'" +
                " and (Request_Status = 1 OR Request_Status = 4) " +
                " and Customer_ID = " + nCustomerID + " order by Request_ID desc";
        Query query = theSession.createQuery(strQuery1);

        creditRequests = query.list();
        if (creditRequests.size() > 0)
            bNoMoreSubmission = true;

        if (bNoMoreSubmission) {
            response.getWriter().println("A request has already been submitted.");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().println("A request has already been submitted.");
    } finally {
        HibernateUtil.closeSession(theSession);
    }

    String strQuery = "insert into t_credit_requests (Request_Type, Customer_ID, Request_Date, Request_Amount," +
            " Amount_Already_Paid, Payment_Type, Bank_ID, Payment_Date, Requested_By, Request_Details, " +
            " Request_Status) " +
            " values (1, " + nCustomerID + ", now(), " + fRequestAmount + ", " + nAmountDeposited + ", " +
            nPaymentType + ", " + nBankId + ", " + strPayDate + ", '" +
            request.getRemoteUser() + "', '" + strRequestDetails + "', 1)";

    DatabaseHelper dbHelper = new DatabaseHelper();
    if (dbHelper.executeQuery(strQuery))
        response.sendRedirect("/customer/request-credit");
    else
        response.getWriter().println("Failed to submit credit request. Please try again");
%>