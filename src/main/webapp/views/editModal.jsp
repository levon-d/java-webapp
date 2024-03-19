<%--
  Created by IntelliJ IDEA.
  User: levondavtyan
  Date: 19/03/2024
  Time: 14:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ucl.ac.uk.models.Model" %>
<%@ page import="java.util.ArrayList" %>

<div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="editModalLabel">Edit Row</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="${pageContext.request.contextPath}/editpatient" method="post" class="form-inline">
        <div class="modal-body">
          <div class="form-group">
            <label for="columnSelect">Select Column to Edit</label>
            <select class="form-control" id="columnSelect" name="columnNameToEdit">
              <option value="">Select Column</option>
              <%
                Model model = (Model) request.getAttribute("model");
                ArrayList<String> columnNames = model.getColumnNames();
                for (String columnName : columnNames) {
                  // don't allow editing of primary key
                  if (columnName.equals("ID")) continue;
              %>
              <option value="<%= columnName %>"><%= columnName %></option>
              <%
                }
              %>
            </select>
          </div>
          <div class="form-group" style="margin-top: 12px">
            <label for="newValue">New Value</label>
            <input type="text" class="form-control" id="newValue" placeholder="Enter new value" name="newValue">
            <input type="hidden" name="selectedId" id="selectedIdToEdit"/>
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary" id="confirmEditBtn">Save Changes</button>
        </div>
      </form>
    </div>
  </div>
</div>
