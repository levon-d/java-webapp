package ucl.ac.uk.servlets;

import ucl.ac.uk.models.Model;
import ucl.ac.uk.models.ModelFactory;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.util.ArrayList;
import java.util.stream.Collectors;

@WebServlet({"/viewdata.html", ""})
public class ViewDataServletJSP extends HttpServlet {

    private Model model = ModelFactory.getModel();

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException
    {

        if (model.errorState) {
            ServletUtils.handleError(request, response, "An unexpected error occurred");
            return;
        }
        ArrayList<String> columnNames = model.getColumnNames();


        String searchText = request.getParameter("searchText");
        String sortOrderParam = request.getParameter("sortOrder");
        String columnNameSearch = request.getParameter("columnNameSearch");
        String columnNameSort = request.getParameter("columnNameSort");
        String limitParam = request.getParameter("limit");

        String filterText = request.getParameter("filterText");
        String filterColumn = request.getParameter("filterColumn");


        ArrayList<String> matchedIds = new ArrayList<>();
        if (searchText != null && !searchText.isEmpty() && columnNameSearch != null && !columnNameSearch.isEmpty()) {
            try {
                matchedIds = model.searchData(searchText, columnNameSearch);
            } catch (IllegalArgumentException e) {
                ServletUtils.handleError(request, response, "Invalid search column: " + columnNameSearch);
                return;
            }
        }

        Model.SortOrder sortOrder = Model.SortOrder.ASC;

        if (sortOrderParam != null && !sortOrderParam.isEmpty()) {
            try {
                sortOrder = Model.SortOrder.valueOf(sortOrderParam.toUpperCase());
            } catch (IllegalArgumentException e) {
                ServletUtils.handleError(request, response, "Invalid sort order: " + sortOrderParam);
                return;
            }
            if (columnNameSort != null && !columnNameSort.isEmpty()) {
                if (!columnNames.contains(columnNameSort)) {
                    ServletUtils.handleError(request, response, "Invalid sort column: " + columnNameSort);
                    return;
                } else {
                    matchedIds = model.sortData(columnNameSort, sortOrder);
                }
            }
        }

        if (limitParam != null && !limitParam.isEmpty()) {
            try {
                int limit = Integer.parseInt(limitParam);
                if (limit < 0) {
                    ServletUtils.handleError(request, response, "Invalid limit: " + limitParam);
                    return;
                } else {
                    matchedIds = (ArrayList<String>) matchedIds.stream().limit(limit).collect(Collectors.toList());
                }
            } catch (NumberFormatException e) {
                ServletUtils.handleError(request, response, "Invalid limit: " + limitParam);
                return;
            }
        }

        request.setAttribute("model", model);
        request.setAttribute("matchedIds", matchedIds);
        // Then forward to JSP.

        RequestDispatcher dispatch = request.getRequestDispatcher("/views/viewdata.jsp");
        dispatch.forward(request, response);
    }
}
