<div class="modal fade" id="reprintTransactionModal" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Reprint Transaction</h4>
      </div>
      <div class="modal-footer no-print">
        <button type="button" class="btn btn-primary printButton">Print</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
      <div class="modal-body">
        <div class="container reprintContainer">
        </div>
      </div>
    </div>
  </div>
</div>

<div style="display: none">
  <div id="simCardForm" class="form-horizontal">
    <div class="form-group">
      <label>Company:</label>
      <span id="simCompanyName"></span>
    </div>
    <div class="form-group">
      <label>Transaction Number:</label>
      <span id="simTransactionNumber"></span>
    </div>
    <div class="form-group">
      <label>Transaction Time:</label>
      <span id="simTransactionTime"></span>
    </div>
    <div class="form-group">
      <label>Product:</label>
      <span id="simProduct"></span>
    </div>
    <div class="form-group">
      <label>New Mobile Number:</label>
      <span id="simPin"></span>
    </div>
    <div class="form-group">
      <label>Total Topups:</label>
      <span id="simTotalPopups"></span>
    </div>
  </div>
</div>

<div style="display: none">
  <div id="phoneTopupForm" class="form-horizontal">
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
      <tr>
        <td id="m_local_currency" align="left"></td>
      </tr>
    </table>
  </div>
</div>