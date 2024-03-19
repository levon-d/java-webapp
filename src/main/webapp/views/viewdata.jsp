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
                <a class="nav-link" href="#">Graphs</a>
            </li>
        </ul>
    </div>
    <button class="btn btn-light btn-sm ml-auto" style="margin-top: 2px" data-bs-toggle="modal" data-bs-target="#addModal">Add new row <span><img src="${pageContext.request.contextPath}/resources/icons/plus.svg" alt="add"/></span></button>
</nav>



<div style="display: flex; justify-content: space-between; width: 100%;">
    <div style="display: inline-block; width: 48%;">
        <form action="${pageContext.request.contextPath}/viewdata.html" method="get" class="form-inline" style="padding-top: 20px; padding-left: 20px; padding-right: 20px; width: 100%">
            <p style="margin-left: 20px; margin-bottom: 2px">Search</p>
            <div class="form-group mx-sm-3 mb-2" style="width: 100%">
                <input type="text" name="searchText" class="form-control" style="width: 60%" placeholder="Enter search text" />
            </div>
            <div class="form-group mx-sm-3 mb-2" style="width: 100%">
                <select name="columnNameSearch" class="form-control" style="width: 60%">
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
    </div>
    <div style="display: inline-block; width: 48%;">
        <form action="${pageContext.request.contextPath}/viewdata.html" method="get" class="form-inline" style="padding-top: 20px; padding-left: 20px; padding-right: 20px; width: 100%">
            <p style="margin-left: 20px; margin-bottom: 2px">Sort</p>
            <div class="form-group mx-sm-3 mb-2" style="width: 100%">
                <select name="sortOrder" class="form-control" style="width: 60%">
                    <option value=<%=Model.SortOrder.ASC%>>Ascending</option>
                    <option value=<%=Model.SortOrder.DESC%>>Descending</option>
                </select>
            </div>
            <div class="form-group mx-sm-3 mb-2" style="width: 100%">
                <select name="columnNameSort" class="form-control" style="width: 60%">
                    <option value="">Select Column to sort </option>
                    <%
                        for (String columnName : columnNames) {
                    %>
                    <option value="<%= columnName %>"><%= columnName %></option>
                    <%
                        }
                    %>
                </select>
                <input type="number" name="limit" class="form-control" style="width: 60%; margin-top:8px" placeholder="Enter limit" />
                <button type="submit" class="btn btn-primary" style="margin-top:8px">Sort</button>
                <a href="${pageContext.request.contextPath}/viewdata.html" class="btn btn-secondary" style="margin-top:8px">Clear</a>
            </div>
            <div></div>
        </form>
    </div>

</div>
<div class="table-container" style="margin-top: 4px">
    <table class="table table-bordered table-hover table-responsive-sm">
        <thead style="background-color: #E5E9F2; color: #949494;">

        <tr style="border-top: none">
            <th style="border-left: none; border-right: none; padding: 10px;"> Actions </th>
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
            <td style="border-right: none; border-left: none; padding: 12px">
                <button type="button" class="btn custom-btn" data-bs-toggle="modal" data-bs-target="#editModal"> <img src="${pageContext.request.contextPath}/resources/icons/pencil.svg" alt="Edit"/> </button>
                <button type="button" class="btn custom-btn" style="margin-top: 4px;" data-bs-toggle="modal" data-bs-target="#deleteModal"> <img src="${pageContext.request.contextPath}/resources/icons/trash3.svg" alt="Edit"/> </button>
            </td>
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
            <td style="border-right: none; border-left: none; padding: 12px">
                <button type="button" class="btn custom-btn" data-bs-toggle="modal" data-bs-target="#editModal" onclick="setSelectedId('<%= model.getValue("ID", row) %>')"> <img src="${pageContext.request.contextPath}/resources/icons/pencil.svg" alt="Edit"/> </button>
                <button type="button" class="btn custom-btn" style="margin-top: 4px;" data-bs-toggle="modal" data-bs-target="#deleteModal" onclick="setSelectedId('<%= model.getValue("ID", row) %>')"> <img src="${pageContext.request.contextPath}/resources/icons/trash3.svg" alt="Edit"/> </button>
            </td>
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


<%--Delete modal--%>
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="exampleModalLabel">Confirm Deletion</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/deletepatient" method="post" class="form-inline">
                <input type="hidden" name="selectedId" id="selectedId"/>
                <div class="modal-body">
                        <p>Are you sure you want to delete this row? The change will be irreversible</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-danger">Delete</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Row Modal -->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editModalLabel">Edit Row</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <form action="${pageContext.request.contextPath}/editpatient" method="post" class="form-inline">
                <div class="modal-body">
                        <div class="form-group">
                            <label for="columnSelect">Select Column to Edit</label>
                            <select class="form-control" id="columnSelect" name="columnNameToEdit">
                                <option value="">Select Column</option>
                                <%
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

<!-- Add Row Modal -->
<div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="addModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addModalLabel">Add New Row</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <form action="${pageContext.request.contextPath}/addpatient" method="post">
                <div class="modal-body">
                    <%
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


<%--success--%>
<%
    String successMessage = (String) request.getAttribute("successMessage");
    if (successMessage != null && !successMessage.isEmpty()) {
%>
<div class="toast align-items-center text-bg-success border-0 d-none" role="alert" aria-live="assertive" aria-atomic="true" id="successToast">
    <div class="d-flex">
        <div class="toast-body">
            <%= successMessage %>
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
</div>
<%
    }
%>

<!-- Toast -->
<div class="toast">
    <div class="toast-header">
        <strong class="mr-auto">Bootstrap</strong>
        <small>11 mins ago</small>
        <button type="button" class="ml-2 mb-1 close" data-dismiss="toast">
            <span>&times;</span>
        </button>
    </div>
    <div class="toast-body">
        Hello, world! This is a toast message.
    </div>
</div>


<%--error--%>
<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage != null && !errorMessage.isEmpty()) {
%>
<div class="toast align-items-center text-bg-danger border-0 d-none" role="alert" aria-live="assertive" aria-atomic="true" id="errorToast">
    <div class="d-flex">
        <div class="toast-body">
            <%= errorMessage %>
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
</div>
<%
    }
%>


<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>


