#!/bin/bash
# STEP 1: Initialization, Structure, and Downloads

echo "--- Starting MolaBookStore Setup: Step 1/6 ---"

# 1. Install Dependencies
echo "1. Installing Java JDK, Tomcat, and SQLite..."
sudo apt update
sudo apt install -y openjdk-17-jdk tomcat9 sqlite3 wget

# Define paths
PROJECT_ROOT="MolaBookStore"
SRC_JAVA="$PROJECT_ROOT/src/main/java/com/bookstore"
WEB_INF="$PROJECT_ROOT/WebContent/WEB-INF"
TARGET_CLASSES="$PROJECT_ROOT/target/classes"
LIB_DIR="$PROJECT_ROOT/WebContent/WEB-INF/lib"

# 2. Create Directory Structure
echo "2. Creating project directory structure..."
mkdir -p "$SRC_JAVA/model" "$SRC_JAVA/dao" "$SRC_JAVA/servlets"
mkdir -p "$PROJECT_ROOT/WebContent/assets/css" "$PROJECT_ROOT/WebContent/assets/js"
mkdir -p "$TARGET_CLASSES" "$LIB_DIR"
mkdir -p "$PROJECT_ROOT/WebContent"

# 3. Download JDBC and Servlet API JARs
echo "3. Downloading required JARs (SQLite JDBC and Servlet API)..."
wget -q "https://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.44.1.0/sqlite-jdbc-3.44.1.0.jar" -O "$LIB_DIR/sqlite-jdbc.jar"
wget -q "https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar" -O "$LIB_DIR/servlet-api-4.0.1.jar"

# Set CLASSPATH for compilation
export CLASSPATH="$CLASSPATH:$LIB_DIR/sqlite-jdbc.jar:$LIB_DIR/servlet-api-4.0.1.jar"

echo "--- Step 1 Complete ---"

#!/bin/bash
# STEP 2: Database and web.xml Configuration

PROJECT_ROOT="MolaBookStore"
WEB_INF="$PROJECT_ROOT/WebContent/WEB-INF"
DB_FILE="$PROJECT_ROOT/molabookstore.db"
CATALINA_HOME=/usr/share/tomcat9

echo "--- Starting MolaBookStore Setup: Step 2/6 ---"

# 1. Database Seed Script
echo "1. Creating and seeding SQLite database..."
cat > "$DB_FILE.sql" << EOF
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    is_admin INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE IF NOT EXISTS books (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    price REAL NOT NULL,
    quantity INTEGER NOT NULL
);
INSERT INTO users (username, password, is_admin) VALUES ('admin', 'adminpass', 1);
INSERT INTO users (username, password, is_admin) VALUES ('user', 'userpass', 0);
INSERT INTO books (title, author, price, quantity) VALUES ('The Great Gatsby', 'F. Scott Fitzgerald', 10.99, 50);
INSERT INTO books (title, author, price, quantity) VALUES ('1984', 'George Orwell', 12.50, 30);
INSERT INTO books (title, author, price, quantity) VALUES ('To Kill a Mockingbird', 'Harper Lee', 8.75, 45);
EOF
sqlite3 "$DB_FILE" < "$DB_FILE.sql"
rm "$DB_FILE.sql" # Clean up seed file

