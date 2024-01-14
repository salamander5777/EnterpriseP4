<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.util.Vector" %>

<% 
    Vector<String> columns = (Vector<String>) request.getAttribute("columns");
    Vector<Vector<String>> results = (Vector<Vector<String>>) request.getAttribute("results");
    String message = (String) request.getAttribute("message");

    if (columns == null) {
        columns = new Vector<>();
    }
    if (results == null) {
        results = new Vector<>();
    }
    if (message == null) {
        message = " ";
    }
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
            color: lightblue;
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
        
        .black-text {
            color: black;
        }

        .options {
            text-align: left;
            margin-top: 20px;
            font-size: 18px;
        }

        .option {
            list-style-type: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }

        .bullet {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            border: 2px solid white;
            margin-right: 10px;
            flex-shrink: 0;
        }

        .selected {
            background-color: green;
        }

        .executeButton {
            font-size: large;
            font-weight: bold;
            color: green;
            padding: 10px;
            cursor: pointer;
        }

        .clearButton {
            font-size: large;
            font-weight: bold;
            color: red;
            padding: 10px;
            cursor: pointer;
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
        You are connected to the Project 4 Enterprise System database as an <span id="clientLevel">accountant-level</span> user.
    </div>
    <div id="queryInstructions">
        Please select an option and click "Execute Command" to perform the operation.
    </div>
    <form action="/Project-4/accountant-rpc" method="post" onsubmit="executeCommand()">
        <input type="hidden" name="selectedOption" id="selectedOption" value="">
        
        <ul class="options">
            <li class="option" onclick="selectOption(1)">
                <div class="bullet" id="bullet1"></div>
                <span style="color: blue;">Get The Maximum Status Value of All Suppliers</span> (Returns a maximum value)
            </li>
            <li class="option" onclick="selectOption(2)">
                <div class="bullet" id="bullet2"></div>
                <span style="color: blue;">Get The total Weight of All Parts</span> (Returns a sum)
            </li>
            <li class="option" onclick="selectOption(3)">
                <div class="bullet" id="bullet3"></div>
                <span style="color: blue;">Get The Total Number of Shipments</span> (Returns the current number of shipments in total)
            </li>
            <li class="option" onclick="selectOption(4)">
                <div class="bullet" id="bullet4"></div>
                <span style="color: blue;">Get The Name And Number of Workers Of The Job With The Most Workers</span> (Returns two values)
            </li>
            <li class="option" onclick="selectOption(5)">
                <div class="bullet" id="bullet5"></div>
                <span style="color: blue;">List The Name And Status Of Every Supplier</span> (Returns a list of supplier names with status)
            </li>
        </ul>
        <input class="executeButton" type="submit" value="Execute Command"/>
        <input class="clearButton" type="button" value="Clear Results" onclick="javascript:eraseText();"/>
    </form>
    <div id="resultsMargin">
        All execution results will appear below this line.
    </div>
    <div id="divider"></div>
    <div id="resultsMargin">
        Execution Results:
    </div>
    <table id="data">
            <% 
                columns = (Vector<String>)request.getAttribute("columns");
                results = (Vector<Vector<String>>)request.getAttribute("results");

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
    <script>
        //JavaScript functions that are used to handle option selection and button clicks.
        function selectOption(optionNumber) {
            for (let i = 1; i <= 5; i++) {
                document.getElementById('bullet' + i).classList.remove('selected');
            }
            document.getElementById('bullet' + optionNumber).classList.add('selected');
        }

        function executeCommand() {
            //Logic to execute the selected command.
            let selectedOption = null;
            for (let i = 1; i <= 5; i++) {
                if (document.getElementById('bullet' + i).classList.contains('selected')) {
                    selectedOption = i;
                    break;
                }
            }

            // Set the value of the hidden input
            document.getElementById('selectedOption').value = selectedOption;
        }
        function eraseText() {
            document.getElementById('data').innerHTML = "";
        }
    </script>
</body>
</html>