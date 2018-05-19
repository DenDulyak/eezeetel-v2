<div class="modal fade" id="mobipopupModal" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Mobile Topup</h4>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <table>
                        <tr>
                            <td id="m_company" align="left"></td>
                        </tr>
                        <tr>
                            <td id="m_operator" align="left"></td>
                        </tr>
                        <tr>
                            <td id="m_country" align="left"></td>
                        </tr>
                        <tr>
                            <td align="left"><b>* Top-Up Successful *</b></td>
                        </tr>
                        <tr>
                            <td id="m_amount" align="left"></td>
                        </tr>
                        <tr>
                            <td id="m_receiver" align="left"></td>
                        </tr>
                        <tr>
                            <td align="left"><b>****************************</b></td>
                        </tr>
                        <tr>
                            <td id="m_transaction" align="left"></td>
                        </tr>
                        <tr>
                            <td id="m_order_id" align="left"></td>
                        </tr>
                        <tr>
                            <td id="m_transaction_time" align="left"></td>
                        </tr>
                        <tr>
                            <td align="left"><b>****************************</b></td>
                        </tr>
                        <tr>
                            <td id="m_destination_value" align="left"></td>
                        </tr>
                        <%--            <tr>
                                      <td align="left"><b>Destination Value(Excl. Tax) : <%=df.format(theResponse.m_fDestTopupValueAfterTax)%>
                                        % </b>
                                      </td>
                                    </tr>--%>
                        <%--            <tr>
                                      <td align="left"><b>Destination Tax : <%=df.format(theResponse.m_fDestTax)%>% </b></td>
                                    </tr>--%>
                        <tr>
                            <td id="m_local_currency" align="left"></td>
                        </tr>
                        <tr>
                            <td align="center"><b>International Recharge Successful</b></td>
                        </tr>
                        <%--<tr>
                          <td align="left"><b>Customer Care : <%=theResponse.m_strCustomerCare%>
                          </b></td>
                        </tr>--%>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary printButton">Print</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>