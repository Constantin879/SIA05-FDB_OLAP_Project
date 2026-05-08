package org.j4di.visualisation.integration.views.factproductreviews;

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

@PageTitle("Fact Product Reviews")
@Route(value = "fact-product-reviews", layout = MainView.class)
public class GridData_FACT_PRODUCT_REVIEWS extends VerticalLayout {

    // URL-ul catre endpoint-ul de FACT din Backend-ul tau
    private final String restURL = "http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/FACT_PRODUCT_REVIEWS_VIEW";

    public GridData_FACT_PRODUCT_REVIEWS() {
        setSizeFull();
        setSpacing(true);
        setPadding(true);

        try {
            RestTemplate restTemplate = new RestTemplate();
            Map[] data = restTemplate.getForObject(restURL, Map[].class);

            if (data != null && data.length > 0) {
                List<Map<String, Object>> dataList = Arrays.asList((Map<String, Object>[]) data);
                Grid<Map<String, Object>> grid = new Grid<>();

                // Generare automata a coloanelor din campurile JSON-ului (product_id, review_id, rating, etc.)
                Map<String, Object> firstRow = dataList.get(0);
                for (String key : firstRow.keySet()) {
                    grid.addColumn(row -> row.get(key))
                            .setHeader(key.toUpperCase().replace("_", " "))
                            .setSortable(true)
                            .setResizable(true);
                }

                grid.setItems(dataList);
                grid.setSizeFull();

                // Titlu in stilul celui de la Segment Category Reviews (poza 2)
                add(new H3("Vizualizare Tabel Fact: Product Reviews Metrics"), grid);
            } else {
                add(new H3("Nu s-au găsit date în FACT_PRODUCT_REVIEWS."));
            }

        } catch (Exception e) {
            add(new H3("EROARE: Conexiune eșuată la sursa FACT_PRODUCT_REVIEWS"));
            add(new Span("Detalii eroare: " + e.getMessage()));
        }
    }
}
