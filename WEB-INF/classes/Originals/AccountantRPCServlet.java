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

public class AccountantRPCServlet extends HttpServlet {
    private static Connection connection;
    private static Vector<String> columns;

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String parameterValue = request.getParameter("selectedOption");
        String message = "";
        Vector<Vector<String>> results = new Vector<>();
        int cmdValue = 0;

        if (parameterValue != null && !parameterValue.isEmpty()) {
            try {
                cmdValue = Integer.parseInt(parameterValue);
            } catch (NumberFormatException e) {
                //e.printStackTrace(); //Ignoring the need for debugging.
            }
        }

        try {
            getDBConnection();
            columns = AccountantRPCServlet.getColumns();

            //Switch case determined by which choice was made on the corresponding jsp.
            switch (cmdValue) {
                case 1:
                    results = runQuery("SELECT MAX(status) AS max_status FROM suppliers;");
                    break;
                case 2:
                    results = runQuery("SELECT SUM(weight) AS total_weight FROM parts;");
                    break;
                case 3:
                    results = runQuery("SELECT COUNT(*) AS total_shipments FROM shipments;");
                    break;
                case 4:
                    results = runQuery("SELECT jname, numworkers FROM jobs ORDER BY numworkers DESC LIMIT 1;");
                    break;
                case 5:
                    results = runQuery("SELECT sname, status FROM suppliers;");
                    break;
                default:
                    message = "Invalid RPC choice!";
            }
        //Unlikely to occur, but included just in case.
        } catch (SQLException e) {
            message = "Error executing the SQL statement: " + e.getMessage();
        } finally {
            //Closing resources as needed.
            closeResources();
        }

        request.setAttribute("message", message);
        request.setAttribute("columns", columns);
        request.setAttribute("results", results);

        //Forwarding to the JSP page.
        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/accountantHome.jsp");
        dispatcher.forward(request, response);
    }

    //The function below creates a connection to a designated database by reading in the accountant properties file.
    public void getDBConnection() throws IOException, SQLException {
        InputStream fileIn = getServletContext().getResourceAsStream("/WEB-INF/lib/accountant.properties");
        Properties properties = new Properties();
        properties.load(fileIn);

        MysqlDataSource dataSource = new MysqlDataSource();
        dataSource.setURL(properties.getProperty("MYSQL_DB_URL"));
        dataSource.setUser(properties.getProperty("MYSQL_DB_USERNAME"));
        dataSource.setPassword(properties.getProperty("MYSQL_DB_PASSWORD"));

        connection = dataSource.getConnection();
    }

    //Closing the connection to the database, as to not waste resources.
    private void closeResources() {
        try {
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {
            // Ignoring the need for error logging.
        }
    }

    //The function below gets the information needed for the display.
    public static Vector<Vector<String>> runQuery(String query) throws SQLException {
        Vector<Vector<String>> results = new Vector<>();

        try (Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery(query)) {
            ResultSetMetaData metaData = resultSet.getMetaData();

            int numColumns = metaData.getColumnCount();
            setColumns(numColumns, metaData);

            while (resultSet.next()) {
                Vector<String> row = new Vector<>();
                for (int i = 1; i <= numColumns; i++) {
                    row.add(resultSet.getString(i));
                }
                results.add(row);
            }
        }
        return results;
    }

    //Grabbing the column information from the table in the database.
    public static Vector<String> getColumns() throws SQLException {
        return columns;
    }

    //Populating the columns instance with the names of the columns from the current table.
    public static void setColumns(int numColumns, ResultSetMetaData metaData) throws SQLException {
        columns = new Vector<>();
        for (int i = 1; i <= numColumns; i++) {
            columns.add(metaData.getColumnName(i));
        }
    }
}