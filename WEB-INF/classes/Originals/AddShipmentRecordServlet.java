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

public class AddShipmentRecordServlet extends HttpServlet {

    private static Connection connection;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String message;
        Vector<Vector<String>> results = new Vector<>();

        //Retrieving data from the form.
        String snum = request.getParameter("snumSh");
        String pnum = request.getParameter("pnumSh");
        String jnum = request.getParameter("jnumSh");
        String quantity = request.getParameter("quantitySh");

        try {
            getDBConnection();

            //Using a prepared statement to avoid SQL injection.
            String query = "INSERT INTO shipments (snum, pnum, jnum, quantity) VALUES (?, ?, ?, ?)";
            try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                preparedStatement.setString(1, snum);
                preparedStatement.setString(2, pnum);
                preparedStatement.setString(3, jnum);
                preparedStatement.setString(4, quantity);

                preparedStatement.executeUpdate();
            }

            //Clearing the form fields after successful submission.
            request.setAttribute("snumSh", "");
            request.setAttribute("pnumSh", "");
            request.setAttribute("jnumSh", "");
            request.setAttribute("quantitySh", "");

            if(Integer.parseInt(quantity) > 100){
                updateSupplierStatus();
                message = "New shipments record: (" + snum + ", " + pnum + ", " + jnum + ", " + quantity +
                        ") - successfully entered into the database. Business logic triggered.";
            }else{
                message = "New shipments record: (" + snum + ", " + pnum + ", " + jnum + ", " + quantity +
                        ") - successfully entered into the database.";
            }
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

    //Updating supplier status based on business logic.
    private void updateSupplierStatus() throws SQLException {
        //Selecting distinct snum values greater than 99.
        String selectQuery = "SELECT DISTINCT snum FROM shipments WHERE quantity > 99";

        try (PreparedStatement selectStatement = connection.prepareStatement(selectQuery);
             ResultSet resultSet = selectStatement.executeQuery()) {
            while (resultSet.next()) {
                //Updating supplier status for each distinct snum.
                String updateQuery = "UPDATE suppliers SET status = status + 5 WHERE snum = ?";
                try (PreparedStatement updateStatement = connection.prepareStatement(updateQuery)) {
                    updateStatement.setString(1, resultSet.getString("snum"));
                }
            }
        }
    }
}