package org.j4di.access.views.interactions;


import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

//import java.time.LocalDateTime;



@Getter
@Entity
@Immutable
@Table(name="interactions_view")
public class INTERACTIONS_VIEW  {
    @Id
    private Integer interaction_id;
    private Integer user_id;
    private Integer product_id;
    private String event_type;
    private Double event_value;
    private String time_stamp;
    private String device_type;
    private String session_id;
}
