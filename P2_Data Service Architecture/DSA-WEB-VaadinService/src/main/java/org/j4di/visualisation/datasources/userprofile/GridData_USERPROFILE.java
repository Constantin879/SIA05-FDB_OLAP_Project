package org.j4di.visualisation.datasources.userprofile;

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

@PageTitle("User Profiles")
@Route(value = "user-profiles-view", layout = MainView.class)
public class GridData_USERPROFILE extends VerticalLayout {

    // URL-ul catre serviciul REST pentru Profile Utilizatori
    private final String restDataServiceURL = "http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/USERPROFILE_VIEW";

    public GridData_USERPROFILE() {
        setSizeFull();
        setSpacing(true);

        try {
            RestTemplate restTemplate = new RestTemplate();
            Map[] data = restTemplate.getForObject(restDataServiceURL, Map[].class);

            if (data != null && data.length > 0) {
                List<Map<String, Object>> dataList = Arrays.asList((Map<String, Object>[]) data);
                Grid<Map<String, Object>> grid = new Grid<>();

                // Generare coloane automata
                Map<String, Object> firstRecord = dataList.get(0);
                for (String key : firstRecord.keySet()) {
                    grid.addColumn(row -> row.get(key))
                            .setHeader(key.toUpperCase().replace("_", " "))
                            .setSortable(true)
                            .setResizable(true);
                }

                grid.setItems(dataList);
                add(new H3("Sursa Date: USER PROFILES (" + dataList.size() + " înregistrări)"), grid);
            } else {
                add(new H3("Nu s-au găsit date în USERPROFILE_VIEW."));
            }

        } catch (Exception e) {
            add(new H3("EROARE: Conexiune eșuată la portul 8096"));
            add(new Span("Detalii: " + e.getMessage()));
        }
    }
}