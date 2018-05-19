<div class="modal fade" id="featureModal" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Feature</h4>
      </div>
      <form action="${pageContext.request.contextPath}/masteradmin/feature/save" method="POST" role="form">
        <div class="modal-body">
          <input type="hidden" id="featureId" name="id"/>
          <div class="form-group">
            <label for="title">Title:</label>
            <input type="text" class="form-control" id="title" name="title"/>
          </div>
<%--          <div class="checkbox">
            <label><input type="checkbox" id="isSim" name="isSim">Is Sim</label>
          </div>--%>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-success save">Save</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</div>
