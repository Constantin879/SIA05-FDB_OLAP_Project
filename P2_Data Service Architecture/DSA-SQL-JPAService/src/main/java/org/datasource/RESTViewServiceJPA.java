package org.datasource;


import org.datasource.springdata.views.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.logging.Logger;

/*	REST Service URL

	http://localhost:8091/DSA_SQL_JPAService/rest/ECOMMERCE/InteractionsView
	http://localhost:8091/DSA_SQL_JPAService/rest/ECOMMERCE/Interactions

	http://localhost:8091/DSA_SQL_JPAService/rest/ECOMMERCE/ProductsView
	http://localhost:8091/DSA_SQL_JPAService/rest/ECOMMERCE/Products
*/
@RestController
@RequestMapping("/ECOMMERCE")
public class RESTViewServiceJPA {
	private static Logger logger = Logger.getLogger(RESTViewServiceJPA.class.getName());
	
	@RequestMapping(value = "/ping", method = RequestMethod.GET,
			produces = {MediaType.TEXT_PLAIN_VALUE})
	@ResponseBody
	public String pingDataSource() {
		logger.info(">>>> DSA-SQL-JPAService:: RESTViewService is Up!");
		return "Ping response from DSA-SQL-JPAService!";
	}
	
	// Set-up
	@Autowired private JPADataSourceConnector dataSourceConnector;
	@Autowired private InteractionsViewRepository viewRepository;
	@Autowired private ProductsViewRepository productsViewRepository;
	//



	@RequestMapping(value = "/InteractionsView", method = RequestMethod.GET,
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<InteractionsView> getInteractionsView() {
		List<InteractionsView> viewList = this.viewRepository.getInteractionsViewList();
		return viewList;
	}

	@RequestMapping(value = "/Interactions", method = RequestMethod.GET,
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<Interactions> getInteractions() {
		List<Interactions> viewList = this.viewRepository.getInteractionsList();
		return viewList;
	}


	@RequestMapping(value = "/ProductsView", method = RequestMethod.GET,
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<ProductsView> getProductsView() {
		List<ProductsView> viewList = this.productsViewRepository.getProductsViewList();
//		List<ProductsView> viewList = this.productsViewRepository.findAll();
		return this.productsViewRepository.findAll();
		//return viewList;
	}

	@RequestMapping(value = "/Products", method = RequestMethod.GET,
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<ProductsView> getProducts() {
		return this.productsViewRepository.findAll();
	}
}