# 2. Create web.xml
echo "2. Creating web.xml with all 9 servlet mappings..."
cat > "$WEB_INF/web.xml" << EOF
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
         http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">
    <display-name>MolaBookStore</display-name>
    <servlet><servlet-name>LoginServlet</servlet-name><servlet-class>com.bookstore.servlets.LoginServlet</servlet-class></servlet>
    <servlet-mapping><servlet-name>LoginServlet</servlet-name><url-pattern>/login</url-pattern></servlet-mapping>
    <servlet><servlet-name>SignupServlet</servlet-name><servlet-class>com.bookstore.servlets.SignupServlet</servlet-class></servlet>
    <servlet-mapping><servlet-name>SignupServlet</servlet-name><url-pattern>/signup</url-pattern></servlet-mapping>
    <servlet><servlet-name>BookCatalogServlet</servlet-name><servlet-class>com.bookstore.servlets.BookCatalogServlet</servlet-class></servlet>
    <servlet-mapping><servlet-name>BookCatalogServlet</servlet-name><url-pattern>/catalog</url-pattern></servlet-mapping>
    <servlet><servlet-name>AddBookServlet</servlet-name><servlet-class>com.bookstore.servlets.AddBookServlet</servlet-class></servlet>
    <servlet-mapping><servlet-name>AddBookServlet</servlet-name><url-pattern>/admin/addBook</url-pattern></servlet-mapping>
    <servlet><servlet-name>DeleteBookServlet</servlet-name><servlet-class>com.bookstore.servlets.DeleteBookServlet</servlet-class></servlet>
    <servlet-mapping><servlet-name>DeleteBookServlet</servlet-name><url-pattern>/admin/deleteBook</url-pattern></servlet-mapping>
    <servlet><servlet-name>AddToCartServlet</servlet-name><servlet-class>com.bookstore.servlets.AddToCartServlet</servlet-class></servlet>
    <servlet-mapping><servlet-name>AddToCartServlet</servlet-name><url-pattern>/addToCart</url-pattern></servlet-mapping>
    <servlet><servlet-name>ViewCartServlet</servlet-name><servlet-class>com.bookstore.servlets.ViewCartServlet</servlet-class></servlet>
    <servlet-mapping><servlet-name>ViewCartServlet</servlet-name><url-pattern>/cart</url-pattern></servlet-mapping>
    <servlet><servlet-name>PaymentServlet</servlet-name><servlet-class>com.bookstore.servlets.PaymentServlet</servlet-class></servlet>
    <servlet-mapping><servlet-name>PaymentServlet</servlet-name><url-pattern>/payment</url-pattern></servlet-mapping>
    <servlet><servlet-name>LogoutServlet</servlet-name><servlet-class>com.bookstore.servlets.LogoutServlet</servlet-class></servlet>
    <servlet-mapping><servlet-name>LogoutServlet</servlet-name><url-pattern>/logout</url-pattern></servlet-mapping>
    <welcome-file-list><welcome-file>login.jsp</welcome-file></welcome-file-list>
</web-app>
EOF

echo "--- Step 2 Complete ---"

#!/bin/bash
# STEP 3: Java Models and DAOs

SRC_JAVA="MolaBookStore/src/main/java/com/bookstore"

echo "--- Starting MolaBookStore Setup: Step 3/6 (Models and DAOs) ---"

# 1. Models
echo "1. Writing Model classes..."
cat > "$SRC_JAVA/model/User.java" << EOF
package com.bookstore.model;
public class User {
    private int id; private String username; private String password; private boolean isAdmin;
    public User() {}
    public User(int id, String username, String password, boolean isAdmin) {
        this.id = id; this.username = username; this.password = password; this.isAdmin = isAdmin;
    }
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public boolean isAdmin() { return isAdmin; }
    public void setAdmin(boolean admin) { isAdmin = admin; }
}
EOF

