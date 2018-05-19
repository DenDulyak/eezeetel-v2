package com.eezeetel.service.impl;

import com.eezeetel.bean.UserBean;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TUserLog;
import com.eezeetel.entity.TUserLogId;
import com.eezeetel.entity.User;
import com.eezeetel.repository.UserRepository;
import com.eezeetel.service.GroupService;
import com.eezeetel.service.UserLogService;
import com.eezeetel.service.UserService;
import com.eezeetel.service.UserTypeService;
import org.apache.catalina.realm.JDBCRealm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

/**
 * Created by Denis Dulyak on 04.09.2015.
 */
@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserLogService userLogService;

    @Autowired
    private GroupService groupService;

    @Autowired
    private UserTypeService userTypeService;

    @Override
    public User findByLogin(String login) {
        return userRepository.findByLogin(login);
    }

    @Override
    public List<User> findByUserType(Integer roleId) {
        return userRepository.findByUserType(userTypeService.findOne(roleId));
    }

    @Override
    public List<User> findAgentsByUserAndGroup(String login, Integer groupId) {
        return userRepository.findAgentsByUserAndGroup(login, groupId);
    }

    @Override
    public Boolean hasAccessToSite(String username, String host) {
        User user = findByLogin(username);
        TMasterCustomerGroups group = user.getGroup();
        if (host.contains("eezeetopup")) {
            return group.getId() == 1;
        } else if (host.contains("gsmtopup")) {
            return group.getId() == 2;
        } else if (host.contains("mobitopup")) {
            return group.getId() == 3;
        } else if (host.contains("kasglobal")) {
            return group.getId() == 4;
        } else if (host.contains("fasttopup")) {
            return group.getId() == 7;
        } else if (host.contains("kupay")) {
            return group.getId() == 10;
        } else if (host.contains("taajtopup")) {
            return group.getId() == 11;
        } else if (host.contains("localhost")) {
            return Boolean.TRUE;
        }

        // todo
        return Boolean.TRUE;
    }

    @Override
    public void addUserDataToSession(String username, HttpSession session, Boolean addLog) {
        String style = "ProductStyles.css";
        User user = findByLogin(username);
        TMasterCustomerGroups group = user.getGroup();
        if (group.getStyle() != null) {
            style = group.getStyle().getDescription();
        }
        session.setAttribute("GROUP_ID", group.getId());
        session.setAttribute("GROUP_NAME", group.getName());
        session.setAttribute("USER_ID", username);
        session.setAttribute("STYLE", style);
        session.setAttribute("SHOW_MESSAGE", true);
        if (addLog) {
            addUserAuthenticationLog(user, session.getId());
        }
    }

    @Override
    public TUserLog addUserAuthenticationLog(User user, String sessionId) {
        TUserLog userLog = new TUserLog();
        userLog.setId(new TUserLogId(user.getLogin(), new Date()));
        userLog.setUser(user);
        userLog.setLoginStatus((byte) 1);
        userLog.setSessionId(sessionId);
        return userLogService.save(userLog);
    }

    @Override
    public User save(UserBean bean, String createBy) {
        User user = new User();

        user.setLogin(bean.getLogin());
        user.setGroup(groupService.findOne(bean.getGroup()));
        user.setUserType(userTypeService.findOne(bean.getType()));
        user.setUserFirstName(bean.getFirstName());
        user.setUserLastName(bean.getLastName());
        user.setUserMiddleName(bean.getMiddleName());
        user.setUserCompanyName(bean.getCompany() != null ? bean.getCompany() : "");
        user.setAddressLine1(bean.getAddressLine1());
        user.setAddressLine2(bean.getAddressLine2());
        user.setAddressLine3(bean.getAddressLine3());
        user.setCity(bean.getCity());
        user.setState(bean.getState());
        user.setPostalCode(bean.getPostalCode());
        user.setCountry(bean.getCountry());
        user.setPrimaryPhone(bean.getPrimaryPhone());
        user.setSecondaryPhone(bean.getSecondaryPhone());
        user.setMobilePhone(bean.getMobilePhone());
        user.setEmailId(bean.getEmail());
        user.setPassword(JDBCRealm.Digest(bean.getPassword1(), "MD5", "utf8"));
        user.setPassword2(bean.getPassword2());
        user.setUserActiveStatus(true);
        user.setUserCreatedBy(createBy);
        user.setUserCreationTime(new Date());
        user.setUserModifiedTime(new Date());

        return userRepository.save(user);
    }
}
