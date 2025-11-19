package com.bookstore.servlets;
import com.bookstore.dao.BookDAO; import com.bookstore.model.Book; import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet; import javax.servlet.http.HttpServletRequest; import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; import java.io.IOException; import java.util.HashMap; import java.util.Map;
public class AddToCartServlet extends HttpServlet {
    private BookDAO bookDAO = new BookDAO();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookIdParam = request.getParameter("bookId");
        int quantity = 1;
        if (bookIdParam == null) {
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false,\"message\":\"Missing bookId\"}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/catalog?error=Missing+bookId");
            return;
        }
        int bookId;
        try {
            bookId = Integer.parseInt(bookIdParam);
        } catch (NumberFormatException e) {
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false,\"message\":\"Invalid bookId\"}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/catalog?error=Invalid+bookId");
            return;
        }
        Book book = bookDAO.getBookById(bookId);
        if (book != null && book.getQuantity() > 0) {
            HttpSession session = request.getSession(); Map<Book, Integer> cart = (Map<Book, Integer>) session.getAttribute("cart");
            if (cart == null) { cart = new HashMap<>(); session.setAttribute("cart", cart); }
            boolean found = false;
            for (Map.Entry<Book, Integer> entry : cart.entrySet()) {
                if (entry.getKey().getId() == bookId) { cart.put(entry.getKey(), entry.getValue() + quantity); found = true; break; }
            }
            if (!found) { cart.put(book, quantity); }
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":true,\"message\":\"Book added to cart\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/catalog?message=Book added to cart");
            }
        } else { response.sendRedirect(request.getContextPath() + "/catalog?error=Book out of stock or not found"); }
    }
}