cat > "$SRC_JAVA/model/Book.java" << EOF
package com.bookstore.model;
public class Book {
    private int id; private String title; private String author; private double price; private int quantity;
    public Book() {}
    public Book(int id, String title, String author, double price, int quantity) {
        this.id = id; this.title = title; this.author = author; this.price = price; this.quantity = quantity;
    }
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
EOF

# 2. DAOs
echo "2. Writing DAO classes..."
cat > "$SRC_JAVA/dao/DatabaseConnector.java" << EOF
package com.bookstore.dao;
import java.sql.Connection; import java.sql.DriverManager; import java.sql.SQLException;
public class DatabaseConnector {
    private static final String JDBC_URL = "jdbc:sqlite:/usr/share/tomcat9/webapps/MolaBookStore/WEB-INF/molabookstore.db";
    public static Connection getConnection() throws SQLException {
        try { Class.forName("org.sqlite.JDBC"); } catch (ClassNotFoundException e) { System.err.println("SQLite JDBC Driver not found."); e.printStackTrace(); }
        return DriverManager.getConnection(JDBC_URL);
    }
}
EOF

cat > "$SRC_JAVA/dao/UserDAO.java" << EOF
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
EOF

cat > "$SRC_JAVA/dao/BookDAO.java" << EOF
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
EOF

echo "--- Step 3 Complete ---"

#!/bin/bash
# STEP 4: Java Servlets (Authentication & Catalog)

SRC_SERVLETS="MolaBookStore/src/main/java/com/bookstore/servlets"

echo "--- Starting MolaBookStore Setup: Step 4/6 (Servlets 1-5) ---"

# LoginServlet
cat > "$SRC_SERVLETS/LoginServlet.java" << EOF
package com.bookstore.servlets;
import com.bookstore.dao.UserDAO; import com.bookstore.model.User; import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet; import javax.servlet.http.HttpServletRequest; import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; import java.io.IOException;
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username"); String password = request.getParameter("password");
        User user = userDAO.getUserByUsername(username);
        if (user != null && user.getPassword().equals(password)) {
            HttpSession session = request.getSession(); session.setAttribute("currentUser", user);
            response.sendRedirect(request.getContextPath() + "/catalog" + (user.isAdmin() ? "?admin=true" : ""));
        } else {
            request.setAttribute("errorMessage", "Invalid username or password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
EOF

# SignupServlet
cat > "$SRC_SERVLETS/SignupServlet.java" << EOF
package com.bookstore.servlets;
import com.bookstore.dao.UserDAO; import com.bookstore.model.User; import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet; import javax.servlet.http.HttpServletRequest; import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
public class SignupServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username"); String password = request.getParameter("password");
        if (userDAO.getUserByUsername(username) != null) { request.setAttribute("errorMessage", "Username already exists."); request.getRequestDispatcher("/signup.jsp").forward(request, response); return; }
        User newUser = new User(); newUser.setUsername(username); newUser.setPassword(password); newUser.setAdmin(false);
        if (userDAO.addUser(newUser)) { response.sendRedirect("login.jsp?signup=success"); }
        else { request.setAttribute("errorMessage", "Registration failed. Try again."); request.getRequestDispatcher("/signup.jsp").forward(request, response); }
    }
}
EOF

# BookCatalogServlet
cat > "$SRC_SERVLETS/BookCatalogServlet.java" << EOF
package com.bookstore.servlets;
import com.bookstore.dao.BookDAO; import com.bookstore.model.Book; import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet; import javax.servlet.http.HttpServletRequest; import javax.servlet.http.HttpServletResponse;
import java.io.IOException; import java.util.List;
public class BookCatalogServlet extends HttpServlet {
    private BookDAO bookDAO = new BookDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Book> books = bookDAO.getAllBooks();
        request.setAttribute("books", books);
        request.getRequestDispatcher("/catalog.jsp").forward(request, response);
    }
}
EOF

# AddBookServlet
cat > "$SRC_SERVLETS/AddBookServlet.java" << EOF
package com.bookstore.servlets;
import com.bookstore.dao.BookDAO; import com.bookstore.model.Book; import com.bookstore.model.User;
import javax.servlet.ServletException; import javax.servlet.http.HttpServlet; import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse; import javax.servlet.http.HttpSession; import java.io.IOException;
public class AddBookServlet extends HttpServlet {
    private BookDAO bookDAO = new BookDAO();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null || !user.isAdmin()) { response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admins only."); return; }
        String title = request.getParameter("title"); String author = request.getParameter("author");
        double price = Double.parseDouble(request.getParameter("price")); int quantity = Integer.parseInt(request.getParameter("quantity"));
        Book newBook = new Book(0, title, author, price, quantity);
        if (bookDAO.addBook(newBook)) { response.sendRedirect(request.getContextPath() + "/catalog?admin=true&message=Book added successfully"); }
        else { request.setAttribute("errorMessage", "Failed to add book."); request.getRequestDispatcher("/addBook.jsp").forward(request, response); }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null || !user.isAdmin()) { response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admins only."); return; }
        request.getRequestDispatcher("/addBook.jsp").forward(request, response);
    }
}
EOF

