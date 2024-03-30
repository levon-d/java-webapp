<%--
  Created by IntelliJ IDEA.
  User: levondavtyan
  Date: 19/03/2024
  Time: 14:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ucl.ac.uk.models.Model" %>
<%@ page import="java.util.ArrayList" %>


<div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="addModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addModalLabel">Add a new row</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/addpatient" method="post">
                <div class="modal-body">
                    <%
                        Model model = (Model) request.getAttribute("model");
                        ArrayList<String> columnNames = model.getColumnNames();
                        for (String columnName : columnNames) {
                            if (!columnName.equalsIgnoreCase("ID")) {
                    %>
                    <div class="form-group">
                        <label for="<%= columnName %>"><%= columnName %></label>
                        <input type="text" class="form-control" id="<%= columnName %>" name="<%= columnName %>" placeholder="Enter <%= columnName %>">
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add Row</button>
                </div>
            </form>
        </div>
    </div>
</div>
