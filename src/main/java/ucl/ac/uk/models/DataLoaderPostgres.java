package ucl.ac.uk.models;

import ucl.ac.uk.db.DB;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DataLoaderPostgres {

    public static DataFrame loadPostgresData() {

        ArrayList<Column> columns = new ArrayList<>();
        String query = "SELECT * FROM patients";

        try (Connection connection = DB.connect();
             PreparedStatement pstmt = connection.prepareStatement(query);
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
            throw new RuntimeException(e);
        }
        return new DataFrame(columns);
    }
}