# DeleteBookServlet
cat > "$SRC_SERVLETS/DeleteBookServlet.java" << EOF
package com.bookstore.servlets;
import com.bookstore.dao.BookDAO; import com.bookstore.model.User; import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet; import javax.servlet.http.HttpServletRequest; import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; import java.io.IOException;
public class DeleteBookServlet extends HttpServlet {
    private BookDAO bookDAO = new BookDAO();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null || !user.isAdmin()) { response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admins only."); return; }
        try {
            int bookId = Integer.parseInt(request.getParameter("id"));
            if (bookDAO.deleteBook(bookId)) { response.sendRedirect(request.getContextPath() + "/catalog?admin=true&message=Book deleted successfully"); }
            else { response.sendRedirect(request.getContextPath() + "/catalog?admin=true&error=Book not found or could not be deleted"); }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/catalog?admin=true&error=Invalid book ID");
        }
    }
}
EOF

echo "--- Step 4 Complete ---"

#!/bin/bash
# STEP 5: Java Servlets (Cart, Payment, Logout) and JSPs

SRC_SERVLETS="MolaBookStore/src/main/java/com/bookstore/servlets"
JSP_DIR="MolaBookStore/WebContent"
WEB_INF="$JSP_DIR/WEB-INF"
LIB_DIR="$JSP_DIR/WEB-INF/lib"

echo "--- Starting MolaBookStore Setup: Step 5/6 (Servlets 6-9 and JSPs) ---"

# 1. Download JSTL JAR
echo "1. Downloading JSTL JAR..."
wget -q "https://repo1.maven.org/maven2/javax/servlet/jstl/1.2.1/jstl-1.2.1.jar" -O "$LIB_DIR/jstl-1.2.1.jar"
export CLASSPATH="$CLASSPATH:$LIB_DIR/jstl-1.2.1.jar"

# 2. Remaining Servlets
echo "2. Writing Cart, Payment, and Logout Servlets..."

# AddToCartServlet
cat > "$SRC_SERVLETS/AddToCartServlet.java" << EOF
package com.bookstore.servlets;
import com.bookstore.dao.BookDAO; import com.bookstore.model.Book; import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet; import javax.servlet.http.HttpServletRequest; import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; import java.io.IOException; import java.util.HashMap; import java.util.Map;
public class AddToCartServlet extends HttpServlet {
    private BookDAO bookDAO = new BookDAO();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("bookId")); int quantity = 1;
        Book book = bookDAO.getBookById(bookId);
        if (book != null && book.getQuantity() > 0) {
            HttpSession session = request.getSession(); Map<Book, Integer> cart = (Map<Book, Integer>) session.getAttribute("cart");
            if (cart == null) { cart = new HashMap<>(); session.setAttribute("cart", cart); }
            boolean found = false;
            for (Map.Entry<Book, Integer> entry : cart.entrySet()) {
                if (entry.getKey().getId() == bookId) { cart.put(entry.getKey(), entry.getValue() + quantity); found = true; break; }
            }
            if (!found) { cart.put(book, quantity); }
            response.sendRedirect(request.getContextPath() + "/catalog?message=Book added to cart");
        } else { response.sendRedirect(request.getContextPath() + "/catalog?error=Book out of stock or not found"); }
    }
}
EOF

# ViewCartServlet
cat > "$SRC_SERVLETS/ViewCartServlet.java" << EOF
package com.bookstore.servlets;
import javax.servlet.ServletException; import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest; import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
public class ViewCartServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }
}
EOF

