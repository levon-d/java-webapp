<%--
  Created by IntelliJ IDEA.
  User: levondavtyan
  Date: 20/03/2024
  Time: 02:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ucl.ac.uk.models.Model" %>
<%@ page import="java.util.ArrayList" %>

<%
    String rowParam = request.getParameter("row");
    int row = -1;
    if (rowParam != null) {
        row = Integer.parseInt(rowParam);
    }%>

<div class="modal fade" id="viewDetailsModal" tabindex="-1" role="dialog" aria-labelledby="viewDetailsModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="editModalLabel">View patient</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
        <div class="modal-body">
            <%
                if (row >= 0) {
                    Model model = (Model) request.getAttribute("model");
                    ArrayList<String> columnNames = model.getColumnNames();
                    for (String columnName : columnNames) {
            %>
            <text color="muted"> <%= columnName %>: <%= model.getValue(columnName, row) %> </text>
            <br>
            <%
                }
            } else {
            %>
            <p>No row selected.</p>
                <%
                    }
                %>
          </div>
        </div>
    </div>
  </div>