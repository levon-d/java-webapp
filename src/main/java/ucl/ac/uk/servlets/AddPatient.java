package ucl.ac.uk.servlets;

import ucl.ac.uk.models.Model;
import ucl.ac.uk.models.ModelFactory;
import java.io.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/addpatient")
public class AddPatient extends HttpServlet {

    private Model model = ModelFactory.getModel();
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException
    {

        Map<String, String> columnValues = new HashMap<>();

        List<String> columnNames = model.getColumnNames();

        for (String columnName : columnNames) {
            if (!columnName.equalsIgnoreCase("ID")) {
                String value = request.getParameter(columnName);
                columnValues.put(columnName, value);
            }
        }

        try {
            model.addRow(columnValues);
            request.setAttribute("successMessage", "The row was successfully edited");
        } catch (IOException e) {
            request.setAttribute("errorMessage", "A problem occurred when handling files");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An unexpected error occurred");
        }

        request.setAttribute("model", model);
        RequestDispatcher dispatch = request.getRequestDispatcher("/views/viewdata.jsp");
        dispatch.forward(request, response);
    }
}
