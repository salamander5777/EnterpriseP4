/*  Name: Michael Gilday
    Course: CNT 4714 – Fall 2023 – Project Four
    Assignment title: A Three-Tier Distributed Web-Based Application
    Date: December 5, 2023
*/

import java.io.*;
import java.util.Properties;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class AuthentificationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //Grabbing user input data from the website.
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username != null && !username.isEmpty() && password != null && !password.isEmpty()) {
            String propertiesFilePath = "/WEB-INF/lib/" + username + ".properties";

            //Loading the properties file corresponding to the username input by the user.
            try (InputStream fileIn = getServletContext().getResourceAsStream(propertiesFilePath)) {
                Properties properties = new Properties();
                if (fileIn != null) {
                    properties.load(fileIn);

                    //Checking if the username and password match the properties file.
                    if (username.equals(properties.getProperty("MYSQL_DB_USERNAME"))
                            && password.equals(properties.getProperty("MYSQL_DB_PASSWORD"))) {
                        //Redirect based on user type.
                        String userType = getUserType(username);
                        redirectUser(userType, request, response);
                        return;
                    }
                }
            } catch (IOException e) {
                //e.printStackTrace(); //Commenting out log to remove warning.
            }
        }

        //If there's no match to a user in the properties files then they are redirected to errorpage.html.
        response.sendRedirect("errorpage.html");
    }

    //Using switch cases since client usernames can vary. Update as necessary for more users.
    private String getUserType(String username) {
        return switch (username) {
            case "root" -> "root";
            case "dataentryuser" -> "dataentryuser";
            case "accountant" -> "accountant";
            default -> "client";
        };
    }

    //Redirecting the user to varying resources provided in the web.xml file.
    private void redirectUser(String userType, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        switch (userType) {
            case "root":
                response.sendRedirect("rootHome.jsp");
                break;
            case "dataentryuser":
                response.sendRedirect("AddShipmentRecord.jsp");
                break;
            case "accountant":
                response.sendRedirect("accountantHome.jsp");
                break;
            case "client":
                response.sendRedirect("clientHome.jsp");
                break;
            default:
                response.sendRedirect("errorpage.html");
                break;
        }
    }
}