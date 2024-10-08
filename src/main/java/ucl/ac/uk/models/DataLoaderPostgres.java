package ucl.ac.uk.models;

import ucl.ac.uk.db.DB;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.util.Map;

public class DataLoaderPostgres {
    private static Connection connection;

    static {
        connection = DB.connect();
    }


    public static DataFrame loadPostgresData() {

        ArrayList<Column> columns = new ArrayList<>();
        String query = "SELECT * FROM patients";

        try (PreparedStatement pstmt = connection.prepareStatement(query);
             ResultSet resultSet = pstmt.executeQuery();) {

            int columnCount = resultSet.getMetaData().getColumnCount();

            for (int i = 1; i<=columnCount; i++) {
                String columnName = resultSet.getMetaData().getColumnName(i);
                columns.add(new Column(columnName, new ArrayList<>()));
            }

            while (resultSet.next()) {
                for (int i = 1; i<=columnCount; i++) {
                    String value = resultSet.getString(i);
                    columns.get(i-1).addRowValue(value);
                }
            }
        }
        catch (SQLException e) {
            System.out.println("Could not load postgres data");
            return null;
        }
        return new DataFrame(columns);
    }

    public static void editRow(String id, String columnName, String newValue) {

        String query = String.format("UPDATE patients SET \"%s\" = ? WHERE \"ID\" = ?", columnName);
        Date formattedValue = null;

        if (columnName.equals("BIRTHDATE") | columnName.equals("DEATHDATE")) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); // Format for converting date strings
            try {
                formattedValue = new Date(dateFormat.parse(newValue).getTime());
            } catch (ParseException e) {
                throw new RuntimeException(e);
            }
        }

        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            if (formattedValue == null) {
                pstmt.setString(1, newValue);
            } else {
                pstmt.setDate(1, formattedValue);
            }

            pstmt.setString(2, id);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

    public static void addRow(Map<String, String> row) {
        StringBuilder columns = new StringBuilder();
        StringBuilder values = new StringBuilder();
        ArrayList<Object> parameters = new ArrayList<>();

        for (Map.Entry<String, String> entry : row.entrySet()) {
            columns.append("\"").append(entry.getKey()).append("\",");
            values.append("?,");

            if (entry.getKey().equals("BIRTHDATE") || entry.getKey().equals("DEATHDATE")) {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    parameters.add(new Date(dateFormat.parse(entry.getValue()).getTime()));
                } catch (ParseException e) {
                    throw new RuntimeException(e);
                }
            } else {
                parameters.add(entry.getValue());
            }
        }

        // Remove the trailing commas
        columns.setLength(columns.length() - 1);
        values.setLength(values.length() - 1);

        String query = String.format("INSERT INTO patients (%s) VALUES (%s)", columns.toString(), values.toString());

        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            for (int i = 0; i < parameters.size(); i++) {
                pstmt.setObject(i + 1, parameters.get(i));
            }
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            throw new RuntimeException(e);
        }
    }

    public static void deleteRow(String id) {
        String query = "DELETE FROM patients WHERE \"ID\" = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setString(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Could not delete a row");
            throw new RuntimeException(e);
        }
    }
}
