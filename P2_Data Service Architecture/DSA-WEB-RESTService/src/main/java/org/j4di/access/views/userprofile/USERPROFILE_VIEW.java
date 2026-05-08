package org.j4di.access.views.userprofile;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity // <--- ADĂUGAT: Spune Spring-ului că asta e o tabelă
@Table(name = "usersprofile_view") // <--- ADĂUGAT: Numele exact din DBeaver
public class USERPROFILE_VIEW {

    @Id // <--- ADĂUGAT: Orice entitate are nevoie de o cheie primară (folosim user_id)
    private Long user_id;

    private String user_name;
    private String email;
    private Long age;
    private String gender;
    private String city;
    private String signup_date;
    private String segment;
}