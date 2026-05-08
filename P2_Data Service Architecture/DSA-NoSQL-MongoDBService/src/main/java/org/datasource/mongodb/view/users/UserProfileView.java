package org.datasource.mongodb.view.users;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor(force = true)
@JsonIgnoreProperties({"_id"})
public class UserProfileView {
    public Profile profile;
    public List<String> segments;
}
