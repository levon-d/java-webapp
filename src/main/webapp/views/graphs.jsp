<%--
  Created by IntelliJ IDEA.
  User: levondavtyan
  Date: 19/03/2024
  Time: 16:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ucl.ac.uk.models.Model" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.Period" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<html>
<head>
    <title>Age Distribution</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/styles.css">
</head>
<body>
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
                <a class="nav-link" href="${pageContext.request.contextPath}/list.html">List view</a>
            </li>
            <li class="nav-item">
                <a class="nav-link"><span class="badge badge-pill" style="background-color: rgba(0, 0, 0, 0.25); border-radius: 12px; margin-top: 3px; ">Graph</span></a>
            </li>
        </ul>
    </div>
</nav>


<%
    ArrayList<String> labels = (ArrayList<String>) request.getAttribute("labels");
    ArrayList<Integer> data = (ArrayList<Integer>) request.getAttribute("data");
%>
<div class="container-md" style="margin: 0 auto; justify-content: center; align-items: center; display: flex; height: 100vh;">
    <canvas id="ageDistributionChart"></canvas>
</div>

<script>
    let ctx = document.getElementById('ageDistributionChart').getContext('2d');
    let ageDistributionChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: <%=labels%>,
            datasets: [{
                label: 'Age Distribution',
                data: <%=data%>,
                backgroundColor: 'rgba(255, 99, 132, 1)',
                borderColor: 'rgba(255,99,132, 1)',
                borderWidth: 2,
                borderRadius: 5
            }]
        },
        options: {
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Age'
                    }
                },
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Number of People'
                    }
                }
            }
        }
    });
</script>
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>

