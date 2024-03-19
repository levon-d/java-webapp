<%--
  Created by IntelliJ IDEA.
  User: levondavtyan
  Date: 19/03/2024
  Time: 22:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<head>
  <title>Error Page</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/styles.css">
</head>
<body>
  <%
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage != null) {
  %>
  <div class="d-flex justify-content-center align-items-center" style="height: 100vh;">
    <div class="card text-bg-danger" style="width: 20%; height: 20%">
      <div class="card-header">Error</div>
      <div class="card-body">
        <h5 class="card-title">An error has occurred</h5>
        <p class="card-text"><%=errorMessage%></p>
      </div>
    </div>
  </div>
  <%
    }
  %>
  <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>



