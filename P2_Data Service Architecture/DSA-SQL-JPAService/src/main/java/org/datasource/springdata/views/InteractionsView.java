package org.datasource.springdata.views;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name="interactions")
@Data @AllArgsConstructor @NoArgsConstructor
public class InteractionsView {
    @Id
    @Column(name="interaction_id")
    private Integer interaction_id;
    @Column(name="user_id")
    private Integer user_id;
    @Column(name="product_id")
    private Integer product_id;
    @Column(name="event_type")
    private String event_type;
    @Column(name="event_value")
    private Double event_value;
    @Column(name="timestamp")
    private LocalDateTime time_stamp;
    @Column(name="device_type")
    private String device_type;
    @Column(name="session_id")
    private String session_id;
}
