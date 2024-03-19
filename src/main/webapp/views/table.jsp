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

<table class="table table-bordered table-hover table-responsive-sm">
  <thead style="background-color: #E5E9F2; color: #949494;">

  <tr style="border-top: none">
    <th style="border-left: none; border-right: none; padding: 10px;"> Actions </th>
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
