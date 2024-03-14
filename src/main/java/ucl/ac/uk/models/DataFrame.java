package ucl.ac.uk.models;
import java.util.ArrayList;
import ucl.ac.uk.exceptions.ExistingColumnNameException;

public class DataFrame {
    private ArrayList<Column> columns;

    public DataFrame(ArrayList<Column> columns) {
        this.columns = columns;
    }

    public void addColumn(Column column) throws ExistingColumnNameException {
        String columnName = column.getName();
        if (getColumnNames().contains(columnName)) {
            throw new ExistingColumnNameException("The column with the given name already exists in the dataframe.");
        }
        columns.add(column);
    }

    public ArrayList<String> getColumnNames() {
        ArrayList<String> names = new ArrayList<>();
        for (Column column : columns) {
            names.add(column.getName());
        }
        return names;
    }

    public int getRowCount() {
        return columns.isEmpty() ? 0 : columns.get(0).getSize();
    }

    public String getValue(String columnName, int rowIndex) {
        for (Column column : columns) {
            if (column.getName().equals(columnName)) {
                return column.getRowValue(rowIndex);
            }
        }
        throw new IllegalArgumentException("Column " + columnName + " does not exist.");
    }

    public void putValue(String columnName, int rowIndex, String value) {
        for (Column column : columns) {
            if (column.getName().equals(columnName)) {
                column.setRowValue(rowIndex, value);
                return;
            }
        }
        throw new IllegalArgumentException("Column " + columnName + " does not exist.");
    }

    public void addValue(String columnName, String value) {
        for (Column column : columns) {
            if (column.getName().equals(columnName)) {
                column.addRowValue(value);
                return;
            }
        }
        throw new IllegalArgumentException("Column " + columnName + " does not exist.");
    }
}
