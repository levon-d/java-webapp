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

    public DataLoaderPostgres() {
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
            throw new RuntimeException(e);
        }
        return new DataFrame(columns);
    }

    public static void editRow(String id, String columnName, String newValue) {

        String query = "UPDATE patients SET ? = ? WHERE id = ?";
        Date formattedValue = null;

        if (columnName.equals("birth_date") | columnName.equals("death_date")) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); // Format for converting date strings
            try {
                formattedValue = new Date(dateFormat.parse(newValue).getTime());
            } catch (ParseException e) {
                throw new RuntimeException(e);
            }
        }

        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setString(1, columnName);

            if (formattedValue == null) {
                pstmt.setString(2, newValue);
            } else {
                pstmt.setDate(2, formattedValue);
            }

            pstmt.setString(3, id);
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
            columns.append(entry.getKey()).append(",");
            values.append("?,");

            if (entry.getKey().equals("birth_date") || entry.getKey().equals("death_date")) {
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
            throw new RuntimeException(e);
        }
    }

    public static void deleteRow(String id) {
        String query = String.format("DELETE FROM PATIENTS WHERE ID=%s", id);

        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
           pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Could not delete a row");
            throw new RuntimeException(e);
        }
    }
}
