<%@ page import="java.util.Objects" %>

<%
    String strAddPage = "New" + request.getParameter("follow_up_page") + ".jsp";
    String strModifyPage = "Modify" + request.getParameter("follow_up_page") + ".jsp";
    String strActivatePage = "Activate" + request.getParameter("follow_up_page") + ".jsp";
    String strDeletePage = "Delete" + request.getParameter("follow_up_page") + ".jsp";

    if (Objects.equals(request.getParameter("follow_up_page"), "ProductSaleInfo")) {
        strAddPage = "new-product-sale-info";
        strModifyPage = "modify-product-sale-info";
    }
    if (Objects.equals(request.getParameter("follow_up_page"), "SupplierInfo")) {
        strAddPage = "new-supplier";
        strModifyPage = "modify-supplier";
    }
    if (Objects.equals(request.getParameter("follow_up_page"), "BatchInfo")) {
        strAddPage = "new-batch";
        strModifyPage = "modify-batch";
    }
%>

<tr>
    <td></td>
</tr>

<tr>
    <td align="center">
        <a href="MasterInformation.jsp"> Go to Main </a>
    </td>

    <td align="center">
        <input type="button" name="add_button" value="Add" OnClick="SubmitForm('<%=strAddPage%>', false);">
    </td>

    <td align="center">
        <input type="button" name="modify_button" value="Modify" OnClick="SubmitForm('<%=strModifyPage%>', true);">
    </td>

    <td align="center">
        <input type="button" name="activate_button" value="Activate" onclick="SubmitForm('<%=strActivatePage%>', true);">
    </td>

    <td align="center">
        <input type="button" name="delete_button" value="Delete" OnClick="SubmitForm('<%=strDeletePage%>', true);">
    </td>
</tr>