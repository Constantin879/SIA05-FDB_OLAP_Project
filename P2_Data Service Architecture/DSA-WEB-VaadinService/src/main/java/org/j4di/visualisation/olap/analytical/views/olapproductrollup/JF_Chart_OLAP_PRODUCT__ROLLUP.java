package org.j4di.visualisation.olap.analytical.views.olapproductrollup;

import com.vaadin.flow.component.html.H3;
import com.vaadin.flow.component.html.Image;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.router.PageTitle;
import com.vaadin.flow.router.Route;
import com.vaadin.flow.server.StreamResource;
import org.j4di.visualisation.MainView;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtils;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.renderer.category.BarRenderer;
import org.jfree.data.category.DefaultCategoryDataset;
import org.springframework.web.client.RestTemplate;

import java.awt.Color;
import java.io.ByteArrayInputStream;
import java.util.Map;

@PageTitle("Product Rollup Chart")
@Route(value = "product-rollup-chart", layout = MainView.class)
public class JF_Chart_OLAP_PRODUCT__ROLLUP extends VerticalLayout {

    private final String restURL = "http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/OLAP_PRODUCT_ROLLUP_VIEW";

    public JF_Chart_OLAP_PRODUCT__ROLLUP() {
        setSizeFull();
        setAlignItems(Alignment.CENTER);

        try {
            RestTemplate restTemplate = new RestTemplate();
            Map[] data = restTemplate.getForObject(restURL, Map[].class);

            if (data != null && data.length > 0) {
                DefaultCategoryDataset dataset = new DefaultCategoryDataset();
                int i = 1;

                for (Map row : data) {
                    String cat = String.valueOf(row.get("category"));

                    // 1. Sărim peste TOTAL (altfel restul barelor vor fi invizibile de mici)
                    if (cat.equalsIgnoreCase("TOTAL")) continue;

                    Number scor = (Number) row.get("scor_total");
                    String brand = String.valueOf(row.get("brand"));

                    // 2. ȘMECHERIA: Adăugăm un index (#1, #2) ca să forțăm bare separate
                    // Chiar dacă numele e "category", va desena bare diferite
                    dataset.addValue(scor, "Scor Produse", cat + " (" + brand + ") #" + (i++));
                }

                // 3. Creăm graficul
                JFreeChart chart = ChartFactory.createBarChart(
                        "Analiză Product Rollup",
                        "Categorii / Branduri",
                        "Scor Total",
                        dataset);

                // 4. Cosmetizare (să nu mai fie gri și urât)
                chart.setBackgroundPaint(Color.white);
                CategoryPlot plot = chart.getCategoryPlot();
                plot.setBackgroundPaint(Color.lightGray);
                plot.setRangeGridlinePaint(Color.white);

                // Schimbăm culoarea barelor în albastru (să nu mai fie doar roșu ăla bloc)
                BarRenderer renderer = (BarRenderer) plot.getRenderer();
                renderer.setSeriesPaint(0, new Color(79, 129, 189));

                // 5. Generare imagine
                byte[] imageData = ChartUtils.encodeAsPNG(chart.createBufferedImage(900, 500));
                StreamResource res = new StreamResource("chart.png", () -> new ByteArrayInputStream(imageData));

                Image img = new Image(res, "Grafic");
                add(new H3("Vizualizare Analitică - Scoruri pe Categorii"), img);
            }
        } catch (Exception e) {
            add(new H3("Eroare: " + e.getMessage()));
        }
    }
}
