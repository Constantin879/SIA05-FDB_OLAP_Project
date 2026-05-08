package org.j4di.visualisation;

import com.vaadin.flow.component.Component;
import com.vaadin.flow.component.accordion.Accordion;
import com.vaadin.flow.component.applayout.AppLayout;
import com.vaadin.flow.component.applayout.DrawerToggle;
import com.vaadin.flow.component.html.H1;
import com.vaadin.flow.component.html.Span;
import com.vaadin.flow.component.icon.Icon;
import com.vaadin.flow.component.icon.VaadinIcon;
import com.vaadin.flow.component.orderedlayout.FlexComponent;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.component.tabs.Tab;
import com.vaadin.flow.component.tabs.Tabs;
import com.vaadin.flow.router.BeforeEnterEvent;
import com.vaadin.flow.router.BeforeEnterObserver;
import com.vaadin.flow.router.Route;
import com.vaadin.flow.router.RouterLink;

// --- IMPORTUL PENTRU DASHBOARD ---
import org.j4di.visualisation.dashboard.MainDashboard;


// --- IMPORTUL PENTRU DATASOURCES ---
import org.j4di.visualisation.datasources.interactions.GridData_INTERACTIONS;
import org.j4di.visualisation.datasources.products.GridData_PRODUCTS;
import org.j4di.visualisation.datasources.userprofile.GridData_USERPROFILE;
import org.j4di.visualisation.datasources.reviews.GridData_REVIEWS;

// --- IMPORTUL PENTRU MULTIDIMENSIONAL ---
import org.j4di.visualisation.integration.views.dimproductfull.GridData_DIM_PRODUCT_FULL;
import org.j4di.visualisation.integration.views.factproductreviews.GridData_FACT_PRODUCT_REVIEWS;
import org.j4di.visualisation.integration.views.vwconsolidarefullanalysis.GridData_VW_CONSOLIDARE_FULL_ANALYSYS;

// --- IMPORTUL PENTRU ANALYTICS ---
import org.j4di.visualisation.olap.analytical.views.full_segment.GridData_OLAP_FULL_SEGMENT_CATEGORY_EVENT;
import org.j4di.visualisation.olap.analytical.views.olapproductrollup.JF_Chart_OLAP_PRODUCT__ROLLUP;
import org.j4di.visualisation.olap.analytical.views.olapsegment.GridData_OLAP_SEGMENT_CATEGORY_REVIEWS;





@Route("") // Aceasta este ruta principala
public class MainView extends AppLayout implements BeforeEnterObserver {

    public MainView() {
        HorizontalLayout header = createHeader();
        addToNavbar(header);

        // Setează lățimea drawer-ului (meniul lateral)
        getElement().getStyle().set("--vaadin-app-layout-drawer-width", "380px");

        addToDrawer(createAccordion());


        VerticalLayout layoutPrincipal = new VerticalLayout(new MainDashboard());
        layoutPrincipal.setSizeFull();
        layoutPrincipal.setPadding(true);
        layoutPrincipal.setAlignItems(FlexComponent.Alignment.CENTER);

        setContent(layoutPrincipal);

    }

    private HorizontalLayout createHeader() {
        H1 title = new H1("DSA Visualization APP");
        title.getStyle().set("font-size", "var(--lumo-font-size-l)").set("margin", "0");

        HorizontalLayout header = new HorizontalLayout(new DrawerToggle(), title);
        header.setDefaultVerticalComponentAlignment(FlexComponent.Alignment.CENTER);
        header.setWidth("100%");
        return header;
    }

    private Tab createTab(VaadinIcon viewIcon, String viewName, Class<? extends Component> viewClass) {
        Icon icon = viewIcon.create();
        icon.getStyle().set("box-sizing", "border-box")
                .set("margin-inline-end", "var(--lumo-space-m)")
                .set("margin-inline-start", "var(--lumo-space-xs)")
                .set("padding", "var(--lumo-space-xs)");

        RouterLink link = new RouterLink();
        link.add(icon, new Span(viewName));
        link.setRoute(viewClass);
        link.setTabIndex(-1);

        return new Tab(link);
    }



    private Accordion createAccordion() {
        Accordion accordion = new Accordion();

        // Section: Home
        Tabs tabsHome = new Tabs();


        tabsHome.add(createTab(VaadinIcon.DASHBOARD, "Main Dashboard", MainDashboard.class));

        tabsHome.setOrientation(Tabs.Orientation.VERTICAL);
        accordion.add("Home", tabsHome);





        // Section: Data Source Access
        Tabs tabsDataSources = new Tabs();

        tabsDataSources.add(createTab(VaadinIcon.DATABASE, "Interactions View", GridData_INTERACTIONS.class));
        tabsDataSources.add(createTab(VaadinIcon.PACKAGE, "Products View", GridData_PRODUCTS.class));
        tabsDataSources.add(createTab(VaadinIcon.USER_CARD, "User Profiles", GridData_USERPROFILE.class));
        tabsDataSources.add(createTab(VaadinIcon.COMMENT, "Reviews", GridData_REVIEWS.class));

        tabsDataSources.setOrientation(Tabs.Orientation.VERTICAL);
        accordion.add("Data Source Access", tabsDataSources);



        // Section: Multidimensional Model
        Tabs tabsMultidimensional = new Tabs();

        tabsMultidimensional.add(createTab(VaadinIcon.SITEMAP, "Dim Product Full", GridData_DIM_PRODUCT_FULL.class));
        tabsMultidimensional.add(createTab(VaadinIcon.TABLE, "Fact Product Reviews", GridData_FACT_PRODUCT_REVIEWS.class));
        tabsMultidimensional.add(createTab(VaadinIcon.CHART_3D, "Consolidare Full Analysis", GridData_VW_CONSOLIDARE_FULL_ANALYSYS.class));

        tabsMultidimensional.setOrientation(Tabs.Orientation.VERTICAL);
        accordion.add("Multidimensional Model", tabsMultidimensional);



        // Section: Analytics
        Tabs tabsDashboard = new Tabs();

        tabsDashboard.add(createTab(VaadinIcon.VIEWPORT, "FULL SEGMENT ANALYSIS (GRID)", GridData_OLAP_FULL_SEGMENT_CATEGORY_EVENT.class));
        tabsDashboard.add(createTab(VaadinIcon.BAR_CHART, "Product Rollup Chart", JF_Chart_OLAP_PRODUCT__ROLLUP.class));
        tabsDashboard.add(createTab(VaadinIcon.LIST_SELECT, "Segment Category Reviews", GridData_OLAP_SEGMENT_CATEGORY_REVIEWS.class));

        tabsDashboard.setOrientation(Tabs.Orientation.VERTICAL);
        accordion.add("Analytics", tabsDashboard);

        return accordion;
    }

    @Override
    public void beforeEnter(BeforeEnterEvent event) {
        // Basic security check could go here
    }
}


/*LINK DASHBOARD
--http://localhost:9080/
 */