# PaymentServlet
cat > "$SRC_SERVLETS/PaymentServlet.java" << EOF
package com.bookstore.servlets;
import com.bookstore.dao.BookDAO; import com.bookstore.model.Book; import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet; import javax.servlet.http.HttpServletRequest; import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; import java.io.IOException; import java.util.Map;
public class PaymentServlet extends HttpServlet {
    private BookDAO bookDAO = new BookDAO();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) { response.sendRedirect("login.jsp"); return; }
        Map<Book, Integer> cart = (Map<Book, Integer>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) { response.sendRedirect("cart.jsp?error=Cart is empty"); return; }
        try {
            for (Map.Entry<Book, Integer> entry : cart.entrySet()) {
                Book book = entry.getKey(); int quantityBought = entry.getValue();
                int newQuantity = book.getQuantity() - quantityBought;
                if (newQuantity < 0) { response.sendRedirect("cart.jsp?error=Stock changed for " + book.getTitle()); return; }
                bookDAO.updateBookQuantity(book.getId(), newQuantity);
            }
            session.removeAttribute("cart");
            response.sendRedirect("success.jsp?type=payment");
        } catch (Exception e) { e.printStackTrace(); response.sendRedirect("cart.jsp?error=Payment processing failed: DB error."); }
    }
}
EOF

# LogoutServlet
cat > "$SRC_SERVLETS/LogoutServlet.java" << EOF
package com.bookstore.servlets;
import javax.servlet.ServletException; import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest; import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; import java.io.IOException;
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) { session.invalidate(); }
        response.sendRedirect(request.getContextPath() + "/login.jsp?logout=success");
    }
}
EOF

# 3. JSP Files (Frontend Views)
echo "3. Writing JSP files..."

# header.jsp
cat > "$WEB_INF/header.jsp" << EOF
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark"><div class="container-fluid"><a class="navbar-brand" href="catalog">MolaBookStore</a>
<div class="collapse navbar-collapse" id="navbarNav">
<ul class="navbar-nav me-auto mb-2 mb-lg-0"><li class="nav-item"><a class="nav-link" href="catalog">Catalog</a></li>
<c:if test="\${currentUser != null}"><li class="nav-item"><a class="nav-link" href="cart">Cart</a></li>
<c:if test="\${currentUser.admin}"><li class="nav-item"><a class="nav-link text-warning" href="admin/addBook">Add Book</a></li></c:if></c:if></ul>
<ul class="navbar-nav"><c:choose><c:when test="\${currentUser != null}"><li class="nav-item"><span class="nav-link text-light">Welcome, **\${currentUser.username}**</span></li>
<li class="nav-item"><a class="btn btn-outline-light" href="logout">Logout</a></li></c:when>
<c:otherwise><li class="nav-item"><a class="btn btn-outline-light me-2" href="login.jsp">Login</a></li>
<li class="nav-item"><a class="btn btn-light" href="signup.jsp">Sign Up</a></li></c:otherwise></c:choose></ul></div></div></nav>
EOF

# login.jsp
cat > "$JSP_DIR/login.jsp" << EOF
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html><head><title>Login</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body><div class="container col-md-4 mt-5"><div class="card shadow-lg"><div class="card-header bg-primary text-white text-center"><h3>Login</h3></div>
<div class="card-body"><c:if test="\${not empty param.logout}"><div class="alert alert-success">Logged out successfully.</div></c:if>
<c:if test="\${not empty param.signup}"><div class="alert alert-success">Registration successful!</div></c:if>
<c:if test="\${not empty errorMessage}"><div class="alert alert-danger">\${errorMessage}</div></c:if>
<form action="login" method="post"><div class="mb-3"><label for="username" class="form-label">Username</label><input type="text" class="form-control" id="username" name="username" required></div>
<div class="mb-3"><label for="password" class="form-label">Password</label><input type="password" class="form-control" id="password" name="password" required></div>
<button type="submit" class="btn btn-primary w-100">Login</button></form></div>
<div class="card-footer text-center">Don't have an account? <a href="signup.jsp">Sign Up Here</a></div></div></div></body></html>
EOF

