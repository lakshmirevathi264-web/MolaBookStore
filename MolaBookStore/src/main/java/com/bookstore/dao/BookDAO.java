package com.bookstore.dao;
import com.bookstore.model.Book; import java.sql.*; import java.util.ArrayList; import java.util.List;
public class BookDAO {
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books";
        try (Connection conn = DatabaseConnector.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) { books.add(new Book(rs.getInt("id"), rs.getString("title"), rs.getString("author"), rs.getDouble("price"), rs.getInt("quantity"))); }
        } catch (SQLException e) { e.printStackTrace(); }
        return books;
    }
    public Book getBookById(int id) {
        String sql = "SELECT * FROM books WHERE id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) { return new Book(rs.getInt("id"), rs.getString("title"), rs.getString("author"), rs.getDouble("price"), rs.getInt("quantity")); }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
    public boolean addBook(Book book) {
        String sql = "INSERT INTO books (title, author, price, quantity) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, book.getTitle()); stmt.setString(2, book.getAuthor()); stmt.setDouble(3, book.getPrice()); stmt.setInt(4, book.getQuantity());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
    public boolean deleteBook(int id) {
        String sql = "DELETE FROM books WHERE id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
    public boolean updateBookQuantity(int bookId, int newQuantity) {
        String sql = "UPDATE books SET quantity = ? WHERE id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, newQuantity); stmt.setInt(2, bookId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
