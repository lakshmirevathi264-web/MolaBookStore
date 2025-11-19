package com.bookstore.dao;

import java.sql.Connection;

public class DBConnectionTest {
    public static void main(String[] args) {
        try (Connection conn = DatabaseConnector.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("CONNECTED: " + conn.getMetaData().getURL());
            } else {
                System.err.println("FAILED: Connection is null or closed");
                System.exit(2);
            }
        } catch (Exception e) {
            System.err.println("EXCEPTION while connecting to DB:");
            e.printStackTrace();
            System.exit(1);
        }
        System.out.println("DB CONNECTION TEST: SUCCESS");
    }
}
