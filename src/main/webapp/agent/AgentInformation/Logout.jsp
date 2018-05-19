<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/common/imports.jsp"%>
<%@ include file="AgentSessionCheck.jsp"%>
<%
	response.sendRedirect(ksContext + "/AgentInformation/AgentInformation.jsp");
	session.invalidate();
%>