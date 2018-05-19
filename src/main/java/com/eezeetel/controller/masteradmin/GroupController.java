package com.eezeetel.controller.masteradmin;

import com.eezeetel.bean.GroupBean;
import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.service.GroupService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Created by Denis Dulyak on 17.09.2015.
 */
@RestController
@RequestMapping("/masteradmin/group")
public class GroupController {

    @Autowired
    private GroupService groupService;

    @RequestMapping(value = "/get", method = RequestMethod.GET)
    public ResponseEntity<GroupBean> getById(@RequestParam Integer id) {
        return ResponseEntity.ok(GroupBean.toBean(groupService.findOne(id)));
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public ResponseEntity<TMasterCustomerGroups> saveGroup(@ModelAttribute GroupBean bean) {
        return ResponseEntity.ok(groupService.createOrUpdate(bean));
    }

    @RequestMapping(value = "/find-all", method = RequestMethod.GET)
    public ResponseEntity<List<TMasterCustomerGroups>> findAll() {
        return ResponseEntity.ok(groupService.findAllActive());
    }
}
