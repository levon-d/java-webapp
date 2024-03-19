package ucl.ac.uk.servlets;

import ucl.ac.uk.models.Model;
import ucl.ac.uk.models.ModelFactory;
import java.io.*;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Map;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.time.LocalDate;
import java.time.Period;
import java.util.stream.Collectors;

@WebServlet("/graph.html")
public class Graph extends HttpServlet {

    private Model model = ModelFactory.getModel();
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException
    {

        Map<Integer, Integer> ageDistribution = new HashMap<>();

        int rowCount = model.getRowCount();
        for (int row = 0; row < rowCount; row++) {

            // don't account for dead people
            if (!model.getValue("DEATHDATE", row).isEmpty()) {
                continue;
            }

            String birthdateStr = model.getValue("BIRTHDATE", row);

            LocalDate birthdate;

            // if we have data of invalid type, don't account for it
            try {
                birthdate = LocalDate.parse(birthdateStr);
            } catch (Exception e) {
                continue;
            }
            LocalDate currentDate = LocalDate.now();
            int age = Period.between(birthdate, currentDate).getYears();
            ageDistribution.put(age, ageDistribution.getOrDefault(age, 0) + 1);
        }

        ArrayList<String> labels = ageDistribution.keySet()
                .stream()
                .map(String::valueOf)
                .collect(Collectors.toCollection(ArrayList::new));

        ArrayList<Integer> data = new ArrayList<>(ageDistribution.values());

        request.setAttribute("labels", labels);
        request.setAttribute("data", data);

        RequestDispatcher dispatch = request.getRequestDispatcher("/views/graphs.jsp");
        dispatch.forward(request, response);
    }
}
