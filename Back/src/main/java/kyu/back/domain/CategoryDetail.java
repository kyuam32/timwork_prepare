package kyu.back.domain;

import lombok.Getter;

import javax.persistence.*;

@Entity
@Getter
public class CategoryDetail {
    @Id
    @GeneratedValue
    @Column(name = "category_detail_id", nullable = false)
    private Long category_detail_id;

    private String name;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

}
