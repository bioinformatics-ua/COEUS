package pt.ua.bioinformatics.coeus.api;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import pt.ua.bioinformatics.coeus.common.Config;

/**
 * SQL database connection layer.
 * <p>Required for SQL-based data imports.<br />Based on JDBC4, supports any
 * kind of database (as long as respective connector is on /lib).</p>
 *
 * @author pedrolopes
 */
public class DB {

    private Connection connection;
    private Statement statement;
    private PreparedStatement pStatement;
    private String connectionString = "";
    private String database = "";
    private String build = "";

    // constructors
    public DB() {
    }

    /**
     * Constructor with custom database information.
     *
     * @param database The database name
     * @param connectionString The connection string (if distinct from WAVe)
     */
    public DB(String database, String connectionString) {
        this.database = database;
        this.connectionString = connectionString;
    }

    /**
     * Establishes a new connection to the database.
     * <p><b>Feature:</b><br />
     * Performs the required operations to establish a new database connection
     * </p>
     *
     * @return Success of the operation (true if connects, false if fails to
     * connect)
     */
    public boolean connect(String connectionString) {
        boolean success = false;
        try {
            connection = DriverManager.getConnection(connectionString);
            statement = connection.createStatement();
            success = true;
        } catch (SQLException ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][DB] Unable to connect to specific database");
            }
            Logger.getLogger(DB.class.getName()).log(Level.SEVERE, null, ex);

        }
        return success;
    }

    /**
     * Establishes a new connection to the database.
     * <p><b>Feature:</b><br />
     * Performs the required operations to establish a new database connection
     * to non-default database
     * </p>
     *
     * @return Success of the operation (true if connects, false if fails to
     * connect)
     */
    public boolean connectX() {
        boolean success = false;
        try {
            connection = DriverManager.getConnection(connectionString);
            statement = connection.createStatement();
            success = true;
        } catch (SQLException e) {
            System.out.println("[DB] Unable to connect to " + database + "\n\t" + e.toString());
            success = false;
        } finally {
            // System.out.println("[DB] Connected to " + database);
            return success;
        }
    }

    /**
     * Closes current database connection.
     * <p><b>Feature:</b><br />
     * Performs the required operations to close an open database connection
     * </p>
     *
     * @return Success of the operation (true if it closes the connection, false
     * if it fails to close the connection)
     */
    public boolean close() {
        try {
            if (!statement.isClosed()) {
                statement.close();
            }
            if (!pStatement.isClosed()) {
                pStatement.close();
            }
            if (!connection.isClosed()) {
                connection.close();
            }

        } catch (SQLException e) {
            System.out.println("[DB] Unable to close " + database + " connection\n\t" + e.toString());
            return false;
        } finally {
            // System.out.println("[DB] Closed " + database + " connection");
            return true;
        }

    }

    /**
     * Inserts data in the instanced database based on the passed query.
     * <p><b>Feature:</b><br/>
     * Executes required tests and operations to insert novel data in the
     * database
     * </p>
     *
     * @param what String to describe what is being inserted in the database
     * @param query The insertion query
     * @return Success of the operation (true if inserts correctly, false if
     * fails to insert)
     */
    public boolean insert(String what, String query) {
        query = query.replace("#build#", build);

        try {
            if (!connection.isClosed()) {
                pStatement=connection.prepareStatement(query);
                pStatement.executeUpdate();
            }

        } catch (SQLException e) {
            System.out.println("[DB] Unable to insert " + what + "\n\t" + e.toString());
            return false;
        } finally {
            // System.out.println("[DB] Inserted " + query);
            return true;
        }
    }

    /**
     * Updates data in the instanced database based on the passed query.
     * <p><b>Feature:</b><br/>
     * Executes required tests and operations to update existing data in the
     * database
     * </p>
     *
     * @param what String to describe what is being updated in the database
     * @param query The update query
     * @return Success of the operation (true if updates correctly, false if
     * fails to update)
     */
    public boolean update(String what, String query) {
        query = query.replace("#build#", build);
        try {
            if (!connection.isClosed()) {
                pStatement=connection.prepareStatement(query);
                pStatement.executeUpdate();
            }

        } catch (SQLException e) {
            System.out.println("[DB] Unable to update " + what + "\n\t" + e.toString());
            return false;
        } finally {
            System.out.println("[DB] updated " + what);
            return true;
        }
    }

    /**
     * Updates data in the instanced database based on the passed query.
     * <p><b>Feature:</b><br/>
     * Executes required tests and operations to update existing data in the
     * database
     * </p>
     *
     * @param what String to describe what is being updated in the database
     * @param query The update query
     * @return Success of the operation (true if updates correctly, false if
     * fails to update)
     */
    public boolean delete(String what, String query) {
        query = query.replace("#build#", build);
        try {
            if (!connection.isClosed()) {
                pStatement=connection.prepareStatement(query);
                pStatement.executeUpdate();
            }

        } catch (SQLException e) {
            System.out.println("[DB] Unable to delete " + what + "\n\t" + e.toString());
            return false;
        } finally {
            // System.out.println("[DB] updated " + what);
            return true;
        }
    }

    /**
     * Retrieves data from the instance database.
     * <p><b>Feature:</b><br/>
     * Retrieves a Result Set table containing the results from the provided
     * <code>SELECT</code> statement
     *
     * @param query <code>SELECT</code> query to get the desired data
     * @return Result Set containing the output of the
     * executed <code>SELECT</code> statement
     */
    public ResultSet getData(String query) {
        query = query.replace("#build#", build);

        ResultSet rs = null;

        try {
            if (!connection.isClosed()) {
                pStatement=connection.prepareStatement(query);
                rs = pStatement.executeQuery();
            }
        } catch (SQLException e) {
            System.out.println("[DB] Unable to retrieve data\n\t" + e.toString());
            return rs;
        } finally {
            //  System.out.println("[DB] Retrieved data");
            return rs;
        }

    }
}
