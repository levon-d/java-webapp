<%--
  Created by IntelliJ IDEA.
  User: levondavtyan
  Date: 19/03/2024
  Time: 22:49
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
        .custom-btn {
            background-color: #E5E9F2; /* Your custom color */
            border-color: #E5E9F2; /* Border color same as background color */
        }
        /* Maintain Bootstrap hover effect */
        .custom-btn:hover {
            background-color: #c2c6cf; /* Your custom color on hover */
            border-color: #c2c6cf; /* Border color on hover */
        }
    </style>
</head>
<body>
<script>
    function setSelectedId(selectedId) {
        document.getElementById('selectedId').value = selectedId;
        document.getElementById('selectedIdToEdit').value = selectedId;
    }
</script>
<%--navbar--%>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary p-3">
    <a class="navbar-brand" href="#">Patients Data overview</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbar" >
        <ul class="navbar-nav mr-auto">
            <li class="nav-item active">
                <a class="nav-link" href="#"><span class="badge badge-pill" style="background-color: rgba(0, 0, 0, 0.25); border-radius: 12px; margin-top: 3px; ">Table view</span></a>
            </li>
            <li class="nav-item active">
                <a class="nav-link" href="list">List view</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/graph.html">Graphs</a>
            </li>
        </ul>
    </div>
    <form action="${pageContext.request.contextPath}/savejson" method="post">
        <button type="submit" class="btn btn-light btn-sm ml-auto" data-bs-toggle="modal" style="margin-top: 18px">Save as a json<span style="margin-left: 8px"><img src="${pageContext.request.contextPath}/resources/icons/cloud-download.svg" alt="add"/></span></button>
    </form>
    <button class="btn btn-light btn-sm ml-auto" style="margin-top: 2px; margin-left: 8px" data-bs-toggle="modal" data-bs-target="#addModal">Add new row <span><img src="${pageContext.request.contextPath}/resources/icons/plus.svg" alt="add"/></span></button>
</nav>



<div style="display: flex; justify-content: space-between; width: 100%;">
    <jsp:include page="searchForm.jsp"/>
    <jsp:include page="sortForm.jsp"/>
</div>
<div class="table-container" style="margin-top: 4px">
    <jsp:include page="table.jsp"/>
</div>


<%--Delete modal--%>
<jsp:include page="deleteModal.jsp"/>

<!-- Edit Row Modal -->
<jsp:include page="editModal.jsp"/>

<!-- Add Row Modal -->
<jsp:include page="addModal.jsp"/>

<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
