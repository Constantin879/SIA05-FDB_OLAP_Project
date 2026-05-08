package org.j4di.visualisation.datasources.interactions;

import com.vaadin.flow.component.grid.Grid;
import com.vaadin.flow.component.html.H3;
import com.vaadin.flow.component.html.Span;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.router.PageTitle;
import com.vaadin.flow.router.Route;
import org.j4di.visualisation.MainView;
import org.springframework.web.client.RestTemplate;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

@PageTitle("Interactions Data")
// RUTA pe care o vei folosi in MainView
@Route(value = "interactions-view", layout = MainView.class)
public class GridData_INTERACTIONS extends VerticalLayout {

    private final String restDataServiceURL = "http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/INTERACTIONS_VIEW";

    public GridData_INTERACTIONS() {
        setSizeFull();
        setSpacing(true);

        try {
            RestTemplate restTemplate = new RestTemplate();
            // Citim datele ca un Array de Map-uri (Generic JSON mapping)
            Map[] data = restTemplate.getForObject(restDataServiceURL, Map[].class);

            if (data != null && data.length > 0) {
                // Convertim array-ul in lista pentru Vaadin Grid
                List<Map<String, Object>> dataList = Arrays.asList((Map<String, Object>[]) data);

                // Cream Grid-ul
                Grid<Map<String, Object>> grid = new Grid<>();

                // GENERARE AUTOMATA COLOANE:
                // Luam prima inregistrare si cream cate o coloana pentru fiecare cheie din JSON
                Map<String, Object> firstRecord = dataList.get(0);
                for (String columnName : firstRecord.keySet()) {
                    grid.addColumn(row -> row.get(columnName))
                            .setHeader(columnName.toUpperCase())
                            .setSortable(true)
                            .setResizable(true);
                }

                grid.setItems(dataList);
                add(new H3("Sursa Date: INTERACTIONS (" + dataList.size() + " înregistrări)"), grid);
            } else {
                add(new H3("Serviciul REST a răspuns, dar nu există date în INTERACTIONS_VIEW."));
            }

        } catch (Exception e) {
            add(new H3("EROARE: Nu s-a putut accesa INTERACTIONS_VIEW la portul 8096"));
            add(new Span("Detalii: " + e.getMessage()));
        }
    }
}