# signup.jsp
cat > "$JSP_DIR/signup.jsp" << EOF
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html><head><title>Sign Up</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body><div class="container col-md-4 mt-5"><div class="card shadow-lg"><div class="card-header bg-success text-white text-center"><h3>Sign Up</h3></div>
<div class="card-body"><c:if test="\${not empty errorMessage}"><div class="alert alert-danger">\${errorMessage}</div></c:if>
<form action="signup" method="post"><div class="mb-3"><label for="username" class="form-label">Username</label><input type="text" class="form-control" id="username" name="username" required></div>
<div class="mb-3"><label for="password" class="form-label">Password</label><input type="password" class="form-control" id="password" name="password" required></div>
<button type="submit" class="btn btn-success w-100">Sign Up</button></form></div>
<div class="card-footer text-center">Already have an account? <a href="login.jsp">Login Here</a></div></div></div></body></html>
EOF

# catalog.jsp
cat > "$JSP_DIR/catalog.jsp" << EOF
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="bookDAO" class="com.bookstore.dao.BookDAO" /><c:set var="books" value="\${bookDAO.allBooks}" /><c:set var="isAdmin" value="\${currentUser != null and currentUser.admin and not empty param.admin}" />
<!DOCTYPE html><html><head><title>Catalog</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body><jsp:include page="/WEB-INF/header.jsp" /><div class="container mt-4"><h2 class="mb-4">\${isAdmin ? 'Admin Management' : 'Book Catalog'}</h2>
<c:if test="\${not empty param.message}"><div class="alert alert-success">\${param.message}</div></c:if><c:if test="\${not empty param.error}"><div class="alert alert-danger">\${param.error}</div></c:if>
<div class="row"><c:forEach var="book" items="\${books}"><div class="col-md-4 mb-4"><div class="card shadow-sm"><div class="card-body">
<h5 class="card-title">\${book.title}</h5><h6 class="card-subtitle mb-2 text-muted">by \${book.author}</h6>
<p class="card-text"><strong>Price:</strong> <fmt:formatNumber value="\${book.price}" type="currency" currencySymbol="$" /><br>
<strong>Stock:</strong> <span class="badge \${book.quantity > 0 ? 'bg-success' : 'bg-danger'}">\${book.quantity}</span></p>
<c:if test="\${!isAdmin}"><form action="addToCart" method="post"><input type="hidden" name="bookId" value="\${book.id}">
<button type="submit" class="btn btn-primary w-100" \${book.quantity == 0 ? 'disabled' : ''}>\${book.quantity == 0 ? 'Out of Stock' : 'Add to Cart'}</button></form></c:if>
<c:if test="\${isAdmin}"><form action="admin/deleteBook" method="post" class="mt-2"><input type="hidden" name="id" value="\${book.id}">
<button type="submit" class="btn btn-danger btn-sm w-100" onclick="return confirm('Delete \${book.title}?');">Delete</button></form></c:if>
</div></div></div></c:forEach></div></div></body></html>
EOF

# addBook.jsp
cat > "$JSP_DIR/addBook.jsp" << EOF
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html><head><title>Add Book</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body><jsp:include page="/WEB-INF/header.jsp" /><div class="container col-md-6 mt-4"><h2 class="mb-4 text-warning">Add Book (Admin)</h2>
<c:if test="\${not empty errorMessage}"><div class="alert alert-danger">\${errorMessage}</div></c:if>
<div class="card shadow"><div class="card-body"><form action="admin/addBook" method="post">
<div class="mb-3"><label for="title" class="form-label">Title</label><input type="text" class="form-control" id="title" name="title" required></div>
<div class="mb-3"><label for="author" class="form-label">Author</label><input type="text" class="form-control" id="author" name="author" required></div>
<div class="mb-3"><label for="price" class="form-label">Price</label><input type="number" step="0.01" class="form-control" id="price" name="price" required min="0.01"></div>
<div class="mb-3"><label for="quantity" class="form-label">Quantity</label><input type="number" class="form-control" id="quantity" name="quantity" required min="1"></div>
<button type="submit" class="btn btn-warning w-100">Add Book</button></form></div></div></div></body></html>
EOF

