package org.j4di.visualisation.dashboard;

import com.vaadin.flow.component.html.H2;
import com.vaadin.flow.component.html.H3;
import com.vaadin.flow.component.html.Span;
import com.vaadin.flow.component.icon.Icon;
import com.vaadin.flow.component.icon.VaadinIcon;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.router.PageTitle;
import com.vaadin.flow.router.Route;
import org.j4di.visualisation.MainView;

@PageTitle("Main Dashboard")
@Route(value = "main-dashboard", layout = MainView.class)
public class MainDashboard extends VerticalLayout {

    public MainDashboard() {
        setSizeFull();
        setPadding(true);
        setSpacing(true);
        getStyle().set("background-color", "#f8f9fa"); // Un gri foarte deschis pe fundal
        setAlignItems(Alignment.CENTER);

        // 1. Titlu cu distanțare mare sus
        H2 title = new H2("Panou de Control - DSA Data Analytics");
        title.getStyle().set("margin-top", "50px");
        title.getStyle().set("margin-bottom", "40px");
        title.getStyle().set("color", "#2c3e50");
        add(title);

        // 2. Primul rând de carduri (KPI-uri principale)
        HorizontalLayout row1 = new HorizontalLayout();
        row1.setWidth("90%"); // Să se întindă pe ecran
        row1.setJustifyContentMode(JustifyContentMode.CENTER);
        row1.setSpacing(true);
        row1.getStyle().set("gap", "30px"); // Distanță între carduri

        row1.add(
                createEnhancedCard("TRAFFIC", "1.4M", VaadinIcon.LINE_CHART, "#3498db", "Total Events"),
                createEnhancedCard("REVIEWS", "15.2K", VaadinIcon.COMMENTS, "#2ecc71", "Customer Feedback"),
                createEnhancedCard("RATING", "4.8 / 5", VaadinIcon.STAR, "#f1c40f", "Average Score")
        );

        // 3. Al doilea rând de carduri (Alte statistici)
        HorizontalLayout row2 = new HorizontalLayout();
        row2.setWidth("90%");
        row2.setJustifyContentMode(JustifyContentMode.CENTER);
        row2.setSpacing(true);
        row2.getStyle().set("margin-top", "30px"); // Distanță între rânduri
        row2.getStyle().set("gap", "30px");

        row2.add(
                createEnhancedCard("PRODUCTS", "240", VaadinIcon.PACKAGE, "#e67e22", "Unique Items"),
                createEnhancedCard("USERS", "8.5K", VaadinIcon.USERS, "#9b59b6", "Registered Profiles"),
                createEnhancedCard("SYSTEM", "ONLINE", VaadinIcon.SERVER, "#e74c3c", "Spark Connection")
        );

        add(row1, row2);

        // 4. Footer informativ
        Span footer = new Span("Ultima actualizare: " + java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm")));
        footer.getStyle().set("margin-top", "60px").set("color", "#7f8c8d").set("font-style", "italic");
        add(footer);
    }

    private VerticalLayout createEnhancedCard(String title, String value, VaadinIcon iconType, String color, String subtitle) {
        VerticalLayout card = new VerticalLayout();
        card.setWidth("320px");
        card.setHeight("200px");
        card.setPadding(true);
        card.setSpacing(false);
        card.setAlignItems(Alignment.CENTER);
        card.setJustifyContentMode(JustifyContentMode.CENTER);

        // Stilul cardului: umbră, margini rotunjite și bordură colorată sus
        card.getStyle().set("background-color", "white");
        card.getStyle().set("border-radius", "15px");
        card.getStyle().set("box-shadow", "0 10px 20px rgba(0,0,0,0.05)");
        card.getStyle().set("border-top", "6px solid " + color);

        Icon icon = iconType.create();
        icon.setColor(color);
        icon.setSize("35px");

        Span t = new Span(title);
        t.getStyle().set("font-weight", "bold").set("font-size", "0.9em").set("color", "#7f8c8d");

        H3 v = new H3(value);
        v.getStyle().set("margin", "10px 0").set("font-size", "2em");

        Span s = new Span(subtitle);
        s.getStyle().set("font-size", "0.8em").set("color", "#bdc3c7");

        card.add(icon, t, v, s);
        return card;
    }
}
