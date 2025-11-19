package com.bookstore.servlets;

import com.bookstore.dao.UserDAO;
import com.bookstore.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import org.mindrot.jbcrypt.BCrypt;

public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        User user = userDAO.getUserByUsername(username);

        boolean authenticated = false;
        if (user != null) {
            String stored = user.getPassword();
            if (stored != null) {
                // If stored password looks like a bcrypt hash, verify with BCrypt
                if (stored.startsWith("$2a$") || stored.startsWith("$2y$") || stored.startsWith("$2b$")) {
                    try { authenticated = BCrypt.checkpw(password, stored); } catch (Exception e) { authenticated = false; }
                } else {
                    // fallback to plain-text comparison for existing seeded users
                    authenticated = stored.equals(password);
                }
            }
        }

        if (authenticated && user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);
            response.sendRedirect(request.getContextPath() + "/catalog" + (user.isAdmin() ? "?admin=true" : ""));
        } else {
            request.setAttribute("errorMessage", "Invalid username or password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
