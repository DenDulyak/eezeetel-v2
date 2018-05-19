package com.eezeetel.service;

import com.eezeetel.bean.UserBean;
import com.eezeetel.entity.TUserLog;
import com.eezeetel.entity.User;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.util.List;

@Service
public interface UserService {

    User findByLogin(String login);
    List<User> findByUserType(Integer roleId);
    List<User> findAgentsByUserAndGroup(String login, Integer groupId);
    Boolean hasAccessToSite(String username, String host);
    void addUserDataToSession(String username, HttpSession session, Boolean addLog);
    TUserLog addUserAuthenticationLog(User user, String sessionId);
    User save(UserBean bean, String createBy);
}
