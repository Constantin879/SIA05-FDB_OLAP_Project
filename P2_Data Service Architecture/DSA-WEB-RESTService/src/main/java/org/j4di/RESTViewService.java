package org.j4di;

import org.j4di.access.views.interactions.INTERACTIONS_VIEW;
import org.j4di.access.views.interactions.INTERACTIONS_VIEW_Repository;
import org.j4di.access.views.products.PRODUCTS_VIEW;
import org.j4di.access.views.products.PRODUCTS_VIEW_Repository;
import org.j4di.access.views.reviews.REVIEWS_VIEW;
import org.j4di.access.views.reviews.REVIEWS_VIEW_Repository;
import org.j4di.access.views.userprofile.USERPROFILE_VIEW;
import org.j4di.analytical.views.olapfullsegmentcategoryevent.OLAP_FULL_SEGMENT_CATEGORY_EVENT_VIEW;
import org.j4di.analytical.views.olapfullsegmentcategoryevent.OLAP_FULL_SEGMENT_CATEGORY_EVENT_VIEW_Repository;
import org.j4di.analytical.views.olapsegment.OLAP_SEGMENT_CATEGORY_REVIEWS;
import org.j4di.analytical.views.olapsegment.OLAP_SEGMENT_CATEGORY_REVIEWS_Repository;
import org.j4di.analytical.views.olapproductrollup.OLAP_PRODUCT_ROLLUP_VIEW;
import org.j4di.analytical.views.olapproductrollup.OLAP_PRODUCT_ROLLUP_VIEW_Repository;
import org.j4di.access.views.userprofile.USERPROFILE_VIEW_Repository;
import org.j4di.integration.views.dimproductfull.DIM_PRODUCT_FULL_VIEW;
import org.j4di.integration.views.dimproductfull.DIM_PRODUCT_FULL_VIEW_Repository;
import org.j4di.integration.views.factproductreviews.FACT_PRODUCT_REVIEWS_VIEW;
import org.j4di.integration.views.factproductreviews.FACT_PRODUCT_REVIEWS_VIEW_Repository;
import org.j4di.integration.views.vwconsolidarefullanalysis.VW_CONSOLIDARE_FULL_ANALYSIS_VIEW;
import org.j4di.integration.views.vwconsolidarefullanalysis.VW_CONSOLIDARE_FULL_ANALYSIS_VIEW_Repository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.logging.Logger;

/*	REST Service URL
--access
	http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/PRODUCTS_VIEW
	http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/INTERACTIONS_VIEW
	http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/USERPROFILE_VIEW
	http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/REVIEWS_VIEW
--analytical
	http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/OLAP_SEGMENT_CATEGORY_REVIEWS
	http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/OLAP_PRODUCT_ROLLUP_VIEW
	http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/OLAP_FULL_SEGMENT_CATEGORY_EVENT_VIEW
--integration
	http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/VW_CONSOLIDARE_FULL_ANALYSIS_VIEW
	http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/FACT_PRODUCT_REVIEWS_VIEW
	http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/DIM_PRODUCT_FULL_VIEW


*/
@RestController
@RequestMapping("/OLAP")
public class RESTViewService {
	private static Logger logger = Logger.getLogger(RESTViewService.class.getName());
	
	@RequestMapping(value = "/ping", method = RequestMethod.GET,
			produces = {MediaType.TEXT_PLAIN_VALUE})
	@ResponseBody
	public String pingDataSource() {
		logger.info(">>>> DSA-WEB-SparkService:: RESTViewService is Up!");
		return "Ping response from DSA-WEB-SparkService!";
	}



