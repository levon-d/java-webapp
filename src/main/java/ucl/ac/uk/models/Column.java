package ucl.ac.uk.models;

import java.util.ArrayList;

public class Column {
    private String name;
    private ArrayList<String> rows;

    public Column(String name, ArrayList<String> rows) {
        this.name = name;
        this.rows = rows;
    }

    public String getName() {
        return name;
    }

    public int getSize() {
        return rows.size();
    }

    public String getRowValue(int rowIndex) {
        if (rowIndex > getSize() - 1 || rowIndex < 0) {
            throw new IndexOutOfBoundsException("Index " + rowIndex + " is out of bounds.");
        } else {
            return rows.get(rowIndex);
        }
    }

    public ArrayList<String> getRows() {
        return rows;
    }

    public int getRowIndexByValue(String value) {
        for (int i = 0; i < getSize(); i++) {
            if (rows.get(i).equals(value)) {
                return i;
            }
        }
        throw new IllegalArgumentException(value + " does not exist.");
    }

    public void setRowValue(int rowIndex, String value) {
        if (rowIndex > getSize() - 1 || rowIndex < 0) {
            throw new IndexOutOfBoundsException("Index " + rowIndex + " is out of bounds.");
        } else {
            rows.set(rowIndex, value);
        }
    }

    public void addRowValue(String value) {
        rows.add(value);
    }

}
