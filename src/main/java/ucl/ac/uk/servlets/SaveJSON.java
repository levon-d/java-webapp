package ucl.ac.uk.servlets;

import com.fasterxml.jackson.core.JsonProcessingException;
import ucl.ac.uk.models.Model;
import ucl.ac.uk.models.ModelFactory;
import ucl.ac.uk.models.JSONWriter;

import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/savejson")
public class SaveJSON extends HttpServlet {

    private Model model = ModelFactory.getModel();
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException
    {

        String jsonData = "";
        try {
            jsonData = JSONWriter.createJSONFromModel(model);
        } catch (JsonProcessingException e) {
            ServletUtils.handleError(request, response, "An unexpected error occurred");
        }

        request.setAttribute("model", model);

        response.setContentType("application/json");
        response.setHeader("Content-Disposition", "attachment; filename=\"model_data.json\"");

        // Write the JSON data to the response
        PrintWriter out = response.getWriter();
        out.print(jsonData);
        out.flush();
    }
}
