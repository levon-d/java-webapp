<%--
  Created by IntelliJ IDEA.
  User: levondavtyan
  Date: 20/03/2024
  Time: 01:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ucl.ac.uk.models.Model" %>
<%@ page import="ucl.ac.uk.models.Model" %>
<%@ page import="java.util.ArrayList" %>

<html>
<head>
    <title>List View</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/styles.css">
</head>

<script>
    function showModal(rowIndex) {
        let modal = new bootstrap.Modal(document.getElementById('viewDetailsModal' + rowIndex));
        modal.show();
    }
</script>

<body>
<%
    int rowsPerPage = 20;
    Model model = (Model) request.getAttribute("model");

    int rowCount = model.getRowCount();

    Integer totalPages = (int) Math.ceil((double) rowCount / rowsPerPage);
    String pageNumberParam = request.getParameter("pageNumber");
    Integer pageNumber = pageNumberParam != null ? Integer.parseInt(pageNumberParam) : 1;
    Integer startIndex = (pageNumber - 1) * rowsPerPage;
    Integer endIndex = Math.min(pageNumber * rowsPerPage, model.getRowCount());
    int startPage = Math.max(1, pageNumber - 5);
    int endPage = Math.min(totalPages, pageNumber + 5);

%>

<%--navbar--%>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary p-3">
    <a class="navbar-brand" href="#">Patients Data overview</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbar" >
        <ul class="navbar-nav mr-auto">
            <li class="nav-item active">
                <a class="nav-link" href="${pageContext.request.contextPath}/viewdata.html">Table View</a>
            </li>
            <li class="nav-item active">
                <a class="nav-link"><span class="badge badge-pill" style="background-color: rgba(0, 0, 0, 0.25); border-radius: 12px; margin-top: 3px; ">List View</span></a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/graph.html">Graph</a>
            </li>
        </ul>
    </div>
    <form action="${pageContext.request.contextPath}/savejson" method="post">
        <button type="submit" class="btn btn-light btn-sm ml-auto" data-bs-toggle="modal" style="margin-top: 18px">Save as a json<span style="margin-left: 8px"><img src="${pageContext.request.contextPath}/resources/icons/cloud-download.svg" alt="add"/></span></button>
    </form>
</nav>

<div style="margin-left: 140px; margin-top: 8px">
    <nav style="padding: 4px;">
        <ul class="pagination">
            <li class="page-item<%= pageNumber == 1 ? " disabled" : "" %>">
                <a class="page-link" href="?pageNumber=<%= pageNumber - 1 %>">Previous</a>
            </li>

            <% if (startPage > 1) { %>
            <li class="page-item">
                <a class="page-link" href="?pageNumber=1">...</a>
            </li>
            <% } %>

            <% for (int i = startPage; i <= endPage; i++) { %>
            <li class="page-item<%= i == pageNumber ? " active" : "" %>">
                <a class="page-link" href="?pageNumber=<%= i %>"><%= i %></a>
            </li>
            <% } %>
            <li class="page-item<%= pageNumber == totalPages ? " disabled" : "" %>">
                <a class="page-link" href="?pageNumber=<%= pageNumber + 1 %>">Next</a>
            </li>

            <% if (endPage != totalPages) { %>
            <li class="page-item">
                <a class="page-link" href="?pageNumber=<%=totalPages%>">...</a>
            </li>
            <% } %>

        </ul>
    </nav>
</div>

<div class="container">
    <div class="row">
        <%
            for (int row = startIndex; row < endIndex; row++) {
        %>
        <div class="col-md-4">
            <div class="card border-dark mb-3">
                <div class="card-header">ID: <%= model.getValue("ID", row) %></div>
                <div class="card-body">
                    <h5 class="card-title"><%= model.getValue("FIRST", row) %> <%= model.getValue("LAST", row) %></h5>
                    <p class="card-text">
                        Birthdate: <%= model.getValue("BIRTHDATE", row) %><br>
                        Gender: <span class="badge rounded-pill text-bg-primary"><%= model.getValue("GENDER", row)%></span>
                    </p>
                    <button type="button" class="btn btn-primary" onclick="showModal(<%= row %>)">
                        View Details
                    </button>
                </div>
            </div>
        </div>

        <div class="modal fade" id="viewDetailsModal<%=row%>" tabindex="-1" role="dialog" aria-labelledby="viewDetailsModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editModalLabel">View patient</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <%
                            ArrayList<String> columnNames = model.getColumnNames();
                            for (String columnName : columnNames) {
                        %>
                        <text color="muted"> <%= columnName %>: <span class="fw-bold"> <%= model.getValue(columnName, row) %> </span> </text>
                        <br>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

<jsp:include page="viewDetailsModal.jsp"/>
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
