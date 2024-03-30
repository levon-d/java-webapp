<%--
  Created by IntelliJ IDEA.
  User: levondavtyan
  Date: 19/03/2024
  Time: 14:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="ucl.ac.uk.models.Model" %>
<%@ page import="java.util.ArrayList" %>

<head>
  <title>Data Overview</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/styles.css">
</head>

<%
  int rowsPerPage = 20;
  Model model = (Model) request.getAttribute("model");

  ArrayList<String> matchedIds = (ArrayList<String>) request.getAttribute("matchedIds");
  int rowCount = (matchedIds != null && !matchedIds.isEmpty()) ? matchedIds.size() : model.getRowCount();

  Integer totalPages = (int) Math.ceil((double) rowCount / rowsPerPage);
  String pageNumberParam = request.getParameter("pageNumber");
  Integer pageNumber = pageNumberParam != null ? Integer.parseInt(pageNumberParam) : 1;
  Integer startIndex = (pageNumber - 1) * rowsPerPage;
  Integer endIndex = Math.min(pageNumber * rowsPerPage, rowCount);
  int startPage = Math.max(1, pageNumber - 5);
  int endPage = Math.min(totalPages, pageNumber + 5);

  String sortParam = request.getParameter("sortOrder");
  String columnNameSort = request.getParameter("columnNameSort");

  String searchParam = request.getParameter("searchText");
  String columnNameSearchParam = request.getParameter("columnNameSearch");

  String queryParams = "";

  if (sortParam != null && !sortParam.isEmpty()) {
    queryParams += "&sortOrder=" + sortParam;
  }
  if (columnNameSort != null && !columnNameSort.isEmpty()) {
    queryParams += "&columnNameSort=" + columnNameSort;
  }
  if (searchParam != null && !searchParam.isEmpty()) {
    queryParams += "&searchText=" + searchParam;
  }
  if (columnNameSearchParam != null && !columnNameSearchParam.isEmpty()) {
    queryParams += "&columnNameSearch=" + columnNameSearchParam;
  }
%>

<style>
  .table-container {
    width: 95%;
    overflow: auto;
    margin: 0 auto;
    border-radius: 10px;
    border: 2px solid #C7C7C7;
  }
  .custom-btn {
    background-color: #E5E9F2;
    border-color: #E5E9F2;
  }

  .custom-btn:hover {
    background-color: #c2c6cf;
    border-color: #c2c6cf;
  }
</style>

<div style="margin-left: 40px">
  <nav style="padding: 4px;">
    <ul class="pagination">
      <li class="page-item<%= pageNumber == 1 ? " disabled" : "" %>">
        <a class="page-link" href="?pageNumber=<%= pageNumber - 1 %><%=queryParams%>">Previous</a>
      </li>

      <% if (startPage > 1) { %>
      <li class="page-item">
        <a class="page-link" href="?pageNumber=1<%=queryParams%>">...</a>
      </li>
      <% } %>

      <% for (int i = startPage; i <= endPage; i++) { %>
      <li class="page-item<%= i == pageNumber ? " active" : "" %>">
        <a class="page-link" href="?pageNumber=<%= i %><%=queryParams%>"><%= i %></a>
      </li>
      <% } %>
      <li class="page-item<%= pageNumber == totalPages ? " disabled" : "" %>">
        <a class="page-link" href="?pageNumber=<%= pageNumber + 1 %><%=queryParams%>">Next</a>
      </li>

      <% if (endPage != totalPages) { %>
      <li class="page-item">
        <a class="page-link" href="?pageNumber=<%=totalPages%><%=queryParams%>">...</a>
      </li>
      <% } %>
    </ul>
  </nav>
</div>


<div class="table-container" style="margin-top: 4px">
  <table class="table table-bordered table-hover table-responsive-sm">
    <thead style="background-color: #E5E9F2; color: #949494;">

    <tr style="border-top: none">
      <th style="border-left: none; border-right: none; padding: 10px;"> Actions </th>
      <%

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
      if (matchedIds != null && !matchedIds.isEmpty()) {
        for (int i = startIndex; i < endIndex; i++) {
          String id = matchedIds.get(i);
          int rowIndex = -1;
          for (int row = 0; row < model.getRowCount(); row++) {
            if (model.getValue("ID", row).equals(id)) {
              rowIndex = row;
              break;
            }
          }
          if (rowIndex != -1) {
    %>
    <tr style="background-color: #ffffff">
      <td style="border-right: none; border-left: none; padding: 12px">
        <button type="button" class="btn custom-btn" data-bs-toggle="modal" data-bs-target="#editModal" onclick="setSelectedId('<%= model.getValue("ID", rowIndex) %>')"> <img src="${pageContext.request.contextPath}/resources/icons/pencil.svg" alt="Edit"/> </button>
        <button type="button" class="btn custom-btn" style="margin-top: 4px;" data-bs-toggle="modal" data-bs-target="#deleteModal" onclick="setSelectedId('<%= model.getValue("ID", rowIndex) %>')"> <img src="${pageContext.request.contextPath}/resources/icons/trash3.svg" alt="Edit"/> </button>
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
      for (int row = startIndex; row < endIndex; row++) {
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
