package ucl.ac.uk.models;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.ArrayList;
import java.util.HashMap;

public class JSONWriter {
    public static String createJSONFromModel(Model model) throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();

        ArrayList<HashMap<String, String>> data = new ArrayList<>();
        int rowCount = model.getRowCount();
        ArrayList<String> columnNames = model.getColumnNames();

        for (int row = 0; row < rowCount; row++) {
            HashMap<String, String> rowData = new HashMap<>();
            for (String columnName : columnNames) {
                rowData.put(columnName, model.getValue(columnName, row));
            }
            data.add(rowData);
        }

        HashMap<String, Object> jsonData = new HashMap<>();
        jsonData.put("data", data);

        return objectMapper.writeValueAsString(jsonData);
    }
}
