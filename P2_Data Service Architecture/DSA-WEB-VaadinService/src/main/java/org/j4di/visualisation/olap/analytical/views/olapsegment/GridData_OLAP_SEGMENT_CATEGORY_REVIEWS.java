package org.j4di.visualisation.olap.analytical.views.olapsegment;

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

@PageTitle("OLAP Segment Category Reviews")
@Route(value = "olap-segment-category-reviews", layout = MainView.class)
public class GridData_OLAP_SEGMENT_CATEGORY_REVIEWS extends VerticalLayout {

    // URL-ul catre endpoint-ul tau de OLAP din Backend
    private final String restDataServiceURL = "http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/OLAP_SEGMENT_CATEGORY_REVIEWS";

    public GridData_OLAP_SEGMENT_CATEGORY_REVIEWS() {
        setSizeFull();
        setSpacing(true);

        try {
            RestTemplate restTemplate = new RestTemplate();
            Map[] data = restTemplate.getForObject(restDataServiceURL, Map[].class);

            if (data != null && data.length > 0) {
                List<Map<String, Object>> dataList = Arrays.asList((Map<String, Object>[]) data);
                Grid<Map<String, Object>> grid = new Grid<>();

                // Generăm coloanele automat pe baza cheilor din JSON (category, total_reviews, etc.)
                Map<String, Object> firstRow = dataList.get(0);
                for (String key : firstRow.keySet()) {
                    grid.addColumn(row -> row.get(key))
                            .setHeader(key.toUpperCase().replace("_", " "))
                            .setSortable(true)
                            .setResizable(true);
                }

                grid.setItems(dataList);

                add(new H3("Analiză Segment: Review-uri pe Categorii"), grid);
            } else {
                add(new H3("Nu s-au găsit date în OLAP_SEGMENT_CATEGORY_REVIEWS_VIEW."));
            }

        } catch (Exception e) {
            add(new H3("EROARE REST: Verificați dacă Backend-ul (8096) este pornit."));
            add(new Span("Detalii: " + e.getMessage()));
        }
    }
}
