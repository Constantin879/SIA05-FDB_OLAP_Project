package org.j4di.access.views.products;


import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

import java.time.LocalDateTime;



@Getter
@Entity
@Immutable
@Table(name="products_view")
public class PRODUCTS_VIEW {
    @Id
    private Integer product_id;
    private String product_name;
    private String category;
    private String sub_category;
    private String brand;
    private Integer price;
    private Integer discount;
    private Integer stock_quantity;
    private Double average_rating;
    private Integer total_reviews;
    private String createdAt;
}
