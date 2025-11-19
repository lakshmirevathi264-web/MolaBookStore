package com.bookstore.servlets;

import com.bookstore.dao.UserDAO;
import com.bookstore.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.mindrot.jbcrypt.BCrypt;

public class SignupServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.length() < 6) {
            request.setAttribute("errorMessage", "Invalid username or password (min 6 chars).");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        if (userDAO.getUserByUsername(username) != null) {
            request.setAttribute("errorMessage", "Username already exists.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        // Hash password with bcrypt
        String hashed = BCrypt.hashpw(password, BCrypt.gensalt(12));
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(hashed);
        newUser.setAdmin(false);

        boolean created = userDAO.addUser(newUser);
        if (created) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?signup=success");
        } else {
            request.setAttribute("errorMessage", "Registration failed. Try again.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
        }
    }
}
