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
