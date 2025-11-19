package com.bookstore.dao;
import com.bookstore.model.User; import java.sql.*;
public class UserDAO {
    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) { return new User(rs.getInt("id"), rs.getString("username"), rs.getString("password"), rs.getInt("is_admin") == 1); }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
    public boolean addUser(User user) {
        String sql = "INSERT INTO users (username, password, is_admin) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername()); stmt.setString(2, user.getPassword()); stmt.setInt(3, user.isAdmin() ? 1 : 0);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