	@Autowired private PRODUCTS_VIEW_Repository PRODUCTS_VIEW_Repository;
	@CrossOrigin(origins = "*")
	@GetMapping(value = "/PRODUCTS_VIEW",
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<PRODUCTS_VIEW> get_PRODUCTS_VIEW() {
		List<PRODUCTS_VIEW> viewList =
				//this.invoiceViewRepository.findAll(); // NOT Working
				this.PRODUCTS_VIEW_Repository.get_PRODUCTS_VIEW();
		return viewList;
	}


	@Autowired private INTERACTIONS_VIEW_Repository INTERACTIONS_VIEW_Repository;
	@CrossOrigin(origins = "*")
	@GetMapping(value = "/INTERACTIONS_VIEW",
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<INTERACTIONS_VIEW> get_INTERACTIONS_VIEW() {
		List<INTERACTIONS_VIEW> viewList =
				//this.invoiceViewRepository.findAll(); // NOT Working
				this.INTERACTIONS_VIEW_Repository.get_INTERACTIONS_VIEW();
		return viewList;
	}




	@Autowired
	private USERPROFILE_VIEW_Repository userprofileRepository;
	@CrossOrigin(origins = "*")
	@GetMapping(value = "/USERPROFILE_VIEW",
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<USERPROFILE_VIEW> get_USERPROFILE_VIEW() {
		return this.userprofileRepository.get_USERPROFILE_VIEW();
	}


	@Autowired
	private REVIEWS_VIEW_Repository reviewsRepository;
	@CrossOrigin(origins = "*")
	@GetMapping(value = "/REVIEWS_VIEW",
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<REVIEWS_VIEW> get_REVIEWS_VIEW() {
		return this.reviewsRepository.get_REVIEWS_VIEW();
	}

	@Autowired
	private OLAP_SEGMENT_CATEGORY_REVIEWS_Repository olapSegmentRepository;
	@CrossOrigin(origins = "*")
	@GetMapping(value = "/OLAP_SEGMENT_CATEGORY_REVIEWS", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<OLAP_SEGMENT_CATEGORY_REVIEWS> get_OLAP_SEGMENT_VIEW() {
		return this.olapSegmentRepository.get_OLAP_SEGMENT_CATEGORY_REVIEWS();
	}

	@Autowired
	private OLAP_PRODUCT_ROLLUP_VIEW_Repository productRollupRepository;
	@CrossOrigin(origins = "*")
	@GetMapping(value = "/OLAP_PRODUCT_ROLLUP_VIEW", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<OLAP_PRODUCT_ROLLUP_VIEW> get_OLAP_PRODUCT_ROLLUP_VIEW() {
		return this.productRollupRepository.get_OLAP_PRODUCT_ROLLUP_VIEW();
	}

	@Autowired
	private OLAP_FULL_SEGMENT_CATEGORY_EVENT_VIEW_Repository olapFullRepo;
	@CrossOrigin(origins = "*")
	@GetMapping(value = "/OLAP_FULL_SEGMENT_CATEGORY_EVENT_VIEW", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<OLAP_FULL_SEGMENT_CATEGORY_EVENT_VIEW> get_OLAP_FULL_SEGMENT_CATEGORY_EVENT_VIEW() {
		// Apelăm exact metoda pe care o ai tu în Repo:
		return this.olapFullRepo.get_OLAP_FULL_SEGMENT_CATEGORY_EVENT_VIEW();
	}

	@Autowired
	private VW_CONSOLIDARE_FULL_ANALYSIS_VIEW_Repository vwConsolidareFullAnalysisViewRepository;
	@CrossOrigin(origins = "*")
	@GetMapping(value = "/VW_CONSOLIDARE_FULL_ANALYSIS_VIEW", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<VW_CONSOLIDARE_FULL_ANALYSIS_VIEW> get_VW_CONSOLIDARE_FULL_ANALYSIS_VIEW() {
		return this.vwConsolidareFullAnalysisViewRepository.get_VW_CONSOLIDARE_FULL_ANALYSIS_VIEW();
	}

	@Autowired
	private FACT_PRODUCT_REVIEWS_VIEW_Repository factProductReviewsViewRepository;
	@CrossOrigin(origins = "*")
	@GetMapping(value = "/FACT_PRODUCT_REVIEWS_VIEW", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<FACT_PRODUCT_REVIEWS_VIEW> get_FACT_PRODUCT_REVIEWS_VIEW() {
		return this.factProductReviewsViewRepository.get_FACT_PRODUCT_REVIEWS_VIEW();
	}


	@Autowired
	private DIM_PRODUCT_FULL_VIEW_Repository dimProductRepo;
	@CrossOrigin(origins = "*")
	@GetMapping(value = "/DIM_PRODUCT_FULL_VIEW", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<DIM_PRODUCT_FULL_VIEW> get_DIM_PRODUCT_FULL_VIEW() {
		return this.dimProductRepo.get_DIM_PRODUCT_FULL_VIEW();
	}





}