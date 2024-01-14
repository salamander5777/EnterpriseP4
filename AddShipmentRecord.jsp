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
    <title>Welcome to the Fall 2023 Project 4 Enterprise System - Data Entry Application</title>
    <style type="text/css">
        body {
            background-color: black;
            text-align: center;
            font-family: Calibri, Arial, sans-serif;
            color: white;
        }

        .section {
            background-color: grey;
            padding: 20px;
            margin: 20px;
            text-align: left;
            border-radius: 10px;
        }

        #welcomeHeader {
            font-size: xx-large;
            font-weight: bold;
            color: red;
            margin-top: 20px;
        }

        #appDescription {
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

        #dataEntryInstructions {
            margin-top: 20px;
        }

        .formBox {
            background-color: black;
            padding: 20px;
            border-radius: 10px;
        }

        .formLabel {
            color: white;
            margin-bottom: 10px;
            font-weight: bold;
        }

        .formEntry {
            background-color: bisque;
            color: green;
            padding: 10px;
            margin-bottom: 10px;
            border: none;
            border-radius: 5px;
        }

        .clearButton {
            background-color: bisque;
            color: red;
            padding: 10px;
            border: none;
            cursor: pointer;
            margin-right: 10px;
            border-radius: 5px;
        }

        .enterButton {
            background-color: bisque;
            color: green;
            padding: 10px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }

        #resultsMargin {
            margin-top: 20px;
        }
        
        .messageBox {
            background-color: blue;
            color: white;
            padding: 10px;
            border-radius: 5px;
            margin-top: 20px;
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
    <div id="appDescription">
        Data Entry Application
    </div>
    <div id="divider"></div>
    <div id="databaseInfo">
        You are connected to the Project 4 Enterprise System database as a <span style="color: red;">data-entry-level</span> user.
    </div>
    <div id="dataEntryInstructions">
        Enter the data values in a form below to add a new record to the corresponding database table.
    </div>
    <div id="divider"></div>

    <!-- First Section: Suppliers Record Insert -->
    <div class="section">
        <div class="formBox">
            <div class="formLabel">
                Suppliers Record Insert
            </div>
            <form action="/Project-4/add-supplier-record" method="post">
                <fieldset>
                <table>
                    <tr>
                        <th>snum</th><th>sname</th><th>status</th><th>city</th>
                    </tr>
                    <tr id="cmd">
                        <td><textarea class="cmd" name="snumSu"><%= (request.getAttribute("snumSu") != null) ? request.getAttribute("snumSu") : "" %></textarea></td>
                        <td><textarea class="cmd" name="snameSu"><%= (request.getAttribute("snameSu") != null) ? request.getAttribute("snameSu") : "" %></textarea></td>
                        <td><textarea class="cmd" name="statusSu"><%= (request.getAttribute("statusSu") != null) ? request.getAttribute("statusSu") : "" %></textarea></td>
                        <td><textarea class="cmd" name="citySu"><%= (request.getAttribute("citySu") != null) ? request.getAttribute("citySu") : "" %></textarea></td>
                    </tr>
                </table>
                <input class="enterButton" type="submit" value="Enter Supplier Record Into Database" name="suppliersform"/> &nbsp; &nbsp; &nbsp;
                <input class="clearButton" type="reset" value="Clear Data and Results" onclick="javascript:eraseData('snumSu', 'snameSu', 'statusSu', 'citySu');"/> &nbsp; &nbsp; &nbsp;
                </fieldset>
            </form>
        </div>
    </div>

    <!-- Second Section: Parts Record Insert -->
    <div class="section">
        <div class="formBox">
            <div class="formLabel">
                Parts Record Insert
            </div>
            <form action="/Project-4/add-part-record" method="post">
                <fieldset>
                <table>
                    <tr>
                        <th>pnum</th><th>pname</th><th>color</th><th>weight</th><th>city</th>
                    </tr>
                    <tr id="cmd">
                        <td><textarea class="cmd" name="pnumPa"><%= (request.getAttribute("pnumPa") != null) ? request.getAttribute("pnumPa") : "" %></textarea></td>
                        <td><textarea class="cmd" name="pnamePa"><%= (request.getAttribute("pnamePa") != null) ? request.getAttribute("pnamePa") : "" %></textarea></td>
                        <td><textarea class="cmd" name="colorPa"><%= (request.getAttribute("colorPa") != null) ? request.getAttribute("colorPa") : "" %></textarea></td>
                        <td><textarea class="cmd" name="weightPa"><%= (request.getAttribute("weightPa") != null) ? request.getAttribute("weightPa") : "" %></textarea></td>
                        <td><textarea class="cmd" name="cityPa"><%= (request.getAttribute("cityPa") != null) ? request.getAttribute("cityPa") : "" %></textarea></td>
                    </tr>
                </table>
                <input class="enterButton" type="submit" value="Enter Part Record Into Database" name="partsform"/> &nbsp; &nbsp; &nbsp;
                <input class="clearButton" type="reset" value="Clear Data and Results" onclick="javascript:eraseData('pnumPa', 'pnamePa', 'colorPa', 'weightPa', 'cityPa');"/> &nbsp; &nbsp; &nbsp;
                </fieldset>
            </form>
        </div>
    </div>

    <!-- Third Section: Jobs Record Insert -->
    <div class="section">
        <div class="formBox">
            <div class="formLabel">
                Jobs Record Insert
            </div>
            <form action="/Project-4/add-job-record" method="post">
                <fieldset>
                <table>
                    <tr>
                        <th>jnum</th><th>jname</th><th>numworkers</th><th>city</th>
                    </tr>
                    <tr id="cmd">
                        <td><textarea class="cmd" name="jnumJo"><%= (request.getAttribute("jnumJo") != null) ? request.getAttribute("jnumJo") : "" %></textarea></td>
                        <td><textarea class="cmd" name="jnameJo"><%= (request.getAttribute("jnameJo") != null) ? request.getAttribute("jnameJo") : "" %></textarea></td>
                        <td><textarea class="cmd" name="numworkersJo"><%= (request.getAttribute("numworkersJo") != null) ? request.getAttribute("numworkersJo") : "" %></textarea></td>
                        <td><textarea class="cmd" name="cityJo"><%= (request.getAttribute("cityJo") != null) ? request.getAttribute("cityJo") : "" %></textarea></td>
                    </tr>
                </table>
                <input class="enterButton" type="submit" value="Enter Job Record Into Database" name="jobsform"/> &nbsp; &nbsp; &nbsp;
                <input class="clearButton" type="reset" value="Clear Data and Results" onclick="javascript:eraseData('jnumJo', 'jnameJo', 'numworkersJo', 'cityJo');"/> &nbsp; &nbsp; &nbsp;
                </fieldset>
            </form>
        </div>
    </div>

    <!-- Fourth Section: Shipments Record Insert -->
    <div class="section">
        <div class="formBox">
            <div class="formLabel">
                Shipments Record Insert
            </div>
            <form action="/Project-4/add-shipment-record" method="post">
                <fieldset>
                <table>
                    <tr>
                        <th>snum</th><th>pnum</th><th>jnum</th><th>quantity</th>
                    </tr>
                    <tr id="cmd">
                        <td><textarea class="cmd" name="snumSh"><%= (request.getAttribute("snumSh") != null) ? request.getAttribute("snumSh") : "" %></textarea></td>
                        <td><textarea class="cmd" name="pnumSh"><%= (request.getAttribute("pnumSh") != null) ? request.getAttribute("pnumSh") : "" %></textarea></td>
                        <td><textarea class="cmd" name="jnumSh"><%= (request.getAttribute("jnumSh") != null) ? request.getAttribute("jnumSh") : "" %></textarea></td>
                        <td><textarea class="cmd" name="quantitySh"><%= (request.getAttribute("quantitySh") != null) ? request.getAttribute("quantitySh") : "" %></textarea></td>
                    </tr>
                </table>
                <input class="enterButton" type="submit" value="Enter Shipment Record Into Database" name="shipmentsrecordsform"/> &nbsp; &nbsp; &nbsp;
                <input class="clearButton" type="reset" value="Clear Data and Results" onclick="javascript:eraseData('snumSh', 'pnumSh', 'jnumSh', 'quantitySh');"/> &nbsp; &nbsp; &nbsp;
                </fieldset>
            </form>
        </div>
    </div>

    <div id="resultsMargin">
        Execution Results:
    </div>
    <div id="divider"></div>
    <% if (request.getAttribute("errorMessage") != null) { %>
        <table id="data">
            <tr>
                <td class="error-box">
                    <p>Error Executing the SQL Statement:</p>
                    <p><%= request.getAttribute("errorMessage") %></p>
                </td>
            </tr>
        </table>
    <% } else { %> 
        <table id="data">
            <tr>
                <td class="messageBox"><%= message %></td>
            </tr>
        </table>
    <% } %>
    <script>
        function eraseData(...textareaIds) {
            textareaIds.forEach(id => {
                document.getElementsByName(id)[0].value = '';
            });
            var table = document.getElementById("data");
            table.innerHTML = "";
        }
    </script>
</body>
</html>