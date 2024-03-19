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

    public Column getColumn(String columnName) {
        return columns.stream()
                .filter(column -> column.getName().equals(columnName))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Column not found: " + columnName));

    }

    public int getRowCount() {
        return columns.isEmpty() ? 0 : columns.get(0).getSize();
    }

    public String getValue(String columnName, int rowIndex) {
        for (Column column : columns) {
            if (column.getName().equals(columnName)) {
                try {
                    return column.getRowValue(rowIndex);
                } catch (IndexOutOfBoundsException e) {
                    System.out.println(columnName);
                    System.out.println(column.getRows().size());
                    System.out.println(column.getRows().toString());
                    throw new IndexOutOfBoundsException("Index " + rowIndex + " is out of bounds.");
                }
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

    public ArrayList<String> getRowById(String Id) {
        ArrayList<String> row = new ArrayList<>();
        for (Column column : columns) {
            if (column.getName().equals("ID")) {
                int rowIndex = column.getRowIndexById(Id);
                for (Column c : columns) {
                    row.add(c.getRowValue(rowIndex));
                }
                return row;
            }
        }
        throw new IllegalArgumentException("The provided ID does not exist.");
    }
    public int getRowIndexById(String Id) {
        for (Column column : columns) {
            if (column.getName().equals("ID")) {
                return column.getRowIndexById(Id);
            }
        }
        throw new IllegalArgumentException("The provided ID does not exist.");
    }

    public ArrayList<Column> getColumns() {
        return columns;
    }
}
