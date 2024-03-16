package ucl.ac.uk.models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import ucl.ac.uk.exceptions.ExistingColumnNameException;

public class Model {
    private DataFrame dataFrame;

    public Model() {
        this.dataFrame = DataLoader.loadCSVData("patients100.csv");
    }

    public void addColumn(Column column) throws ExistingColumnNameException {
        dataFrame.addColumn(column);
    }

    public ArrayList<String> getColumnNames() {
        return dataFrame.getColumnNames();
    }

    public int getRowCount() {
        return dataFrame.getRowCount();
    }

    public String getValue(String columnName, int rowIndex) {
        return dataFrame.getValue(columnName, rowIndex);
    }

    public void putValue(String columnName, int rowIndex, String value) {
        dataFrame.putValue(columnName, rowIndex, value);
    }
    public void addValue(String columnName, String value) {
        dataFrame.addValue(columnName, value);
    }

    public HashMap<String, String> getAllRows(String columnName) {
      HashMap<String, String> rows = new HashMap<String, String>();
      int rowCount = getRowCount();
      for (int rowIndex = 0; rowIndex<rowCount; rowIndex++) {
          rows.put(getValue("ID", rowIndex), getValue(columnName, rowIndex));
      }
      return rows;
    }

    public ArrayList<String> searchData(String searchText, String columnName) {

        ArrayList<String> ids = new ArrayList<String>();

        if (!dataFrame.getColumnNames().contains(columnName)) {
            throw new IllegalArgumentException("Column "+ columnName + "does not exist");
        }
        for (Map.Entry<String, String> row : getAllRows(columnName).entrySet()) {
            // toLower in order to make the search case-insensitive
            if (row.getValue().toLowerCase().contains(searchText.toLowerCase())) {
                ids.add(row.getKey());
            }
        }
        return ids;
    }

}
