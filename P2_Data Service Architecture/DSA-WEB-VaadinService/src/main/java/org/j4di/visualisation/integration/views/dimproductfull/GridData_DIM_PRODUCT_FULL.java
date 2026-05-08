
package org.j4di.visualisation.integration.views.dimproductfull;

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

@PageTitle("Dimension Product Full")
@Route(value = "dim-product-full", layout = MainView.class)
public class GridData_DIM_PRODUCT_FULL extends VerticalLayout {

    // Adresa URL din Backend-ul tau (8096)
    private final String restURL = "http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/DIM_PRODUCT_FULL_VIEW";

    public GridData_DIM_PRODUCT_FULL() {
        setSizeFull();
        setSpacing(true);
        setPadding(true);

        try {
            RestTemplate restTemplate = new RestTemplate();
            Map[] data = restTemplate.getForObject(restURL, Map[].class);

            if (data != null && data.length > 0) {
                List<Map<String, Object>> dataList = Arrays.asList((Map<String, Object>[]) data);
                Grid<Map<String, Object>> grid = new Grid<>();

                // Generare coloane automata pe baza cheilor din JSON (product_id, name, etc.)
                Map<String, Object> firstRow = dataList.get(0);
                for (String key : firstRow.keySet()) {
                    grid.addColumn(row -> row.get(key))
                            .setHeader(key.toUpperCase().replace("_", " "))
                            .setSortable(true)
                            .setResizable(true);
                }

                grid.setItems(dataList);
                grid.setSizeFull();

                // Titlu curat, fix cum iti place tie
                add(new H3("Vizualizare Dimensiune: Product Full Details"), grid);
            } else {
                add(new H3("Nu s-au găsit date în DIM_PRODUCT_FULL."));
            }

        } catch (Exception e) {
            add(new H3("EROARE: Nu s-a putut accesa sursa DIM_PRODUCT_FULL"));
            add(new Span("Detalii: " + e.getMessage()));
        }
    }
}
