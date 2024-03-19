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
        System.out.println("id: " + id);
        try {
            model.deleteRow(id);
            System.out.println("inside the try block");
            request.setAttribute("successMessage", "The row was successfully deleted");
        } catch (IllegalArgumentException e) {
            System.out.println("inside the illegal arg block");
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid ID: " + id);
        } catch (IOException e) {
            System.out.println("inside the io block");
            e.printStackTrace();
            request.setAttribute("errorMessage", "A problem occurred when handling files");
        }

        request.setAttribute("model", model);
        RequestDispatcher dispatch = request.getRequestDispatcher("/views/viewdata.jsp");
        dispatch.forward(request, response);
    }
}