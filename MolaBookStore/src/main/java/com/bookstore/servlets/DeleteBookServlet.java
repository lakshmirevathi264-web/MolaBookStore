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
