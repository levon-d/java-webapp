package ucl.ac.uk.servlets;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

public class ServletUtils {
    public static void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        RequestDispatcher dispatch = request.getRequestDispatcher("/views/errorCard.jsp");
        dispatch.forward(request, response);
    }
}
