package org.datasource;

import org.datasource.csv.reviews.ReviewsView;
import org.datasource.csv.reviews.ReviewsViewCSVViewBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.logging.Logger;


/*	REST Service URL
	http://localhost:8097/DSA-DOC-CSVService/rest/ecommerce/ReviewsView
*/
@RestController @RequestMapping("/ecommerce")
public class RESTViewServiceCSV {
	private static Logger logger = Logger.getLogger(RESTViewServiceCSV.class.getName());

	@RequestMapping(value = "/ReviewsView", method = RequestMethod.GET,
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<ReviewsView> get_CustomerEmployeesCategoryViewCSV() throws Exception {
		List<ReviewsView> viewList;
		if (this.csvViewBuilder.getViewList().isEmpty() == true)
			viewList = this.csvViewBuilder.build().getViewList();
		else
			viewList = this.csvViewBuilder.getViewList();
		return viewList;
	}

	// Set-up
	@Autowired private ReviewsViewCSVViewBuilder csvViewBuilder;
}