package ucl.ac.uk.servlets;

import ucl.ac.uk.models.Model;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.util.ArrayList;

@WebServlet("/viewdata.html")
public class ViewDataServletJSP extends HttpServlet {

    private Model model;

    @Override
    public void init() {
        model = new Model();
    }
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException
    {
        ArrayList<String> columnNames = model.getColumnNames();
        int rowCount = model.getRowCount();

        String searchText = request.getParameter("searchText");
        String columnName = request.getParameter("columnName");

        ArrayList<String> matchedIds = new ArrayList<>();
        if (searchText != null && !searchText.isEmpty() && columnName != null && !columnName.isEmpty()) {
            matchedIds = model.searchData(searchText, columnName);
        }

        request.setAttribute("columnNames", columnNames);
        request.setAttribute("rowCount", rowCount);
        request.setAttribute("model", model);
        request.setAttribute("matchedIds", matchedIds);
        // Then forward to JSP.

        RequestDispatcher dispatch = request.getRequestDispatcher("/views/viewdata.jsp");
        dispatch.forward(request, response);
    }
}
