package ucl.ac.uk.servlets;

import ucl.ac.uk.models.Model;
import ucl.ac.uk.models.ModelFactory;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Optional;
import java.util.stream.Collectors;

@WebServlet("/viewdata.html")
public class ViewDataServletJSP extends HttpServlet {

    private Model model = ModelFactory.getModel();

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException
    {
        ArrayList<String> columnNames = model.getColumnNames();
        int rowCount = model.getRowCount();

        String searchText = request.getParameter("searchText");
        String sortOrderParam = request.getParameter("sortOrder");
        String columnNameSearch = request.getParameter("columnNameSearch");
        String columnNameSort = request.getParameter("columnNameSort");
        String limitParam = request.getParameter("limit");


        ArrayList<String> matchedIds = new ArrayList<>();
        if (searchText != null && !searchText.isEmpty() && columnNameSearch != null && !columnNameSearch.isEmpty()) {
            matchedIds = model.searchData(searchText, columnNameSearch);
        }

        Model.SortOrder sortOrder = Model.SortOrder.ASC;

        if (sortOrderParam != null && !sortOrderParam.isEmpty()) {
            try {
                sortOrder = Model.SortOrder.valueOf(sortOrderParam.toUpperCase());
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessae", "Invalid sort order: " + sortOrderParam);
            }
            if (columnNameSort != null && !columnNameSort.isEmpty()) {
                matchedIds = model.sortData(columnNameSort, sortOrder);
            }
        }

        if (limitParam != null && !limitParam.isEmpty()) {
            try {
                int limit = Integer.parseInt(limitParam);
                if (limit < 0) {
                    request.setAttribute("errorMessage", "Invalid limit: " + limitParam);
                } else {
                    matchedIds = (ArrayList<String>) matchedIds.stream().limit(limit).collect(Collectors.toList());
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid limit: " + limitParam);
            }
        }

        request.setAttribute("model", model);
        request.setAttribute("matchedIds", matchedIds);
        // Then forward to JSP.

        RequestDispatcher dispatch = request.getRequestDispatcher("/views/viewdata.jsp");
        dispatch.forward(request, response);
    }
}
