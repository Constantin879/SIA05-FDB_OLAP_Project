package org.datasource.springdata.views;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name="products")
@Data @AllArgsConstructor @NoArgsConstructor


public class ProductsView {
    @Id
    @Column(name="product_id")
    private Integer product_id;
    @Column(name="product_name")
    private String product_name;
    @Column(name="category")
    private String category;
    @Column(name="sub_category")
    private String sub_category;
    @Column(name="brand")
    private String brand;
    @Column(name="price")
    private Integer price;
    @Column(name="discount")
    private Integer discount;
    @Column(name="stock_quantity")
    private Integer stock_quantity;
    @Column(name="average_rating")
    private Double average_rating;
    @Column(name="total_reviews")
    private Integer total_reviews;
    @Column(name="created_at")
    private LocalDateTime createdAt;
}
