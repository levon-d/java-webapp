package ucl.ac.uk.models;

import java.util.ArrayList;
import ucl.ac.uk.exceptions.ExistingColumnNameException;

public class Model {
    private DataFrame dataFrame;

    public Model() {
        dataFrame = DataLoader.loadCSVData("patients100.csv");
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

}
