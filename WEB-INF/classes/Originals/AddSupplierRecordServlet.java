/*  Name: Michael Gilday
    Course: CNT 4714 – Fall 2023 – Project Four
    Assignment title: A Three-Tier Distributed Web-Based Application
    Date: December 5, 2023
*/

import com.mysql.cj.jdbc.MysqlDataSource;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.Properties;
import java.util.Vector;

public class AddSupplierRecordServlet extends HttpServlet {

    private static Connection connection;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String message;
        Vector<Vector<String>> results = new Vector<>();

        //Retrieving data from the form.
        String snum = request.getParameter("snumSu");
        String sname = request.getParameter("snameSu");
        String status = request.getParameter("statusSu");
        String city = request.getParameter("citySu");

        try {
            getDBConnection();

            //Using a prepared statement to avoid SQL injection.
            String query = "INSERT INTO suppliers (snum, sname, status, city) VALUES (?, ?, ?, ?)";
            try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                preparedStatement.setString(1, snum);
                preparedStatement.setString(2, sname);
                preparedStatement.setString(3, status);
                preparedStatement.setString(4, city);

                preparedStatement.executeUpdate();
            }

            //Clearing the form fields after successful submission.
            request.setAttribute("snumSu", "");
            request.setAttribute("snameSu", "");
            request.setAttribute("statusSu", "");
            request.setAttribute("citySu", "");

            message = "New suppliers record: (" + snum + ", " + sname + ", " + status + ", " + city + ") - successfully entered into the database.";

        } catch (SQLException e) {
            message = "";
            request.setAttribute("errorMessage", e.getMessage());
        }

        //Setting the attributes for the JSP.
        request.setAttribute("message", message);
        request.setAttribute("results", results);

        //Forwarding to the JSP page.
        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/AddShipmentRecord.jsp");
        dispatcher.forward(request, response);
    }

    //The function below creates a connection to a designated database by reading in the dataentryuser properties file.
    public void getDBConnection() throws IOException, SQLException {
        InputStream fileIn = getServletContext().getResourceAsStream("/WEB-INF/lib/dataentryuser.properties");
        Properties properties = new Properties();
        properties.load(fileIn);

        MysqlDataSource dataSource = new MysqlDataSource();
        dataSource.setURL(properties.getProperty("MYSQL_DB_URL"));
        dataSource.setUser(properties.getProperty("MYSQL_DB_USERNAME"));
        dataSource.setPassword(properties.getProperty("MYSQL_DB_PASSWORD"));

        connection = dataSource.getConnection();
    }
}