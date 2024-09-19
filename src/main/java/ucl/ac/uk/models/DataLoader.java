package ucl.ac.uk.models;

import static java.nio.file.StandardCopyOption.*;

import ucl.ac.uk.db.DB;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.sql.Date;
import java.util.ArrayList;
import java.io.BufferedWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;


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
        String newPathToFile = "data/backups/" + fileName + new java.util.Date().toString();

        // rethrow the exception if it occurs and handle it on the servlet
        Files.move(Paths.get(oldPathToFile), Paths.get(newPathToFile), REPLACE_EXISTING);
    }

    // script used to insert the csv data into postgres db
    public static void loadCSVDataToPostgres(String fileName) {
        String pathToFile = "data/" + fileName;

        try (BufferedReader br = new BufferedReader(new FileReader(pathToFile));
             Connection connection = DB.connect();) {

            String currentLine = br.readLine();
            if (currentLine != null) {

                // first row will be the column headers
                String[] columnNames = currentLine.split(",");

                // Prepare an SQL statement for inserting data
                StringBuilder sql = new StringBuilder("INSERT INTO patients (");
                for (String columnName : columnNames) {
                    sql.append(columnName).append(",");
                }

                sql.setLength(sql.length() - 1); // Remove trailing comma
                sql.append(") VALUES (");

                for (int i = 0; i < columnNames.length; i++) {
                    sql.append("?,");
                }
                sql.setLength(sql.length() - 1); // Remove trailing comma
                sql.append(")");

                PreparedStatement pstmt = connection.prepareStatement(sql.toString());

                // Insert each row into the database
                currentLine = br.readLine(); // Read the next row (first data row)
                while (currentLine != null) {
                    String[] values = currentLine.split(",", -1);
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); // Format for converting date strings
                    String birthDateStr = values[1];
                    String deathDateStr = values[2];
                    Date birthDate = (birthDateStr != null && !birthDateStr.isEmpty()) ? new Date(dateFormat.parse(birthDateStr).getTime()) : null;
                    Date deathDate = (deathDateStr != null && !deathDateStr.isEmpty()) ? new Date(dateFormat.parse(deathDateStr).getTime()) : null;
                    for (int i = 0; i < values.length; i++) {
                        if (i==1) {
                            pstmt.setDate(i + 1, birthDate);
                        } else if (i==2) {
                            pstmt.setDate(i+1, deathDate);
                        } else {
                            pstmt.setString(i + 1, values[i]);
                        }

                    }
                    pstmt.executeUpdate();

                    currentLine = br.readLine(); // Read the next line
                }
                System.out.println("Data inserted successfully!");

            }

        } catch (IOException | SQLException e) {
            System.out.println("Error: " + e.getMessage());
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
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
