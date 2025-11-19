package com.bookstore.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.io.File;

public class DatabaseConnector {
    private static String buildJdbcUrl() {
        // First try Tomcat's catalina.base (typical production deployment)
        String catalinaBase = System.getProperty("catalina.base");
        if (catalinaBase != null && !catalinaBase.isEmpty()) {
            String path = catalinaBase + File.separator + "webapps" + File.separator + "MolaBookStore" + File.separator + "WEB-INF" + File.separator + "molabookstore.db";
            return "jdbc:sqlite:" + path;
        }
        // Fallback for local dev within the repository (use current working directory)
        String userDir = System.getProperty("user.dir");
        String devPath = userDir + File.separator + "WebContent" + File.separator + "WEB-INF" + File.separator + "molabookstore.db";
        return "jdbc:sqlite:" + devPath;
    }

    public static Connection getConnection() throws SQLException {
        String jdbcUrl = buildJdbcUrl();
        try {
            Class.forName("org.sqlite.JDBC");
        } catch (ClassNotFoundException e) {
            System.err.println("SQLite JDBC Driver not found.");
            e.printStackTrace();
        }
        return DriverManager.getConnection(jdbcUrl);
    }
}
