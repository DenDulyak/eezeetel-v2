package com.commons;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class GenericListner implements HttpSessionListener {
	public void sessionCreated(HttpSessionEvent se) {
	}

	public void sessionDestroyed(HttpSessionEvent se) {
		String strCountry = se.getSession().getServletContext().getInitParameter("Country");
		String strUserID = (String) se.getSession().getAttribute("USER_ID");
		if ((strUserID != null) && (strUserID.length() > 0)) {
			String strQuery = "update t_user_log set Logout_Time = now(), Login_Status = 2 where Login_Status = 1 and User_Login_ID = '"
					+ strUserID + "' " + " and SessionID = '" + se.getSession().getId() + "'";

			DatabaseHelper dbHelper = new DatabaseHelper();
			if (!dbHelper.executeQuery(strQuery)) {
				System.out.println("Failed to update user log (LOGOUT) for user " + strUserID);
			}
		}
	}
}
