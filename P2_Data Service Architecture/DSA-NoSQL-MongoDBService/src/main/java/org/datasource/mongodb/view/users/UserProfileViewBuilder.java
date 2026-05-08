package org.datasource.mongodb.view.users;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.datasource.mongodb.MongoDataSourceConnector;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserProfileViewBuilder {

	// Data cache
	private List<UserProfileView> viewList = new ArrayList<>();
	//
	private MongoDataSourceConnector dataSourceConnector;
    //
	public List<UserProfileView> getViewList() {
		return viewList;
	}

	public UserProfileViewBuilder(MongoDataSourceConnector dataSourceConnector) {
		this.dataSourceConnector = dataSourceConnector;
	}

	// Builder Workflow
	public UserProfileViewBuilder build() throws Exception{
		return this.select();
	}
	
	public UserProfileViewBuilder select() throws Exception {
		MongoDatabase db = dataSourceConnector.getMongoDatabase();

		MongoCollection<UserProfileView> collection =
				db.getCollection("userss", UserProfileView.class);
		//
		 collection.find().forEach(u -> this.viewList.add(u));
		//
		viewList.forEach(System.out::println);
		//
		return this;
	}
}
