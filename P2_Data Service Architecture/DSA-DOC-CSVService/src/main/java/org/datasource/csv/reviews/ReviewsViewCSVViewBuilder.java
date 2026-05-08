package org.datasource.csv.reviews;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVRecord;
import org.datasource.csv.CSVResourceFileDataSourceConnector;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

@Service
public class ReviewsViewCSVViewBuilder {

    private List<ReviewsView> viewList = new java.util.ArrayList<>();

    public List<ReviewsView> getViewList() {
        return viewList;
    }

    private CSVResourceFileDataSourceConnector dataSourceConnector;
    private File csvFile;

    public ReviewsViewCSVViewBuilder(CSVResourceFileDataSourceConnector dataSourceConnector) throws Exception {
        this.dataSourceConnector = dataSourceConnector;
        csvFile = dataSourceConnector.getCSVFile();
    }

    // Builder Workflow
    public ReviewsViewCSVViewBuilder build() throws Exception{
        Reader in = new FileReader(this.csvFile);
        CSVFormat format = CSVFormat.DEFAULT.withFirstRecordAsHeader().withDelimiter(',');
        Iterable<CSVRecord> records = format.parse(in);
        viewList = new ArrayList<>();
        for (CSVRecord record : records) {
            this.viewList.add(new ReviewsView(
                        Long.parseLong(record.get("review_id")),
                        Long.parseLong(record.get("user_id")),
                        Long.parseLong(record.get("product_id")),
                        Long.parseLong(record.get("rating")),
                        record.get("review_text"),
                        record.get("review_date")
                    )
            );
        }
        //
        return this;
    }
}

/*
this.viewList.add(new CustomerCategoryView(
                        record.get(0),
                        record.get(1),
                        Double.parseDouble(record.get(2)),
                        Double.parseDouble(record.get(3))
                    )
            );
 */