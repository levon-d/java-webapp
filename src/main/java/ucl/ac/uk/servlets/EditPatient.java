package ucl.ac.uk.servlets;

import ucl.ac.uk.models.Model;
import ucl.ac.uk.models.ModelSingleton;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/editpatient")
public class EditPatient extends HttpServlet {

    private Model model = ModelSingleton.getModel();
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException
    {

        String id = request.getParameter("selectedId");
        String columnName = request.getParameter("columnNameToEdit");
        String value = request.getParameter("newValue");

        if (columnName.equalsIgnoreCase("ID")) {
            ServletUtils.handleError(request, response, "ID cannot be edited");
            return;
        }

        try {
            model.editRow(id, columnName, value);
            request.setAttribute("successMessage", "The row was successfully edited");
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
