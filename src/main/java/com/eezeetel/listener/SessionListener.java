package com.eezeetel.listener;

import com.eezeetel.customerapp.ProcessTransaction;
import com.eezeetel.entity.TTransactions;
import com.eezeetel.entity.TUserLog;
import com.eezeetel.entity.User;
import com.eezeetel.enums.TransactionStatus;
import com.eezeetel.service.TransactionService;
import com.eezeetel.service.UserLogService;
import com.eezeetel.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.util.Date;
import java.util.List;

/**
 * Created by Denis Dulyak on 27.02.2016.
 */
@WebListener
public class SessionListener implements HttpSessionListener {

    @Autowired
    private UserService userService;

    @Autowired
    private UserLogService userLogService;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private ProcessTransaction processTransaction;

    @Override
    public void sessionCreated(HttpSessionEvent httpSessionEvent) {
        httpSessionEvent.getSession().setMaxInactiveInterval(60 * 15);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent httpSessionEvent) {
        String login = (String) httpSessionEvent.getSession().getAttribute("USER_ID");
        String sessionId = httpSessionEvent.getSession().getId();
        if (login != null && !login.isEmpty()) {
            User user = userService.findByLogin(login);
            if (user != null) {
                List<TTransactions> transactions = transactionService.findByUserAndStatus(user, TransactionStatus.PROCESSED);
                if (!transactions.isEmpty()) {
                    for (TTransactions transaction : transactions) {
                        processTransaction.cancel(transaction.getTransactionId());
                    }
                }
                TUserLog userLog = userLogService.findByUserAndSessionId(user, sessionId);
                if (userLog != null) {
                    userLog.setLogoutTime(new Date());
                    userLog.setLoginStatus((byte) 2);
                    userLogService.save(userLog);
                }
            }
        }
    }
}
