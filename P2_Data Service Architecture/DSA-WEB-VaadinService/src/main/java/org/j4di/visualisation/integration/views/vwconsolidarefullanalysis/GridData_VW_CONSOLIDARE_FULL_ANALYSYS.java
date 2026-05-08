package org.j4di.visualisation.integration.views.vwconsolidarefullanalysis;

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

@PageTitle("Consolidare Full Analysis")
@Route(value = "consolidare-full-analysis", layout = MainView.class)
public class GridData_VW_CONSOLIDARE_FULL_ANALYSYS extends VerticalLayout {

    // URL-ul catre endpoint-ul de consolidare din Backend
    private final String restURL = "http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/VW_CONSOLIDARE_FULL_ANALYSIS_VIEW";

    public GridData_VW_CONSOLIDARE_FULL_ANALYSYS() {
        setSizeFull();
        setSpacing(true);
        setPadding(true);

        try {
            RestTemplate restTemplate = new RestTemplate();
            Map[] data = restTemplate.getForObject(restURL, Map[].class);

            if (data != null && data.length > 0) {
                List<Map<String, Object>> dataList = Arrays.asList((Map<String, Object>[]) data);
                Grid<Map<String, Object>> grid = new Grid<>();

                // Generare automata coloane (ID, Segment, Categorie, Scor, Review-uri etc.)
                Map<String, Object> firstRow = dataList.get(0);
                for (String key : firstRow.keySet()) {
                    grid.addColumn(row -> row.get(key))
                            .setHeader(key.toUpperCase().replace("_", " "))
                            .setSortable(true)
                            .setResizable(true);
                }

                grid.setItems(dataList);
                grid.setSizeFull();

                // Titlu profesional conform stilului ales de tine
                add(new H3("Raport Consolidat: Analiză Full (Multi-Source Integration)"), grid);
            } else {
                add(new H3("Nu s-au găsit date în VW_CONSOLIDARE_FULL_ANALYSIS."));
            }

        } catch (Exception e) {
            add(new H3("EROARE: Nu s-a putut genera raportul de consolidare."));
            add(new Span("Detalii sistem: " + e.getMessage()));
        }
    }
}