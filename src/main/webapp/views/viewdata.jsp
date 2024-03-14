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
</head>
<body>
    <div class="container-fluid" style="margin-top: 2rem;">
        <table class="table table-sm table-striped table-dark rounded-3" style="border-spacing: 2px; border-collapse: collapse;">
        <thead class="thead-dark">
                <tr>
                    <%
                        Model model = (Model) request.getAttribute("model");
                        ArrayList<String> columnNames = model.getColumnNames();
                        for (String columnName : columnNames) {
                    %>
                    <th><%= columnName %></th>
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
                <tr>
                    <%
                        for (String columnName : columnNames) {
                    %>
                        <td><%= model.getValue(columnName, row) %></td>
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
