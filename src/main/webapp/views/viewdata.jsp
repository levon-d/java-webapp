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
            border: 1px solid #C7C7C7;
        }
    </style>
</head>
<body>
<div class="table-container" style="margin-top: 20px">
    <table class="table table-bordered table-hover table-responsive-sm">
        <thead style="background-color: #F7F7F7; color: #949494;">
        <tr style="border-top: none">
            <%
                Model model = (Model) request.getAttribute("model");
                ArrayList<String> columnNames = model.getColumnNames();
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
            int rowCount = model.getRowCount();
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
        %>
        </tbody>
    </table>
</div>
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>


