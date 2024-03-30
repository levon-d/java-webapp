package ucl.ac.uk.servlets;

import ucl.ac.uk.models.Model;
import ucl.ac.uk.models.ModelFactory;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/list.html")
public class ListView extends HttpServlet {

    private Model model = ModelFactory.getModel();
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException
    {
        request.setAttribute("model", model);
        RequestDispatcher dispatch = request.getRequestDispatcher("/views/listView.jsp");
        dispatch.forward(request, response);
    }
}
