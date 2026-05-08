package org.datasource;

import org.datasource.mongodb.view.users.UserProfileView;
import org.datasource.mongodb.view.users.UserProfileViewBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.logging.Logger;


/*	REST Service URL
	http://localhost:8093/DSA-NoSQL-MongoDBService/rest/ecommerce/UserProfileView
*/
@RestController @RequestMapping("/ecommerce")
public class RESTViewServiceMongoDB {
	private static Logger logger = Logger.getLogger(RESTViewServiceMongoDB.class.getName());
	
	@RequestMapping(value = "/ping", method = RequestMethod.GET,
		produces = {MediaType.TEXT_PLAIN_VALUE})
	@ResponseBody
	public String pingDataSource() {
		logger.info(">>>> org.datasource.rest.RESTViewService(JSON) is Up!");
		return "Ping response from RESTViewServiceMongoDB!";
	}

	@RequestMapping(value = "/UserProfileView", method = RequestMethod.GET,
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<UserProfileView> get_UserProfile() throws Exception {
		List<UserProfileView> viewList = this.viewBuilder.build().getViewList();
		return viewList;
	}

	// Set-up 
	@Autowired private UserProfileViewBuilder viewBuilder;
}