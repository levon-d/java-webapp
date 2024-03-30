package ucl.ac.uk.servlets;

import ucl.ac.uk.models.Model;
import ucl.ac.uk.models.ModelFactory;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/deletepatient")
public class DeletePatient extends HttpServlet {

    private Model model = ModelFactory.getModel();
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException
    {

        String id = request.getParameter("selectedId");
        try {
            model.deleteRow(id);
        } catch (IllegalArgumentException e) {
            ServletUtils.handleError(request, response, "Invalid ID: " + id);
            return;
        } catch (IOException e) {
            ServletUtils.handleError(request, response, "A problem occurred when handling files");
            return;
        }

        request.setAttribute("model", model);
        response.sendRedirect("/viewdata.html");
    }
}