# cart.jsp
cat > "$JSP_DIR/cart.jsp" << EOF
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="cart" value="\${sessionScope.cart}" />
<!DOCTYPE html><html><head><title>Shopping Cart</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body><jsp:include page="/WEB-INF/header.jsp" /><div class="container mt-4"><h2 class="mb-4">Your Shopping Cart</h2>
<c:if test="\${not empty param.error}"><div class="alert alert-danger">\${param.error}</div></c:if>
<c:choose><c:when test="\${empty cart || cart.size() == 0}"><div class="alert alert-info" role="alert">Your cart is empty. <a href="catalog">Continue Shopping</a></div></c:when>
<c:otherwise><table class="table table-striped table-hover"><thead class="table-dark"><tr><th>Title</th><th>Author</th><th>Price</th><th>Quantity</th><th>Subtotal</th></tr></thead><tbody>
<c:set var="totalPrice" value="\${0}" /><c:forEach var="entry" items="\${cart}"><c:set var="book" value="\${entry.key}" />
<c:set var="quantity" value="\${entry.value}" /><c:set var="subtotal" value="\${book.price * quantity}" /><c:set var="totalPrice" value="\${totalPrice + subtotal}" />
<tr><td>\${book.title}</td><td>\${book.author}</td><td><fmt:formatNumber value="\${book.price}" type="currency" currencySymbol="$" /></td><td>\${quantity}</td>
<td><fmt:formatNumber value="\${subtotal}" type="currency" currencySymbol="$" /></td></tr></c:forEach></tbody></table>
<div class="row mt-4"><div class="col-md-6 offset-md-6"><div class="card shadow-lg"><div class="card-body">
<h4 class="card-title">Order Total: <span class="text-success"><fmt:formatNumber value="\${totalPrice}" type="currency" currencySymbol="$" /></span></h4>
<a href="payment.jsp" class="btn btn-success w-100">Proceed to Checkout</a></div></div></div></div></c:otherwise></c:choose></div></body></html>
EOF

# payment.jsp
cat > "$JSP_DIR/payment.jsp" << EOF
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="cart" value="\${sessionScope.cart}" />
<!DOCTYPE html><html><head><title>Checkout</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body><jsp:include page="/WEB-INF/header.jsp" /><div class="container col-md-6 mt-4"><h2 class="mb-4">Checkout and Payment</h2>
<c:if test="\${empty cart || cart.size() == 0}"><div class="alert alert-warning">Your cart is empty. <a href="catalog">Go to Catalog</a></div></c:if>
<c:if test="\${not empty cart and cart.size() > 0}">
<c:set var="totalPrice" value="\${0}" /><c:forEach var="entry" items="\${cart}"><c:set var="book" value="\${entry.key}" /><c:set var="quantity" value="\${entry.value}" /><c:set var="totalPrice" value="\${totalPrice + (book.price * quantity)}" /></c:forEach>
<div class="card shadow-lg mb-4"><div class="card-body bg-light">
<h5 class="card-title">Order Total: <span class="text-success"><fmt:formatNumber value="\${totalPrice}" type="currency" currencySymbol="$" /></span></h5></div></div>
<div class="card shadow"><div class="card-header bg-success text-white">Payment Details (Simulation)</div>
<div class="card-body"><form action="payment" method="post">
<div class="mb-3"><label for="cardName" class="form-label">Name on Card</label><input type="text" class="form-control" id="cardName" required></div>
<div class="mb-3"><label for="cardNumber" class="form-label">Card Number</label><input type="text" class="form-control" id="cardNumber" pattern="\d{16}" title="16 digits" required></div>
<button type="submit" class="btn btn-success w-100">Pay Now</button></form></div></div></c:if></div></body></html>
EOF

