<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector" %>
<% 
   String sqlStatement = (String) session.getAttribute("sqlStatement");
   if (sqlStatement == null) sqlStatement = "select * from suppliers";
   String message = (String) session.getAttribute("message");
   if (message == null) message = " ";
%>

<!DOCTYPE html>
    
    <!-- Name: Michael Gilday
    Course: CNT 4714 – Fall 2023 – Project Four
    Assignment title: A Three-Tier Distributed Web-Based Application
    Date: December 5, 2023 -->
<html lang="en">
<head>
    <title>Welcome to the Fall 2023 Project 4 Enterprise System</title>
    <style type="text/css">
        body {
            background-color: black;
            text-align: center;
            font-family: Calibri, Arial, sans-serif;
            color: white;
        }

        #welcomeHeader {
            font-size: xx-large;
            font-weight: bold;
            color: red;
            margin-top: 20px;
        }

        #systemDescription {
            font-size: xx-large;
            font-weight: bold;
            color: blue;
            margin-top: 10px;
        }

        #divider {
            border-bottom: 2px solid grey;
            margin: 20px 0;
        }

        #databaseInfo {
            color: white;
            margin-top: 20px;
        }

        #clientLevel {
            color: red;
            font-weight: bold;
        }

        #queryInstructions {
            margin-top: 10px;
        }

        #resultsMargin {
            margin-top: 20px;
        }

        #executeCommandBtn {
            font-size: large;
            font-weight: bold;
            color: green;
        }

        #resetFormBtn {
            font-size: large;
            font-weight: bold;
            color: red;
        }

        #clearResultsBtn {
            font-size: large;
            font-weight: bold;
            color: orange;
        }

        #data {
            margin-top: 20px;
            border-collapse: collapse;
            width: 80%;
            margin-left: auto;
            margin-right: auto;
        }

        #data th, #data td {
            border: 1px solid white;
            padding: 8px;
            text-align: center;
        }

        #data th {
            background-color: red;
            color: white;
            font-weight: bold;
        }

        #data tr:nth-child(even) {
            background-color: lightgrey;
        }

        #data tr:nth-child(odd) {
            background-color: white;
        }

        .black-text {
            color: black;
        }
        
        .error-box {
            background-color: red;
            color: white;
            padding: 10px;
            margin: 20px auto;
            width: 50%;
            text-align: center;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div id="welcomeHeader">
        Welcome to the Fall 2023 Project 4 Enterprise System
    </div>
    <div id="systemDescription">
        A Servlet/JSP-based Multi-tiered Enterprise Application Using A Tomcat Container
    </div>
    <div id="divider"></div>
    <div id="databaseInfo">
        You are connected to the Project 4 Enterprise System database as a <span id="clientLevel">client-level</span> user.
    </div>
    <div id="queryInstructions">
        Please enter any SQL query or update command in the box below.
    </div>
    <form action="/Project-4/client-user" method="post">
        <textarea id="cmd" name="sqlStatement" rows="8" cols="60"><%=sqlStatement%></textarea><br>
        <br>
        <input id="executeCommandBtn" type="submit" value="Execute Command" /> &nbsp; &nbsp; &nbsp;
        <input id="resetFormBtn" type="reset" value="Reset Form" onclick="javascript:resetText();" /> &nbsp; &nbsp; &nbsp;
        <input id="clearResultsBtn" type="button" value="Clear Results" onclick="javascript:eraseData();" />
    </form>
    <div id="resultsMargin">
        All execution results will appear below this line.
    </div>
    <div id="divider"></div>
    <div id="resultsMargin">
        Execution Results:
    </div> 
    <% if (request.getAttribute("errorMessage") != null) { %>
        <table id="data">
            <tr>
                <th>Error Executing the SQL Statement:</th>
            </tr>
            <tr>
                <td class="error-box"><%= request.getAttribute("errorMessage") %></td>
            </tr>
        </table>
    <% } else { %>
        <table id="data">
            <% 
                Vector<String> columns = (Vector<String>)request.getAttribute("columns");
                Vector<Vector<String>> results = (Vector<Vector<String>>)request.getAttribute("results");

                if (columns != null) { %>
                    <tr>
                        <% for (String column : columns) { %>
                            <th><%= column %></th>
                        <% } %>
                    </tr>
                    <% if (results != null) { 
                        boolean isOddRow = true;
                        for (Vector<String> row : results) { %>
                            <%
                                String rowColor = (isOddRow) ? "lightgrey" : "white";
                                isOddRow = !isOddRow;
                            %>
                            <tr style="background-color: <%= rowColor %>;">
                                <% for (String cell : row) { %>
                                    <td class="black-text"><%= cell %></td>
                                <% } %>
                            </tr>
                        <% } } else { %>
                            <tr>
                                <td colspan="<%= (columns != null) ? columns.size() : 0 %>"><%= request.getAttribute("message") %></td>
                            </tr>
                        <% } %>
                    <% } %>
        </table>
    <% } %>
    <script>
        function resetText() {
            document.getElementById("cmd").value = "select * from suppliers";
        }
        
        function eraseData() {
            var table = document.getElementById("data");
            table.innerHTML = "";
            var table2 = document.getElementById("errorMessageBox");
            table2.innerHTML = "";
        }
    </script>
</body>
</html>