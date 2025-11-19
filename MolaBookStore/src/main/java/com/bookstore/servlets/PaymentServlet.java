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