# success.jsp
cat > "$JSP_DIR/success.jsp" << EOF
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html><head><title>Success</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body><jsp:include page="/WEB-INF/header.jsp" /><div class="container col-md-6 mt-5"><div class="card text-center shadow-lg">
<div class="card-header bg-success text-white"><c:choose><c:when test="\${param.type eq 'payment'}"><h1>Payment Successful!</h1></c:when><c:otherwise><h1>Success!</h1></c:otherwise></c:choose></div>
<div class="card-body"><c:choose><c:when test="\${param.type eq 'payment'}"><p class="card-text fs-5">Thank you for your order!</p></c:when>
<c:otherwise><p class="card-text fs-5">Operation completed successfully.</p></c:otherwise></c:choose>
<hr><a href="catalog" class="btn btn-primary me-2">Continue Shopping</a><a href="logout" class="btn btn-secondary">Logout</a></div></div></div></body></html>
EOF

echo "--- Step 5 Complete ---"

#!/bin/bash
# STEP 6: Compilation, Deployment, and Launch

PROJECT_ROOT="MolaBookStore"
TARGET_CLASSES="$PROJECT_ROOT/target/classes"
WAR_NAME="MolaBookStore.war"
CATALINA_HOME=/usr/share/tomcat9 # Codespaces standard path
LIB_DIR="$PROJECT_ROOT/WebContent/WEB-INF/lib"
WAR_TEMP_DIR="/tmp/$PROJECT_ROOT"

echo "--- Starting MolaBookStore Setup: Step 6/6 ---"

# 1. Re-setting CLASSPATH 
# This ensures all necessary JARs (SQLite, Servlet API, JSTL) are on the path for compilation.
export CLASSPATH=":$LIB_DIR/sqlite-jdbc.jar:$LIB_DIR/servlet-api-4.0.1.jar:$LIB_DIR/jstl-1.2.1.jar" 

# 2. Compilation
echo "1. Compiling all Java classes using javac..."
JAVA_FILES=$(find "$PROJECT_ROOT/src/main/java" -name "*.java")

javac -cp "$CLASSPATH" -d "$TARGET_CLASSES" $JAVA_FILES
if [ $? -ne 0 ]; then
    echo "FATAL ERROR: Java compilation failed. Please verify the content of all .java files."
    exit 1
fi
echo "Compilation successful. Bytecode (.class files) are in $TARGET_CLASSES."

# 3. WAR Assembly
echo "2. Packaging application into $WAR_NAME..."
mkdir -p "$WAR_TEMP_DIR/WEB-INF/classes"

# Copy all files to a temporary location for packaging
cp -r "$PROJECT_ROOT/WebContent/"* "$WAR_TEMP_DIR"
cp -r "$TARGET_CLASSES/"* "$WAR_TEMP_DIR/WEB-INF/classes"
cp "$PROJECT_ROOT/molabookstore.db" "$WAR_TEMP_DIR/WEB-INF/"
cp -r "$PROJECT_ROOT/WebContent/WEB-INF/lib/"* "$WAR_TEMP_DIR/WEB-INF/lib"

# Create the WAR file
(cd "$WAR_TEMP_DIR" && jar -cvf "$PROJECT_ROOT.war" .)
cp "$WAR_TEMP_DIR/$WAR_NAME" "$PROJECT_ROOT/$WAR_NAME"
rm -rf "$WAR_TEMP_DIR"
echo "WAR file created: $PROJECT_ROOT/$WAR_NAME"

# 4. Deployment and Launch
echo "3. Deploying $WAR_NAME to Tomcat and restarting service..."
sudo cp "$PROJECT_ROOT/$WAR_NAME" "$CATALINA_HOME/webapps/"
sudo systemctl restart tomcat9

echo "---"
echo "✅ MolaBookStore Setup is **100% COMPLETE**! Application deployed."
echo "Access the application at: **http://localhost:8080/MolaBookStore/login.jsp**"
echo "The Codespace Ports tab should automatically forward port 8080."
echo "Test Accounts: **admin/adminpass** (Admin) | **user/userpass** (User)"
echo "---"
