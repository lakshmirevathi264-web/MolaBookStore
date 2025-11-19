package com.bookstore.servlets;
import com.bookstore.dao.BookDAO; import com.bookstore.model.Book; import com.bookstore.model.User;
import javax.servlet.ServletException; import javax.servlet.http.HttpServlet; import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse; import javax.servlet.http.HttpSession; import java.io.IOException; import java.io.PrintWriter;
public class AddBookServlet extends HttpServlet {
    private BookDAO bookDAO = new BookDAO();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null || !user.isAdmin()) { response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admins only."); return; }
        String title = request.getParameter("title"); String author = request.getParameter("author");
        String priceStr = request.getParameter("price"); String qtyStr = request.getParameter("quantity");
        boolean isXhr = "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"));
        if (title == null || title.isEmpty() || author == null || author.isEmpty() || priceStr == null || qtyStr == null) {
            if (isXhr) {
                response.setContentType("application/json"); response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                try (PrintWriter out = response.getWriter()) { out.print("{\"success\":false,\"message\":\"Missing required fields\"}"); }
            } else {
                request.setAttribute("errorMessage", "Missing required fields."); request.getRequestDispatcher("/addBook.jsp").forward(request, response);
            }
            return;
        }
        double price; int quantity;
        try {
            price = Double.parseDouble(priceStr);
            quantity = Integer.parseInt(qtyStr);
        } catch (NumberFormatException nfe) {
            if (isXhr) {
                response.setContentType("application/json"); response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                try (PrintWriter out = response.getWriter()) { out.print("{\"success\":false,\"message\":\"Invalid price or quantity\"}"); }
            } else {
                request.setAttribute("errorMessage", "Invalid price or quantity."); request.getRequestDispatcher("/addBook.jsp").forward(request, response);
            }
            return;
        }
        Book newBook = new Book(0, title, author, price, quantity);
        if (bookDAO.addBook(newBook)) {
            if (isXhr) {
                response.setContentType("application/json"); response.setStatus(HttpServletResponse.SC_OK);
                try (PrintWriter out = response.getWriter()) { out.print("{\"success\":true,\"message\":\"Book added successfully\"}"); }
            } else {
                response.sendRedirect(request.getContextPath() + "/catalog?admin=true&message=Book added successfully");
            }
        } else {
            if (isXhr) {
                response.setContentType("application/json"); response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                try (PrintWriter out = response.getWriter()) { out.print("{\"success\":false,\"message\":\"Failed to add book\"}"); }
            } else {
                request.setAttribute("errorMessage", "Failed to add book."); request.getRequestDispatcher("/addBook.jsp").forward(request, response);
            }
        }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null || !user.isAdmin()) { response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admins only."); return; }
        request.getRequestDispatcher("/addBook.jsp").forward(request, response);
    }
}
