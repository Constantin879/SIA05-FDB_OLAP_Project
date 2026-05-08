package org.j4di.visualisation.datasources.products;

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

@PageTitle("Products Data")
@Route(value = "products-view-all", layout = MainView.class) // Ruta pentru browser
public class GridData_PRODUCTS extends VerticalLayout {

    // URL-ul catre serviciul tau REST pentru Produse
    private final String restDataServiceURL = "http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/PRODUCTS_VIEW";

    public GridData_PRODUCTS() {
        setSizeFull();
        setSpacing(true);

        try {
            RestTemplate restTemplate = new RestTemplate();
            // Preluam datele sub forma de Array de Map-uri
            Map[] data = restTemplate.getForObject(restDataServiceURL, Map[].class);

            if (data != null && data.length > 0) {
                List<Map<String, Object>> dataList = Arrays.asList((Map<String, Object>[]) data);
                Grid<Map<String, Object>> grid = new Grid<>();

                // Generare AUTOMATA a coloanelor
                Map<String, Object> firstRecord = dataList.get(0);
                for (String key : firstRecord.keySet()) {
                    grid.addColumn(row -> row.get(key))
                            .setHeader(key.toUpperCase())
                            .setSortable(true)
                            .setResizable(true);
                }

                grid.setItems(dataList);
                add(new H3("Sursa Date: PRODUCTS (" + dataList.size() + " produse)"), grid);
            } else {
                add(new H3("Nu s-au gasit date in PRODUCTS_VIEW."));
            }

        } catch (Exception e) {
            add(new H3("EROARE: Nu s-a putut accesa PRODUCTS_VIEW la portul 8096"));
            add(new Span("Verifica daca serviciul REST este pornit: " + e.getMessage()));
        }
    }
}
