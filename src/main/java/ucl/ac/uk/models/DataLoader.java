package ucl.ac.uk.models;

import java.util.ArrayList;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;


public class DataLoader {
    public static DataFrame loadCSVData(String fileName) {
        String pathToFile = "data/" + fileName; // get the csv file from resources/data directory
        ArrayList<Column> columns = new ArrayList<>();

        try (BufferedReader br = new BufferedReader(new FileReader(pathToFile))) {
            String currentLine = br.readLine();
            if (currentLine != null) {

                // first row will be the column headers
                String[] columnNames = currentLine.split(",");
                for (String columnName : columnNames) {
                    columns.add(new Column(columnName, new ArrayList<>()));
                }

                currentLine = br.readLine();
                while (currentLine != null) {
                    String[] values = currentLine.split(",");
                    for (int i = 0; i < values.length; i++) {
                        columns.get(i).addRowValue(values[i]);
                    }
                    currentLine = br.readLine(); // Read the next line
                }

            }

        } catch (IOException e) {
            System.out.println("Could not read the file: " + e.getMessage());
            return null;
        }
        return new DataFrame(columns);
    }
}
