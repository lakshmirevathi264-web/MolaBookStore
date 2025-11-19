package com.bookstore.tools;

import com.bookstore.dao.DatabaseConnector;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PasswordMigrator {
    public static void main(String[] args) {
        System.out.println("Starting password migration...");
        try (Connection conn = DatabaseConnector.getConnection()) {
            String q = "SELECT id, password FROM users";
            try (PreparedStatement ps = conn.prepareStatement(q);
                 ResultSet rs = ps.executeQuery()) {
                List<Integer> updated = new ArrayList<>();
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String pw = rs.getString("password");
                    if (pw == null) continue;
                    if (pw.startsWith("$2a$") || pw.startsWith("$2y$") || pw.startsWith("$2b$")) continue;
                    String hashed = BCrypt.hashpw(pw, BCrypt.gensalt(12));
                    try (PreparedStatement up = conn.prepareStatement("UPDATE users SET password = ? WHERE id = ?")) {
                        up.setString(1, hashed);
                        up.setInt(2, id);
                        up.executeUpdate();
                        updated.add(id);
                    }
                }
                System.out.println("Migration complete. Updated users: " + updated);
            }
        } catch (Exception e) {
            System.err.println("Migration failed: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}
