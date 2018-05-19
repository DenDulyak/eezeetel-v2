package com.eezeetel.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by Denis Dulyak on 24.02.2016.
 */
@Controller
public class MainController {

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String index(HttpServletRequest request, @RequestParam(required = false) Integer failed) {
        if (failed != null) {
            request.setAttribute("failed", 1);
        }
        return getIndex(request.getServerName());
    }

    private String getIndex(String host) {
        String index = "index";
        if (host.contains("gsmtopup")) {
            index = "GSMApp/Login";
        } else if (host.contains("kasglobal")) {
            index = "KASApp/index";
        } else if (host.contains("mobitopup")) {
            index = "mobitopup/index";
        } else if (host.contains("fasttopup")) {
            index = "FastTelApp/index";
        } else if (host.contains("kupay")) {
            index = "KupayApp/index";
        } else if (host.contains("taajtopup")) {
            index = "taajtopup/index";
        }
        return index;
    }
}
