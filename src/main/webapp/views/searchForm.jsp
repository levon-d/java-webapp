<%--
  Created by IntelliJ IDEA.
  User: levondavtyan
  Date: 19/03/2024
  Time: 14:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ucl.ac.uk.models.Model" %>
<%@ page import="java.util.ArrayList" %>

<div style="display: inline-block; width: 48%;">
  <form action="${pageContext.request.contextPath}/viewdata.html" method="get" class="form-inline" style="padding-top: 20px; padding-left: 20px; padding-right: 20px; width: 100%">
    <p style="margin-left: 20px; margin-bottom: 2px">Search</p>
    <div class="form-group mx-sm-3 mb-2" style="width: 100%">
      <input type="text" name="searchText" class="form-control" style="width: 60%" placeholder="Enter search text" />
    </div>
    <div class="form-group mx-sm-3 mb-2" style="width: 100%">
      <select name="columnNameSearch" class="form-control" style="width: 60%">
        <option value="" disabled selected>Select Column to search in </option>
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
