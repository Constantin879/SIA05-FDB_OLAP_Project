package org.datasource.mongodb.view.users;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor(force = true)
public class Profile{
    public Long user_id;
    public String user_name;
    public String email;
    public Long age;
    public String gender;
    public String city;
    public String signup_date;
}
