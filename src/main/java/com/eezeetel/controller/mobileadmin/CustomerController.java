package com.eezeetel.controller.mobileadmin;

import com.eezeetel.entity.TMasterCustomerGroups;
import com.eezeetel.entity.TMessages;
import com.eezeetel.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Created by Denis Dulyak on 23.06.2016.
 */
@RestController("mobileAdminCustomerController")
@RequestMapping("/mobileadmin/customer")
public class CustomerController {

    @Autowired
    private MessageService messageService;

    @RequestMapping(value = "/get-message-by-group", method = RequestMethod.GET)
    public ResponseEntity<List<TMessages>> getMessageByGroup(@RequestParam Integer groupId) {
        return ResponseEntity.ok(messageService.findByGroup(new TMasterCustomerGroups(groupId)));
    }

    @RequestMapping(value = "/set-message-to-group", method = RequestMethod.POST)
    public ResponseEntity<List<TMessages>> setMessageToGroup(@RequestParam Integer groupId, @RequestParam String message) {
        return ResponseEntity.ok(messageService.setMessageToGroup(groupId, message));
    }

    @RequestMapping(value = "/remove-message-from-group", method = RequestMethod.POST)
    public ResponseEntity removeMessageFromGroup(@RequestParam Integer groupId) {
        messageService.deleteFromGroup(new TMasterCustomerGroups(groupId));
        return new ResponseEntity(HttpStatus.OK);
    }
}
