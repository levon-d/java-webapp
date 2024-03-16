<%--
  Created by IntelliJ IDEA.
  User: levondavtyan
  Date: 14/03/2024
  Time: 16:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ucl.ac.uk.models.Model" %>
<%@ page import="java.util.ArrayList" %>
<html>
<head>
    <title>Data Overview</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/styles.css">
    <style>
        .table-container {
            width: 95%; /* Set width of the container */
            overflow: auto; /* Enable scrolling */
            margin: 0 auto; /* Center the container horizontally */
            border-radius: 10px;
            border: 2px solid #C7C7C7;
        }
    </style>
</head>
<body>
<form action="${pageContext.request.contextPath}/viewdata.html" method="get" class="form-inline" style="padding-top: 20px; padding-left: 20px; padding-right: 20px">
    <div class="form-group mx-sm-3 mb-2">
        <input type="text" name="searchText" class="form-control" style="width: 25%" placeholder="Enter search text" />
    </div>
    <div class="form-group mx-sm-3 mb-2">
        <select name="columnName" class="form-control" style="width: 25%">
            <option value="">Select Column to search in </option>
            <%
                Model model = (Model) request.getAttribute("model");
                ArrayList<String> columnNames = model.getColumnNames();
                for (String columnName : columnNames) {
            %>
            <option value="<%= columnName %>"><%= columnName %></option>
            <%
                }
            %>
        </select>
        <button type="submit" class="btn btn-primary" style="margin-top:8px">Search</button>
        <a href="${pageContext.request.contextPath}/viewdata.html" class="btn btn-secondary" style="margin-top:8px">Clear</a>
    </div>
</form>
<div class="table-container" style="margin-top: 4px">
    <table class="table table-bordered table-hover table-responsive-sm">
        <thead style="background-color: #E5E9F2; color: #949494;">
        <tr style="border-top: none">
            <%
                for (String columnName : columnNames) {
            %>
            <th style="border-left: none; border-right: none; padding: 10px;"><%= columnName %></th>
            <%
                }
            %>
        </tr>
        </thead>
        <tbody>
        <%
            ArrayList<String> matchedIds = (ArrayList<String>) request.getAttribute("matchedIds");
            int rowCount = model.getRowCount();
            if (matchedIds != null && !matchedIds.isEmpty()) {
                for (String id : matchedIds) {
                    int rowIndex = -1;
                    for (int row = 0; row < rowCount; row++) {
                        if (model.getValue("ID", row).equals(id)) {
                            rowIndex = row;
                            break;
                        }
                    }
                    if (rowIndex != -1) {
        %>
        <tr style="background-color: #ffffff">
            <%
                for (String columnName : columnNames) {
            %>
            <td style="border-right: none; border-left: none; padding: 12px"><%= model.getValue(columnName, rowIndex) %></td>
            <%
                }
            %>
        </tr>
        <%
                }
            }
        } else {
            for (int row = 0; row < rowCount; row++) {
        %>
        <tr style="background-color: #ffffff">
            <%
                for (String columnName : columnNames) {
            %>
            <td style="border-right: none; border-left: none; padding: 12px"><%= model.getValue(columnName, row) %></td>
            <%
                }
            %>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>
</div>
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>


