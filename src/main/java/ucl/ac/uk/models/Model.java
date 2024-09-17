package ucl.ac.uk.models;

import java.io.IOException;
import java.util.UUID;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import ucl.ac.uk.exceptions.ExistingColumnNameException;

public class Model {
    private final String fileName = "patients1000.csv";
    public boolean errorState = false;
    public static enum SortOrder {
        ASC, DESC
    }

    private DataFrame dataFrame;

    public Model() {
        this.dataFrame = DataLoader.loadCSVData(fileName);
        if (dataFrame == null) {
            this.errorState = true;
        }
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
        for (int rowIndex = 0; rowIndex < rowCount; rowIndex++) {
            rows.put(getValue("ID", rowIndex), getValue(columnName, rowIndex));
        }
        return rows;
    }

    public ArrayList<String> searchData(String searchText, String columnName) {

        ArrayList<String> ids = new ArrayList<String>();

        if (!getColumnNames().contains(columnName)) {
            throw new IllegalArgumentException("Column " + columnName + "does not exist");
        }
        for (Map.Entry<String, String> row : getAllRows(columnName).entrySet()) {
            // toLower in order to make the search case-insensitive
            if (row.getValue().toLowerCase().contains(searchText.toLowerCase())) {
                ids.add(row.getKey());
            }
        }
        return ids;
    }

    public ArrayList<String> sortData(String columnName, SortOrder sortOrder) {
        HashMap<String, String> rows = getAllRows(columnName);

        ArrayList<String> keys = new ArrayList<>(rows.keySet());

        // Sort the keys based on values
        keys.sort((key1, key2) -> {
            String value1 = rows.get(key1);
            String value2 = rows.get(key2);
            return sortOrder == SortOrder.ASC ? value1.compareTo(value2) : value2.compareTo(value1);
        });
        // Add the sorted keys to the result list
        return new ArrayList<String>(keys);
    }

    public void addRow(Map<String, String> row) throws IOException {
        UUID uuid = UUID.randomUUID();
        row.put("ID", uuid.toString());
        for (Map.Entry<String, String> entry : row.entrySet()) {
            addValue(entry.getKey(), entry.getValue());
        }
//        DataLoader.backupCurrentCsvFile(fileName);
//        DataLoader.writeIntoNewFile(fileName, dataFrame);
        DataLoaderPostgres.addRow(row);
    }

    public void editRow(String id, String columnName, String value) throws IOException{
        putValue(columnName, dataFrame.getRowIndexById(id), value);
//        DataLoader.backupCurrentCsvFile(fileName);
//        DataLoader.writeIntoNewFile(fileName, dataFrame);
        DataLoaderPostgres.editRow(id, columnName, value);
    }

    public void deleteRow(String id) throws IOException {
        int rowIndex = dataFrame.getRowIndexById(id);
        for (Column column : dataFrame.getColumns()) {
            column.getRows().remove(rowIndex);
        }
//        DataLoader.backupCurrentCsvFile(fileName);
//        DataLoader.writeIntoNewFile(fileName, dataFrame);
        DataLoaderPostgres.deleteRow(id);

    }

}
