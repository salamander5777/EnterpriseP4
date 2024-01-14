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

public class ClientUserServlet extends HttpServlet {
    private static Connection connection;
    private static Vector<String> columns;

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            getDBConnection();
            String query = request.getParameter("sqlStatement"); //Reading in the query from the user input box.
            Vector<String> columns;
            Vector<Vector<String>> results;

            if (query != null && !query.isEmpty()) {
                //Executing select command to SQL database.
                if (query.trim().toLowerCase().startsWith("select")) {
                    results = ClientUserServlet.runQuery(query);
                    columns = ClientUserServlet.getColumns();
                    request.setAttribute("columns", columns);
                    request.setAttribute("results", results);
                } else {
                    //This is entered if the initial statement is anything other than select. It will run an update and output how many rows have been affected.
                    int rowsUpdated = ClientUserServlet.runUpdate(query);
                    request.setAttribute("message", "Successful Update... " + rowsUpdated + " rows updated.");
                }
            }
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", ex.getMessage()); //Returning the error to be displayed at the bottom of the page.
        } finally {
            //Closing resources as needed.
            closeResources();
        }

        //Forwarding to the JSP page.
        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/clientHome.jsp");
        dispatcher.forward(request, response);
    }

    //The function below creates a connection to a designated database by reading in the client1 properties file.
    public void getDBConnection() throws IOException, SQLException {
        InputStream fileIn = getServletContext().getResourceAsStream("/WEB-INF/lib/client1.properties");
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
            //e.printStackTrace(); //Commenting out log to remove warning.
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

    //Executing non-select commands to the SQL database.
    public static int runUpdate(String query) throws SQLException {
        try (Statement statement = connection.createStatement()) {
            return statement.executeUpdate(query);
        }
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