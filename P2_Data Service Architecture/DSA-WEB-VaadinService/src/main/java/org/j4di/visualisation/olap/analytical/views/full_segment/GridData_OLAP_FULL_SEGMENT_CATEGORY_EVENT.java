package org.j4di.visualisation.olap.analytical.views.full_segment;

import com.vaadin.flow.component.grid.Grid;
import com.vaadin.flow.component.html.H3;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.router.PageTitle;
import com.vaadin.flow.router.Route;
import org.j4di.visualisation.MainView;
import org.springframework.web.client.RestTemplate;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;

record OLAP_FULL_RECORD(
        String segment,
        String category,
        String event_type,
        Object scor_total,
        Object total_reviews,
        Object rating_mediu
) { }

@PageTitle("Full Segment Analysis")
@Route(value = "full-segment-analysis", layout = MainView.class)
public class GridData_OLAP_FULL_SEGMENT_CATEGORY_EVENT extends VerticalLayout {

    private final String restDataServiceURL = "http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/OLAP_FULL_SEGMENT_CATEGORY_EVENT_VIEW";

    public GridData_OLAP_FULL_SEGMENT_CATEGORY_EVENT() {
        setSizeFull();
        setSpacing(true); // Pune distanță între titlu și grid
        setPadding(true); // Nu lasă tabelul să fie lipit de marginile ecranului

        Grid<OLAP_FULL_RECORD> dataGrid = new Grid<>(OLAP_FULL_RECORD.class, false);

        List<OLAP_FULL_RECORD> data = getRESTData();

        // Configurarea coloanelor cu titluri curate
        dataGrid.addColumn(OLAP_FULL_RECORD::segment).setHeader("SEGMENT").setSortable(true);
        dataGrid.addColumn(OLAP_FULL_RECORD::category).setHeader("CATEGORY").setSortable(true);
        dataGrid.addColumn(OLAP_FULL_RECORD::event_type).setHeader("EVENT TYPE").setSortable(true);
        dataGrid.addColumn(OLAP_FULL_RECORD::scor_total).setHeader("SCOR").setSortable(true);

        if (data.isEmpty()) {
            add(new H3("Sursă Date: Full Segment Analysis (Nicio înregistrare găsită)"));
        } else {
            dataGrid.setItems(data);
            dataGrid.setSizeFull(); // Forțează grid-ul să se întindă pe restul paginii

            // Aici e titlul curat pe care l-ai cerut
            add(new H3("Analiză Segment: Distribuție Evenimente pe Categorii"), dataGrid);
        }
    }

    private List<OLAP_FULL_RECORD> getRESTData() {
        try {
            RestTemplate restTemplate = new RestTemplate();
            OLAP_FULL_RECORD[] res = restTemplate.getForObject(restDataServiceURL, OLAP_FULL_RECORD[].class);
            return (res != null) ? Arrays.asList(res) : new ArrayList<>();
        } catch (Exception e) {
            System.err.println("EROARE FETCH: " + e.getMessage());
            return new ArrayList<>();
        }
    }
}
