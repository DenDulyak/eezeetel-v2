package com.eezeetel.repository;

import com.eezeetel.entity.TMasterUserTypeAndPrivilege;
import com.eezeetel.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * Created by Denis Dulyak on 09.12.2015.
 */
public interface UserRepository extends JpaRepository<User, Integer> {

    User findByLogin(String login);

    List<User> findByUserType(TMasterUserTypeAndPrivilege userType);

    @Query(value = "from User where User_Login_ID = ?1 " +
            "                                     OR (User_Type_And_Privilege = 6 and User_Login_ID != 'Pending' and User_Active_Status = 1 " +
            "                                     and Customer_Group_ID = ?2 ) order by User_First_Name")
    List<User> findAgentsByUserAndGroup(String login, Integer groupId);
}
