package ucl.ac.uk.models;

import static java.nio.file.StandardCopyOption.*;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Date;
import java.util.ArrayList;
import java.io.BufferedWriter;


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
                    String[] values = currentLine.split(",", -1);
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

    public static void backupCurrentCsvFile(String fileName) throws IOException {
        String oldPathToFile = "data/" + fileName;

        // add the current timestamp to avoid duplicate file names
        String newPathToFile = "data/backups/" + fileName + new Date().toString();

        // rethrow the exception if it occurs and handle it on the servlet
        Files.move(Paths.get(oldPathToFile), Paths.get(newPathToFile), REPLACE_EXISTING);
    }

    public static void writeIntoNewFile(String fileName, DataFrame dataFrame) throws IOException {
        int rowCount = dataFrame.getRowCount();
        String pathToFile = "data/" + fileName;
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(pathToFile))) {
            List<Column> columns = dataFrame.getColumns();
            List<String> columnNames = dataFrame.getColumnNames();
            StringBuilder header = new StringBuilder(); // mutable string needed to append to
            int columnIndex = 0;
            for (String columnName : columnNames) {
                // if on the last element, don't add comma
                if (columnIndex++ == columnNames.size() - 1) {
                    header.append(columnName);
                } else {
                    header.append(columnName).append(",");
                }
            }
            writer.write(header.toString());
            writer.newLine();
            for (int i=0; i < rowCount; i++) {
                StringBuilder row = new StringBuilder();
                int j = 0;
                for (Column column : columns) {
                    if (j++ == columns.size() - 1) {
                        row.append(column.getRowValue(i));
                    } else {
                        row.append(column.getRowValue(i)).append(",");
                    }
                }
                writer.write(row.toString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.out.println("Could not rewrite the data into a new file");
            throw new IOException(e.getMessage());
        }
    }
}
